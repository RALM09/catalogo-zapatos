# Collection Fe & Style — Guia de Instalacion v2
Sin Netlify Functions. Todo gratuito. Tiempo estimado: 15 minutos.

---

## PASO 1: Limpiar y reconfigurar Supabase

1. Ve a Supabase > SQL Editor
2. Ejecuta TODO el contenido de `supabase-schema.sql`

## PASO 2: Crear usuario administrador en Supabase

1. En Supabase ve a **Authentication** > **Users**
2. Clic en **"Add user"** > **"Create new user"**
3. Ingresa un correo y contrasena (estos son los que usaras para entrar al admin)
4. Clic en **"Create user"**

IMPORTANTE: Anota bien el correo y contrasena, los necesitas para entrar al panel admin.

---

## PASO 3: Subir archivos a GitHub

1. En tu repositorio de GitHub, elimina los archivos viejos
2. Sube unicamente los archivos de esta carpeta:
   - public/index.html
   - public/admin.html
   - netlify.toml
   - supabase-schema.sql
   - README.md

NO necesitas la carpeta netlify/functions ni package.json en esta version.

---

## PASO 4: Deploy en Netlify

Netlify detectara el cambio en GitHub y hara deploy automatico.
Si no, ve a Deploys > Trigger deploy.

En Build settings asegurate que diga:
- Build command: (vacio, no necesita nada)
- Publish directory: public

---

## PASO 5: Cambiar numero de WhatsApp

En public/index.html busca:
  var WA_NUMBER = '50212345678';
Cambialo por el numero real con codigo de pais (502 para Guatemala).

---

## Usar el panel de admin

- URL: https://tu-sitio.netlify.app/admin.html
- Ingresa con el correo y contrasena que creaste en Supabase Authentication
- Desde ahi puedes agregar, marcar agotado o eliminar productos

---

## Limites gratuitos

| Servicio  | Limite gratuito                                    |
|-----------|----------------------------------------------------|
| Netlify   | 100 GB bandwidth/mes (solo archivos estaticos)     |
| Supabase  | 500 MB base de datos, 1 GB storage, 50k req/mes   |
