const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  'https://qsrnvaxoogtvxkkfgxmi.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzcm52YXhvb2d0dnhra2ZneG1pIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4MDkxOTg2NSwiZXhwIjoyMDk2NDk1ODY1fQ.w3PmWe9tjWVtRmlJPck8ocOGPDmZgFfaJgt__ZvC53M'
);

exports.handler = async (event) => {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Content-Type': 'application/json'
  };

  if (event.httpMethod === 'OPTIONS') return { statusCode: 200, headers, body: '' };
  if (event.httpMethod !== 'POST') return { statusCode: 405, headers, body: JSON.stringify({ error: 'Metodo no permitido' }) };

  const auth = event.headers['authorization'] || '';
  if (auth !== 'Bearer ' + process.env.ADMIN_PASSWORD) {
    return { statusCode: 401, headers, body: JSON.stringify({ error: 'No autorizado' }) };
  }

  try {
    const body = JSON.parse(event.body);
    const { seccion, marca, talla, codigo, precio, imagenes } = body;

    if (!seccion || !marca) {
      return { statusCode: 400, headers, body: JSON.stringify({ error: 'Seccion y marca son requeridos' }) };
    }

    const imageUrls = [];
    for (let i = 0; i < (imagenes || []).length; i++) {
      const base64 = imagenes[i].replace(/^data:image\/\w+;base64,/, '');
      const buffer = Buffer.from(base64, 'base64');
      const fileName = Date.now() + '_' + i + '.jpg';

      const { error: uploadError } = await supabase.storage
        .from('imagenes-productos')
        .upload(fileName, buffer, { contentType: 'image/jpeg', upsert: false });

      if (uploadError) throw uploadError;

      const { data: urlData } = supabase.storage
        .from('imagenes-productos')
        .getPublicUrl(fileName);

      imageUrls.push(urlData.publicUrl);
    }

    const { data, error } = await supabase
      .from('productos')
      .insert([{ seccion, marca, talla: talla||'', codigo: codigo||'', precio: precio||'', imagenes: imageUrls, disponible: true }])
      .select()
      .single();

    if (error) throw error;
    return { statusCode: 201, headers, body: JSON.stringify(data) };
  } catch (err) {
    return { statusCode: 500, headers, body: JSON.stringify({ error: err.message }) };
  }
};
