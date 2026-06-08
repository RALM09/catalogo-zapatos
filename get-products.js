const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY  // service key para escritura
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

  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, headers, body: JSON.stringify({ error: 'Metodo no permitido' }) };
  }

  // Verificar password de admin
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

    // Subir imagenes a Supabase Storage
    const imageUrls = [];
    for (let i = 0; i < (imagenes || []).length; i++) {
      const imgData = imagenes[i]; // base64 string
      const base64 = imgData.replace(/^data:image\/\w+;base64,/, '');
      const buffer = Buffer.from(base64, 'base64');
      const fileName = `${Date.now()}_${i}.jpg`;

      const { data: uploadData, error: uploadError } = await supabase.storage
        .from('imagenes-productos')
        .upload(fileName, buffer, { contentType: 'image/jpeg', upsert: false });

      if (uploadError) throw uploadError;

      const { data: urlData } = supabase.storage
        .from('imagenes-productos')
        .getPublicUrl(fileName);

      imageUrls.push(urlData.publicUrl);
    }

    // Insertar producto en la base de datos
    const { data, error } = await supabase
      .from('productos')
      .insert([{
        seccion,
        marca,
        talla: talla || '',
        codigo: codigo || '',
        precio: precio || '',
        imagenes: imageUrls,
        disponible: true
      }])
      .select()
      .single();

    if (error) throw error;

    return {
      statusCode: 201,
      headers,
      body: JSON.stringify(data)
    };
  } catch (err) {
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ error: err.message })
    };
  }
};
