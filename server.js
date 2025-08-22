import express from 'express';
import TelegramBot from 'node-telegram-bot-api';
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const port = process.env.PORT || 3000;

// Initialize Supabase client
const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_ANON_KEY
);

// Initialize Telegram Bot
const bot = new TelegramBot(process.env.TELEGRAM_BOT_TOKEN, { polling: false });

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/public', express.static(path.join(__dirname, 'public')));

// Serve static files
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.php'));
});

app.get('/demo.php', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'demo.php'));
});

// Telegram webhook endpoint
app.post('/telegram', async (req, res) => {
  try {
    const update = req.body;
    
    if (update.message) {
      await handleMessage(update.message);
    } else if (update.web_app_data) {
      await handleWebAppData(update.web_app_data, update.from);
    }
    
    res.status(200).send('OK');
  } catch (error) {
    console.error('Webhook error:', error);
    res.status(500).send('Error');
  }
});

// Handle regular messages
async function handleMessage(message) {
  const chatId = message.chat.id;
  const text = message.text;

  if (text === '/start' || text === '/order') {
    await bot.sendMessage(chatId, "*Let's get started* 🍟 \n\nPlease tap the button below to order your perfect lunch!", {
      parse_mode: 'Markdown',
      reply_markup: {
        inline_keyboard: [[
          {
            text: 'Order Food',
            web_app: { url: `${process.env.RESOURCE_PATH}` }
          }
        ]]
      }
    });
  } else if (text === '/test') {
    await bot.sendMessage(chatId, "Please tap the button below to open the web app!", {
      parse_mode: 'Markdown',
      reply_markup: {
        inline_keyboard: [[
          {
            text: 'Test',
            web_app: { url: `${process.env.RESOURCE_PATH}demo.php` }
          }
        ]]
      }
    });
  } else if (text === '/help') {
    await bot.sendMessage(chatId, 
      "This is the help page. You can use the following commands:\n\n" +
      "/start - Start the bot\n" +
      "/order - Order food\n" +
      "/test - Test the web app\n" +
      "/help - Show this help page"
    );
  }
}

// Handle WebApp data
async function handleWebAppData(webAppData, user) {
  const data = JSON.parse(webAppData.data);
  
  if (data.method === 'makeOrder') {
    const orderText = await parseOrder(data.order_data);
    
    await bot.sendMessage(user.id, 
      "Your order has been placed successfully! 🍟\n\n" +
      `Your order is: \n\`${orderText}\`\n` +
      "Your order will be delivered to you in 30 minutes. 🚚",
      { parse_mode: 'Markdown' }
    );
  } else if (data.method === 'sendMessage') {
    const messageOptions = {
      parse_mode: 'Markdown',
      text: "Hello World!"
    };
    
    if (data.with_webview) {
      messageOptions.reply_markup = {
        inline_keyboard: [[
          {
            text: 'Open WebApp',
            web_app: { url: process.env.RESOURCE_PATH }
          }
        ]]
      };
    }
    
    await bot.sendMessage(user.id, messageOptions.text, messageOptions);
  }
}

// Parse order data using Supabase
async function parseOrder(orderData = '[]') {
  if (orderData === '[]') {
    return 'Nothing';
  }

  try {
    const order = JSON.parse(orderData);
    let orderText = '';
    
    // Get menu items from Supabase
    const { data: menuItems, error } = await supabase
      .from('menu_items')
      .select('id, name, emoji, base_price, markup_price, final_price')
      .in('id', order.map(item => item.id));
    
    if (error) {
      console.error('Error fetching menu items:', error);
      return 'Error processing order';
    }
    
    for (const orderItem of order) {
      const menuItem = menuItems.find(item => item.id === orderItem.id);
      if (menuItem) {
        const totalPrice = (menuItem.final_price || menuItem.base_price + (menuItem.markup_price || 0)) * orderItem.count;
        orderText += `${orderItem.count}x ${menuItem.name} ${menuItem.emoji} $${(totalPrice / 100).toFixed(2)}\n`;
      }
    }
    
    return orderText;
  } catch (error) {
    console.error('Error parsing order:', error);
    return 'Error processing order';
  }
}

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Set webhook
async function setWebhook() {
  try {
    const webhookUrl = `${process.env.REMOTE_PATH}/telegram`;
    await bot.setWebHook(webhookUrl);
    console.log(`Webhook set to: ${webhookUrl}`);
  } catch (error) {
    console.error('Error setting webhook:', error);
  }
}

// Start server
app.listen(port, async () => {
  console.log(`Server running on port ${port}`);
  
  if (process.env.NODE_ENV === 'production') {
    await setWebhook();
  }
});

export default app;