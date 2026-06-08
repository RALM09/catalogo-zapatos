-- Ejecutar este SQL en Supabase > SQL Editor

-- Tabla de productos
CREATE TABLE productos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  seccion TEXT NOT NULL CHECK (seccion IN ('dama','caballero','lociones','otras','ofertas')),
  marca TEXT NOT NULL,
  talla TEXT DEFAULT '',
  codigo TEXT DEFAULT '',
  precio TEXT DEFAULT '',
  imagenes TEXT[] DEFAULT '{}',
  disponible BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Habilitar lectura publica (el catalogo no requiere login)
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lectura publica de productos disponibles"
  ON productos FOR SELECT
  USING (disponible = true);

-- Bucket para las imagenes
INSERT INTO storage.buckets (id, name, public)
VALUES ('imagenes-productos', 'imagenes-productos', true);

-- Politica de storage: cualquiera puede ver las imagenes
CREATE POLICY "Imagenes publicas"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'imagenes-productos');

-- Solo el service role puede subir/borrar (lo hace la funcion de Netlify)
CREATE POLICY "Solo service role puede subir"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'imagenes-productos');

CREATE POLICY "Solo service role puede borrar"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'imagenes-productos');
