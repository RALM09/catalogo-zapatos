# Catalogo de Zapatos — Guia de Instalacion
Todo gratuito. Tiempo estimado: 20-30 minutos.

---

## PASO 1: Crear cuenta en Supabase (base de datos)

1. Ir a https://supabase.com y crear cuenta gratuita
2. Crear un nuevo proyecto (cualquier nombre, ej: "catalogo-zapatos")
3. Esperar que se cree (1-2 minutos)
4. Ir a **SQL Editor** (menu izquierdo) y pegar TODO el contenido
   del archivo `supabase-schema.sql`, luego clic en **Run**
5. Anotar estas dos credenciales (Settings > API):
   - **Project URL** → algo como https://xxxx.supabase.co
   - **anon public key** → clave larga que empieza con "eyJ..."
   - **service_role key** → clave secreta (NO compartir nunca)

---

## PASO 2: Subir el proyecto a GitHub

1. Ir a https://github.com y crear cuenta gratuita
2. Crear un nuevo repositorio (ej: "catalogo-zapatos"), que sea **Public**
3. Subir todos los archivos de esta carpeta al repositorio
   (puedes arrastrarlos desde el boton "uploading an existing file")

---

## PASO 3: Desplegar en Netlify

1. Ir a https://netlify.com y crear cuenta gratuita
2. Clic en **Add new site** > **Import an existing project**
3. Conectar con GitHub y seleccionar tu repositorio
4. En Build settings dejar todo como esta y clic **Deploy site**
5. Esperar que termine el deploy (1-2 minutos)

---

## PASO 4: Configurar las variables de entorno

En Netlify, ir a **Site settings** > **Environment variables** y agregar:

| Variable              | Valor                                      |
|-----------------------|--------------------------------------------|
| SUPABASE_URL          | Tu Project URL de Supabase                 |
| SUPABASE_ANON_KEY     | Tu anon public key de Supabase             |
| SUPABASE_SERVICE_KEY  | Tu service_role key de Supabase            |
| ADMIN_PASSWORD        | La contrasena que quieras para el admin    |

Despues de agregar las variables, ir a **Deploys** > **Trigger deploy** para que tome efecto.

---

## PASO 5: Cambiar el numero de WhatsApp

En el archivo `public/index.html`, buscar esta linea:
```
var WA_NUMBER = "50212345678";
```
Cambiar por el numero real con codigo de pais:
- Guatemala: 502 + numero (ej: "50212345678")
- El Salvador: 503 + numero (ej: "503XXXXXXXX")

---

## LISTO! Tu catalogo esta en linea

- **Catalogo para clientes**: https://tu-sitio.netlify.app
- **Panel de admin**: https://tu-sitio.netlify.app/admin.html

---

## Como usar el panel de admin

### Agregar producto:
1. Ir a /admin.html e ingresar la contrasena
2. Clic en "+ Agregar producto"
3. Llenar: seccion, marca, talla, codigo, precio (opcional)
4. Subir las fotos del zapato (puedes subir varias a la vez)
5. Clic en "Guardar producto"

### Marcar como agotado (se vende el zapato):
- Clic en "Marcar agotado" en la tarjeta del producto
- El zapato desaparece del catalogo publico automaticamente
- Puedes volver a marcarlo disponible cuando tengas stock

### Eliminar producto:
- Clic en "Eliminar" en la tarjeta del producto
- Esta accion borra el producto y sus fotos permanentemente

---

## Limites del plan gratuito (mas que suficiente)

| Servicio  | Limite gratuito                              |
|-----------|----------------------------------------------|
| Netlify   | 100 GB de bandwidth/mes, 125k peticiones/mes |
| Supabase  | 500 MB base de datos, 1 GB storage imagenes  |
