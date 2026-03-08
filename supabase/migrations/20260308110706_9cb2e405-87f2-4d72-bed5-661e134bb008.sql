-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Anyone can delete accessories" ON public.accessories;
DROP POLICY IF EXISTS "Anyone can insert accessories" ON public.accessories;
DROP POLICY IF EXISTS "Anyone can update accessories" ON public.accessories;
DROP POLICY IF EXISTS "Anyone can view accessories" ON public.accessories;

-- Create PERMISSIVE policies that work for anon and authenticated users
CREATE POLICY "Anyone can view accessories"
ON public.accessories FOR SELECT
TO anon, authenticated
USING (true);

CREATE POLICY "Anyone can insert accessories"
ON public.accessories FOR INSERT
TO anon, authenticated
WITH CHECK (true);

CREATE POLICY "Anyone can update accessories"
ON public.accessories FOR UPDATE
TO anon, authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Anyone can delete accessories"
ON public.accessories FOR DELETE
TO anon, authenticated
USING (true);