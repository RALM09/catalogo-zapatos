-- ─── CONFIGURACION DE PRECIOS ────────────────────────────────────────────────
INSERT INTO config (clave, valor) VALUES
  ('tipo_cambio',     '7.92'),
  ('porc_ganancia',   '40'),
  ('ganancia_zapatos','100'),
  ('ganancia_gorras', '50'),
  ('ganancia_perfumes','75'),
  ('ganancia_otras',  '75')
ON CONFLICT (clave) DO NOTHING;

-- ─── PROVEEDORES ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS proveedores (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre      TEXT NOT NULL,
  categoria   TEXT DEFAULT '',
  created_at  TIMESTAMPTZ DEFAULT now()
);

INSERT INTO proveedores (nombre, categoria) VALUES
  ('Puma',        'zapatos'),
  ('Adidas',      'zapatos'),
  ('Nike',        'zapatos'),
  ('New Balance', 'zapatos'),
  ('Perfumes',    'perfumes')
ON CONFLICT DO NOTHING;

-- ─── CAJAS / ENVIOS ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS cajas (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre              TEXT NOT NULL,
  fecha               DATE DEFAULT CURRENT_DATE,
  flete_dolares       NUMERIC(10,2) DEFAULT 175,
  tipo_cambio         NUMERIC(10,4) DEFAULT 7.92,
  total_productos     INTEGER DEFAULT 0,
  flete_por_producto  NUMERIC(10,4) GENERATED ALWAYS AS
                        (CASE WHEN total_productos > 0
                         THEN (flete_dolares * tipo_cambio) / total_productos
                         ELSE 0 END) STORED,
  notas               TEXT DEFAULT '',
  created_at          TIMESTAMPTZ DEFAULT now()
);

-- ─── FACTURAS ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS facturas (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  caja_id       UUID REFERENCES cajas(id) ON DELETE CASCADE,
  numero        TEXT NOT NULL,
  proveedor_id  UUID REFERENCES proveedores(id),
  propietario   TEXT CHECK (propietario IN ('Miriam','Raul')) DEFAULT 'Miriam',
  notas         TEXT DEFAULT '',
  created_at    TIMESTAMPTZ DEFAULT now()
);

-- ─── PRODUCTOS DE FACTURA ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS factura_productos (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  factura_id        UUID REFERENCES facturas(id) ON DELETE CASCADE,
  codigo            TEXT NOT NULL,
  nombre            TEXT DEFAULT '',
  precio_dolares    NUMERIC(10,2) DEFAULT 0,
  impuesto_dolares  NUMERIC(10,4) DEFAULT 0,
  -- Campos calculados (se guardan para historial)
  costo_quetzales   NUMERIC(10,2) DEFAULT 0,
  ganancia_mia      NUMERIC(10,2) DEFAULT 0,
  precio_venta      NUMERIC(10,2) DEFAULT 0,
  precio_vendedor   NUMERIC(10,2) DEFAULT 0,
  -- Vinculo con catalogo
  producto_id       UUID REFERENCES productos(id) ON DELETE SET NULL,
  created_at        TIMESTAMPTZ DEFAULT now()
);

-- ─── RLS (mismas políticas que productos) ────────────────────────────────────
ALTER TABLE proveedores       ENABLE ROW LEVEL SECURITY;
ALTER TABLE cajas             ENABLE ROW LEVEL SECURITY;
ALTER TABLE facturas          ENABLE ROW LEVEL SECURITY;
ALTER TABLE factura_productos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "auth_all_proveedores"       ON proveedores       FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all_cajas"             ON cajas             FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all_facturas"          ON facturas          FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all_factura_productos" ON factura_productos FOR ALL TO authenticated USING (true) WITH CHECK (true);

GRANT SELECT,INSERT,UPDATE,DELETE ON proveedores       TO authenticated;
GRANT SELECT,INSERT,UPDATE,DELETE ON cajas             TO authenticated;
GRANT SELECT,INSERT,UPDATE,DELETE ON facturas          TO authenticated;
GRANT SELECT,INSERT,UPDATE,DELETE ON factura_productos TO authenticated;
