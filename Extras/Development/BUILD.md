# Sngine theme build files

Use these files only if you want to change the Nova theme styles. Sngine already ships the built files in `content/themes/nova/dist/`, so a site runs without them.

## Install

1. Copy everything in this folder into your Sngine root folder. Keep the folder structure as it is.
2. Install [Node.js](https://nodejs.org) 22.12 or newer.
3. Open a terminal in your Sngine root folder and run:

```bash
npm install --legacy-peer-deps
```

## Edit the styles

The style sources are in `content/themes/nova/src/css/`:

| File | Used for |
| --- | --- |
| `app.css` | The site, including its colors in light and dark mode |
| `admin.css` | The admin panel |
| `heroui.css` | Buttons, modals and other HeroUI components |
| `_layout.css` | Base page styles shared by the site |

The theme uses [Tailwind CSS](https://tailwindcss.com) and [FlyonUI](https://flyonui.com). Classes you add to templates in `content/themes/nova/templates/` are picked up when you build.

Do not edit or delete `_safelist.app.css` and `_safelist.admin.css`. They keep the styles for modules that may not be installed on your site.

## Build

```bash
npm run build
```

This writes the new files to `content/themes/nova/dist/`. Upload that folder to your server.

## Live preview (optional)

1. Add this line to `includes/config.php`:

```php
define('VITE_DEV_SERVER', 'http://localhost:5173');
```

2. Run:

```bash
npm run dev
```

Your local site now loads the styles from the dev server and updates as you save. Remove the line from `includes/config.php` when you are done, then run `npm run build`.

## After a Sngine update

Updates replace `content/themes/nova/dist/` and these build files. Copy your changes to the new `src/css/` files, then run `npm run build` again.
