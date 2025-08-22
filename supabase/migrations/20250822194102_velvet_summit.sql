/*
  # Seed Sample Restaurant and Menu Data

  1. Sample Data
    - Create a sample restaurant "Durger King"
    - Add menu items matching the original hardcoded items
    - Add detailed food information for each item

  2. Data Structure
    - All prices are stored in cents (multiply by 100)
    - Includes both English and Uzbek names
    - Comprehensive food information with nutrition data
*/

-- Insert sample restaurant
INSERT INTO restaurants (id, name, is_open, description, rating, display_order) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Durger King', true, 'Fast food restaurant with delicious burgers and more!', 4.5, 1)
ON CONFLICT (id) DO NOTHING;

-- Insert sample menu items
INSERT INTO menu_items (id, restaurant_id, name, name_uz, base_price, emoji, category, ingredients, is_available) VALUES
('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'Burger', 'Burger', 499, '🍔', 'main', ARRAY['beef patty', 'bun', 'lettuce', 'tomato', 'cheese'], true),
('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000', 'Fries', 'Kartoshka fri', 149, '🍟', 'sides', ARRAY['potatoes', 'salt', 'oil'], true),
('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440000', 'Hotdog', 'Hot-dog', 349, '🌭', 'main', ARRAY['sausage', 'bun', 'mustard', 'ketchup'], true),
('550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440000', 'Tako', 'Tako', 399, '🌮', 'main', ARRAY['tortilla', 'beef', 'lettuce', 'cheese', 'salsa'], true),
('550e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440000', 'Pizza', 'Pitsa', 799, '🍕', 'main', ARRAY['dough', 'tomato sauce', 'cheese', 'pepperoni'], true),
('550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440000', 'Donut', 'Donut', 149, '🍩', 'dessert', ARRAY['flour', 'sugar', 'oil', 'glaze'], true),
('550e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440000', 'Popcorn', 'Popkorn', 199, '🍿', 'snacks', ARRAY['corn', 'butter', 'salt'], true),
('550e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440000', 'Coke', 'Kola', 149, '🥤', 'drinks', ARRAY['carbonated water', 'sugar', 'caffeine'], true),
('550e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440000', 'Cake', 'Tort', 1099, '🍰', 'dessert', ARRAY['flour', 'eggs', 'sugar', 'cream'], true),
('550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440000', 'Icecream', 'Muzqaymoq', 599, '🍦', 'dessert', ARRAY['milk', 'cream', 'sugar', 'vanilla'], true),
('550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440000', 'Cookie', 'Pechene', 399, '🍪', 'dessert', ARRAY['flour', 'butter', 'sugar', 'chocolate chips'], true),
('550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440000', 'Flan', 'Flan', 799, '🍮', 'dessert', ARRAY['eggs', 'milk', 'sugar', 'caramel'], true)
ON CONFLICT (id) DO NOTHING;

-- Insert detailed food information
INSERT INTO food_info (menu_item_id, description, description_uz, ingredients_detailed, allergens, nutrition_info, preparation_time, calories, is_vegetarian, is_halal, is_spicy, spice_level, chef_recommendation) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Juicy beef burger with fresh vegetables', 'Yangi sabzavotlar bilan mazali mol go''shti burger', ARRAY['100% beef patty', 'sesame seed bun', 'iceberg lettuce', 'fresh tomato', 'cheddar cheese', 'special sauce'], ARRAY['gluten', 'dairy', 'sesame'], '{"protein": 25, "carbs": 35, "fat": 20, "fiber": 3}', 8, 520, false, true, false, 0, 'Our signature burger - a customer favorite!'),
('550e8400-e29b-41d4-a716-446655440002', 'Crispy golden french fries', 'Oltin rangli kartoshka fri', ARRAY['fresh potatoes', 'vegetable oil', 'sea salt'], ARRAY[], '{"protein": 4, "carbs": 45, "fat": 15, "fiber": 4}', 5, 365, true, true, false, 0, 'Perfect side dish for any meal'),
('550e8400-e29b-41d4-a716-446655440003', 'Classic hotdog with premium sausage', 'Premium kolbasa bilan klassik hot-dog', ARRAY['beef sausage', 'hotdog bun', 'yellow mustard', 'ketchup', 'onions'], ARRAY['gluten'], '{"protein": 15, "carbs": 25, "fat": 18, "fiber": 2}', 6, 290, false, true, false, 0, 'Simple and delicious - a timeless classic'),
('550e8400-e29b-41d4-a716-446655440004', 'Mexican-style taco with seasoned beef', 'Ziravorli mol go''shti bilan meksika uslubidagi tako', ARRAY['corn tortilla', 'seasoned ground beef', 'lettuce', 'cheddar cheese', 'salsa', 'sour cream'], ARRAY['dairy'], '{"protein": 20, "carbs": 30, "fat": 16, "fiber": 5}', 7, 380, false, true, true, 2, 'Authentic flavors with a perfect spice level'),
('550e8400-e29b-41d4-a716-446655440005', 'Wood-fired pizza with premium toppings', 'Premium to''ldiruvchilar bilan o''tinli pechda pishirilgan pitsa', ARRAY['pizza dough', 'tomato sauce', 'mozzarella cheese', 'pepperoni', 'italian herbs'], ARRAY['gluten', 'dairy'], '{"protein": 28, "carbs": 55, "fat": 22, "fiber": 3}', 15, 680, false, true, false, 0, 'Made fresh daily with imported Italian ingredients'),
('550e8400-e29b-41d4-a716-446655440006', 'Sweet glazed donut', 'Shirin sirlangan donut', ARRAY['enriched flour', 'sugar', 'eggs', 'butter', 'vanilla glaze'], ARRAY['gluten', 'dairy', 'eggs'], '{"protein": 4, "carbs": 35, "fat": 12, "fiber": 1}', 3, 280, true, true, false, 0, 'Fresh baked every morning'),
('550e8400-e29b-41d4-a716-446655440007', 'Buttery movie theater popcorn', 'Sariyog''li kinoteater popkorni', ARRAY['popcorn kernels', 'butter flavoring', 'salt'], ARRAY[], '{"protein": 3, "carbs": 20, "fat": 8, "fiber": 4}', 4, 150, true, true, false, 0, 'Light and crunchy - perfect for sharing'),
('550e8400-e29b-41d4-a716-446655440008', 'Refreshing cola drink', 'Tetiklantiruvchi kola ichimlik', ARRAY['carbonated water', 'high fructose corn syrup', 'caramel color', 'phosphoric acid', 'natural flavors', 'caffeine'], ARRAY[], '{"protein": 0, "carbs": 39, "fat": 0, "fiber": 0}', 1, 140, true, true, false, 0, 'Ice cold and refreshing'),
('550e8400-e29b-41d4-a716-446655440009', 'Rich chocolate layer cake', 'Boy shokoladli qatlamli tort', ARRAY['chocolate cake layers', 'chocolate frosting', 'cocoa powder', 'heavy cream'], ARRAY['gluten', 'dairy', 'eggs'], '{"protein": 6, "carbs": 65, "fat": 25, "fiber": 3}', 45, 520, true, true, false, 0, 'Decadent dessert perfect for celebrations'),
('550e8400-e29b-41d4-a716-446655440010', 'Creamy vanilla ice cream', 'Kremli vanil muzqaymoq', ARRAY['fresh cream', 'milk', 'sugar', 'vanilla extract', 'egg yolks'], ARRAY['dairy', 'eggs'], '{"protein": 4, "carbs": 25, "fat": 14, "fiber": 0}', 2, 220, true, true, false, 0, 'Made with real vanilla beans'),
('550e8400-e29b-41d4-a716-446655440011', 'Chocolate chip cookies', 'Shokoladli chipli pechene', ARRAY['flour', 'butter', 'brown sugar', 'chocolate chips', 'vanilla'], ARRAY['gluten', 'dairy'], '{"protein": 3, "carbs": 28, "fat": 9, "fiber": 1}', 12, 180, true, true, false, 0, 'Warm and chewy with premium chocolate'),
('550e8400-e29b-41d4-a716-446655440012', 'Traditional caramel flan', 'An''anaviy karamel flan', ARRAY['eggs', 'condensed milk', 'sugar', 'vanilla', 'caramel sauce'], ARRAY['dairy', 'eggs'], '{"protein": 8, "carbs": 35, "fat": 12, "fiber": 0}', 60, 280, true, true, false, 0, 'Silky smooth custard with rich caramel')
ON CONFLICT (menu_item_id) DO NOTHING;