-- Agregar nuevos campos de configuracion
INSERT INTO config (clave, valor) VALUES
  ('subtitulo', 'Calzado & Lociones'),
  ('footer_texto', 'Todos los productos sujetos a disponibilidad de inventario.')
ON CONFLICT (clave) DO NOTHING;
