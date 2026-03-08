-- Drop existing permissive policies
DROP POLICY IF EXISTS "Anyone can delete accessories" ON public.accessories;
DROP POLICY IF EXISTS "Anyone can insert accessories" ON public.accessories;
DROP POLICY IF EXISTS "Anyone can update accessories" ON public.accessories;
DROP POLICY IF EXISTS "Anyone can view accessories" ON public.accessories;

-- Create new secure policies
-- Allow anyone to view accessories (public read)
CREATE POLICY "Public can view accessories"
ON public.accessories
FOR SELECT
TO anon, authenticated
USING (true);

-- Block direct INSERT/UPDATE/DELETE - these will only work via edge functions with service role
CREATE POLICY "No direct insert"
ON public.accessories
FOR INSERT
TO anon, authenticated
WITH CHECK (false);

CREATE POLICY "No direct update"
ON public.accessories
FOR UPDATE
TO anon, authenticated
USING (false)
WITH CHECK (false);

CREATE POLICY "No direct delete"
ON public.accessories
FOR DELETE
TO anon, authenticated
USING (false);