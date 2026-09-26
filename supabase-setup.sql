-- ==============================================================================
-- POUL COLLECTIONS - SUPABASE DATABASE & STORAGE SETUP
-- ==============================================================================
-- Run this script in your Supabase Dashboard:
-- 1. Go to https://supabase.com and open your project.
-- 2. Click on "SQL Editor" in the left sidebar.
-- 3. Click "New Query", paste this entire file, and click "Run".
-- ==============================================================================

-- 1. Create the products table
CREATE TABLE IF NOT EXISTS public.products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  price TEXT NOT NULL,
  description TEXT,
  image TEXT NOT NULL,
  delivery TEXT DEFAULT '2-4 days in Nairobi',
  created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.products
  DROP CONSTRAINT IF EXISTS products_category_check,
  ADD CONSTRAINT products_category_check
    CHECK (category IN ('Suits', 'Polos', 'Hoods', 'Caps', 'School Uniforms'));

-- Create indexes for fast filtering
CREATE INDEX IF NOT EXISTS idx_products_category ON public.products(category);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON public.products(created_at DESC);

-- Enable Row Level Security (RLS)
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read access" ON public.products;
DROP POLICY IF EXISTS "Allow public insert" ON public.products;
DROP POLICY IF EXISTS "Allow public delete" ON public.products;
DROP POLICY IF EXISTS "Allow public update" ON public.products;

-- Allow anyone to view products (Storefront read access)
CREATE POLICY "Allow public read access" 
  ON public.products 
  FOR SELECT 
  USING (true);

-- Allow product creations (Admin panel access)
CREATE POLICY "Allow public insert" 
  ON public.products 
  FOR INSERT 
  WITH CHECK (true);

-- Allow product deletions (Admin panel access)
CREATE POLICY "Allow public delete" 
  ON public.products 
  FOR DELETE 
  USING (true);

-- Allow product updates (Admin panel access)
CREATE POLICY "Allow public update" 
  ON public.products 
  FOR UPDATE 
  USING (true);

-- Enable live product changes for the storefront
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_publication
    WHERE pubname = 'supabase_realtime'
  ) THEN
    RAISE EXCEPTION 'Supabase publication supabase_realtime was not found.';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
      AND schemaname = 'public'
      AND tablename = 'products'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.products;
  END IF;
END
$$;

-- ==============================================================================
-- 2. Storage Setup for Product Photography
-- ==============================================================================

-- Create public storage bucket 'product-images' if it doesn't already exist
INSERT INTO storage.buckets (id, name, public) 
VALUES ('product-images', 'product-images', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Drop existing storage policies if they exist to avoid duplicates
DO $$
BEGIN
  DROP POLICY IF EXISTS "Public Access" ON storage.objects;
  DROP POLICY IF EXISTS "Public Upload" ON storage.objects;
  DROP POLICY IF EXISTS "Public Delete" ON storage.objects;
EXCEPTION
  WHEN undefined_object THEN NULL;
END $$;

-- Allow public viewing of images
CREATE POLICY "Public Access" 
  ON storage.objects 
  FOR SELECT 
  USING (bucket_id = 'product-images');

-- Allow image uploads from admin panel
CREATE POLICY "Public Upload" 
  ON storage.objects 
  FOR INSERT 
  WITH CHECK (bucket_id = 'product-images');

-- Allow image deletions from admin panel
CREATE POLICY "Public Delete" 
  ON storage.objects 
  FOR DELETE 
  USING (bucket_id = 'product-images');

-- ==============================================================================
-- 3. Initial Sample Catalog (Optional Seed Data)
-- ==============================================================================

INSERT INTO public.products (name, category, price, description, image, delivery)
VALUES 
(
  'The Sovereign Midnight Suit',
  'Suits',
  'KSh 28,500',
  'Tailored double-breasted suit in high-twist Italian wool blend with structured shoulders and peak lapels.',
  'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?auto=format&fit=crop&w=1000&q=85',
  '2-4 days in Nairobi'
),
(
  'The Obsidian Minimalist Polo',
  'Polos',
  'KSh 6,800',
  'Mercerized Egyptian long-staple cotton polo with seamless collar and mother-of-pearl accents.',
  'https://images.unsplash.com/photo-1581655353564-df123a1eb820?auto=format&fit=crop&w=1000&q=85',
  '2-4 days in Nairobi'
),
(
  'The Savile Sand Structured Suit',
  'Suits',
  'KSh 32,000',
  'Breathable natural linen-wool blend engineered for tropical daylight elegance and evening poise.',
  'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1000&q=85',
  '2-4 days in Nairobi'
),
(
  'The Nairobi Ochre Knit Polo',
  'Polos',
  'KSh 7,400',
  'Fine-gauge ribbed knit polo reflecting Nairobi earth tones with tailored silhouette and open placket.',
  'https://images.unsplash.com/photo-1625910513413-56275c120ec2?auto=format&fit=crop&w=1000&q=85',
  '2-4 days in Nairobi'
)
ON CONFLICT DO NOTHING;
