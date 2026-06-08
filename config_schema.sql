-- Tabla de configuracion del catalogo
CREATE TABLE IF NOT EXISTS config (
  clave TEXT PRIMARY KEY,
  valor TEXT NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE config ENABLE ROW LEVEL SECURITY;

-- Cualquiera puede leer la config (secciones, marcas, nombre)
CREATE POLICY "Config publica"
  ON config FOR SELECT
  USING (true);

-- Solo autenticados pueden modificar
CREATE POLICY "Admin modifica config"
  ON config FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Permisos
GRANT SELECT ON config TO anon;
GRANT ALL ON config TO authenticated;

-- Datos iniciales
INSERT INTO config (clave, valor) VALUES
  ('secciones', '[{"id":"dama","label":"Dama"},{"id":"caballero","label":"Caballero"},{"id":"lociones","label":"Lociones"},{"id":"otras","label":"Otras Marcas"},{"id":"ofertas","label":"Ofertas"}]'),
  ('marcas', '["Puma","Adidas","Nike","New Balance"]'),
  ('nombre', 'Collection Fe & Style'),
  ('whatsapp', '50299998888')
ON CONFLICT (clave) DO NOTHING;
