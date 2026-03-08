import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-admin-password',
  'Access-Control-Allow-Methods': 'POST, DELETE, OPTIONS',
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders })
  }

  try {
    const adminPassword = req.headers.get('x-admin-password')
    const expectedPassword = Deno.env.get('ADMIN_PASSWORD')

    if (!adminPassword || adminPassword !== expectedPassword) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized - Invalid admin password' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Create Supabase client with service role (bypasses RLS)
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    const body = await req.json()
    const { action, data, id } = body

    if (action === 'insert') {
      const { data: result, error } = await supabase
        .from('accessories')
        .insert({
          name: data.name,
          category: data.category,
          description: data.description,
          stl_name: data.stl_name,
          stl_file: data.stl_file,
          images: data.images || [],
          badge: data.badge
        })
        .select()
        .single()

      if (error) throw error
      return new Response(
        JSON.stringify({ success: true, data: result }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    if (action === 'update') {
      if (!id) throw new Error('ID required for update')
      
      const { data: result, error } = await supabase
        .from('accessories')
        .update({
          name: data.name,
          category: data.category,
          description: data.description,
          stl_name: data.stl_name,
          stl_file: data.stl_file,
          images: data.images || [],
          badge: data.badge
        })
        .eq('id', id)
        .select()
        .single()

      if (error) throw error
      return new Response(
        JSON.stringify({ success: true, data: result }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    if (action === 'delete') {
      if (!id) throw new Error('ID required for delete')
      
      const { error } = await supabase
        .from('accessories')
        .delete()
        .eq('id', id)

      if (error) throw error
      return new Response(
        JSON.stringify({ success: true }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    return new Response(
      JSON.stringify({ error: 'Invalid action' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})