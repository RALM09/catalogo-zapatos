const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

exports.handler = async (event) => {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Content-Type': 'application/json'
  };

  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 200, headers, body: '' };
  }

  if (event.httpMethod !== 'PATCH') {
    return { statusCode: 405, headers, body: JSON.stringify({ error: 'Metodo no permitido' }) };
  }

  const auth = event.headers['authorization'] || '';
  if (auth !== 'Bearer ' + process.env.ADMIN_PASSWORD) {
    return { statusCode: 401, headers, body: JSON.stringify({ error: 'No autorizado' }) };
  }

  try {
    const { id, disponible } = JSON.parse(event.body);
    if (!id) return { statusCode: 400, headers, body: JSON.stringify({ error: 'ID requerido' }) };

    const { data, error } = await supabase
      .from('productos')
      .update({ disponible })
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return { statusCode: 200, headers, body: JSON.stringify(data) };
  } catch (err) {
    return { statusCode: 500, headers, body: JSON.stringify({ error: err.message }) };
  }
};
