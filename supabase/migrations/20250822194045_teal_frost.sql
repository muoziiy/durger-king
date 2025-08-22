/*
  # Restaurant and Menu System Setup

  1. New Tables
    - `restaurants`
      - `id` (uuid, primary key)
      - `name` (text)
      - `is_open` (boolean, default true)
      - `image_url` (text)
      - `description` (text)
      - `rating` (numeric, default 4.0)
      - `display_order` (integer, default 0)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    
    - `menu_items`
      - `id` (uuid, primary key)
      - `restaurant_id` (uuid, foreign key)
      - `name` (text)
      - `name_uz` (text, Uzbek translation)
      - `base_price` (integer, price in cents)
      - `markup_price` (integer, default 0)
      - `final_price` (integer, computed)
      - `emoji` (text, default '🍽️')
      - `image_url` (text)
      - `category` (text, default 'asosiy')
      - `ingredients` (text array)
      - `is_new` (boolean, default false)
      - `is_available` (boolean, default true)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    
    - `food_info`
      - `id` (uuid, primary key)
      - `menu_item_id` (uuid, foreign key)
      - `description` (text)
      - `description_uz` (text)
      - `ingredients_detailed` (text array)
      - `allergens` (text array)
      - `nutrition_info` (jsonb)
      - `preparation_time` (integer, default 15)
      - `calories` (integer, default 0)
      - `is_vegetarian` (boolean, default false)
      - `is_halal` (boolean, default true)
      - `is_spicy` (boolean, default false)
      - `spice_level` (integer, 0-5, default 0)
      - `chef_recommendation` (text)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for public read access
    - Add policies for authenticated user management
*/

-- Create restaurants table
CREATE TABLE IF NOT EXISTS restaurants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  is_open boolean DEFAULT true,
  image_url text,
  description text,
  rating numeric(2,1) DEFAULT 4.0,
  display_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create menu_items table
CREATE TABLE IF NOT EXISTS menu_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id uuid REFERENCES restaurants(id) ON DELETE CASCADE,
  name text NOT NULL,
  name_uz text NOT NULL,
  base_price integer NOT NULL,
  markup_price integer DEFAULT 0,
  final_price integer GENERATED ALWAYS AS (base_price + markup_price) STORED,
  emoji text DEFAULT '🍽️',
  image_url text,
  category text DEFAULT 'asosiy',
  ingredients text[] DEFAULT '{}',
  is_new boolean DEFAULT false,
  is_available boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create food_info table
CREATE TABLE IF NOT EXISTS food_info (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_item_id uuid NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
  description text DEFAULT '',
  description_uz text DEFAULT '',
  ingredients_detailed text[] DEFAULT '{}',
  allergens text[] DEFAULT '{}',
  nutrition_info jsonb DEFAULT '{}',
  preparation_time integer DEFAULT 15,
  calories integer DEFAULT 0,
  is_vegetarian boolean DEFAULT false,
  is_halal boolean DEFAULT true,
  is_spicy boolean DEFAULT false,
  spice_level integer DEFAULT 0 CHECK (spice_level >= 0 AND spice_level <= 5),
  chef_recommendation text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE food_info ENABLE ROW LEVEL SECURITY;

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_restaurants_is_open ON restaurants(is_open);
CREATE INDEX IF NOT EXISTS idx_restaurants_display_order ON restaurants(display_order);
CREATE INDEX IF NOT EXISTS idx_menu_items_restaurant_id ON menu_items(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_category ON menu_items(category);
CREATE INDEX IF NOT EXISTS idx_food_info_menu_item_id ON food_info(menu_item_id);
CREATE INDEX IF NOT EXISTS idx_food_info_is_vegetarian ON food_info(is_vegetarian);
CREATE INDEX IF NOT EXISTS idx_food_info_is_halal ON food_info(is_halal);
CREATE INDEX IF NOT EXISTS idx_food_info_spice_level ON food_info(spice_level);

-- RLS Policies for restaurants
CREATE POLICY "Anyone can read restaurants"
  ON restaurants FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can manage restaurants"
  ON restaurants FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- RLS Policies for menu_items
CREATE POLICY "Anyone can read menu items"
  ON menu_items FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can manage menu items"
  ON menu_items FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- RLS Policies for food_info
CREATE POLICY "Anyone can read food info"
  ON food_info FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can manage food info"
  ON food_info FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);