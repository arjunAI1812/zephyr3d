-- Create accessories table for products
CREATE TABLE public.accessories (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'Other',
  description TEXT,
  stl_name TEXT,
  stl_file TEXT,
  images TEXT[] DEFAULT '{}',
  badge TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.accessories ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access (anyone can view products)
CREATE POLICY "Anyone can view accessories"
  ON public.accessories FOR SELECT
  USING (true);

-- Create policies for admin management (we'll handle admin auth separately)
-- For now, allow all mutations for simplicity - can be tightened later
CREATE POLICY "Anyone can insert accessories"
  ON public.accessories FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can update accessories"
  ON public.accessories FOR UPDATE
  USING (true);

CREATE POLICY "Anyone can delete accessories"
  ON public.accessories FOR DELETE
  USING (true);

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_accessories_updated_at
  BEFORE UPDATE ON public.accessories
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();