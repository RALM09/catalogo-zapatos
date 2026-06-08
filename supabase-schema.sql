-- =============================================
-- PASO 1: Crear la tabla de productos
-- =============================================
CREATE TABLE IF NOT EXISTS productos (
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

-- =============================================
-- PASO 2: Activar RLS
-- =============================================
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;

-- Cualquiera puede leer productos disponibles (catalogo publico)
CREATE POLICY "Lectura publica"
  ON productos FOR SELECT
  USING (disponible = true);

-- Solo usuarios autenticados (admin) pueden leer todos
CREATE POLICY "Admin lee todo"
  ON productos FOR SELECT
  TO authenticated
  USING (true);

-- Solo usuarios autenticados pueden insertar
CREATE POLICY "Admin inserta"
  ON productos FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Solo usuarios autenticados pueden actualizar
CREATE POLICY "Admin actualiza"
  ON productos FOR UPDATE
  TO authenticated
  USING (true);

-- Solo usuarios autenticados pueden eliminar
CREATE POLICY "Admin elimina"
  ON productos FOR DELETE
  TO authenticated
  USING (true);

-- =============================================
-- PASO 3: Bucket para imagenes
-- =============================================
INSERT INTO storage.buckets (id, name, public)
VALUES ('imagenes-productos', 'imagenes-productos', true)
ON CONFLICT DO NOTHING;

-- Cualquiera puede ver las imagenes
CREATE POLICY "Imagenes publicas"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'imagenes-productos');

-- Solo autenticados pueden subir
CREATE POLICY "Admin sube imagenes"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'imagenes-productos');

-- Solo autenticados pueden borrar
CREATE POLICY "Admin borra imagenes"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'imagenes-productos');
