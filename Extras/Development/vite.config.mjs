import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'
import postcss from 'postcss'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import { herouiKeyframesPlugin, herouiPrefixPlugin } from './vite.heroui-prefix.mjs'

const ROOT = dirname(fileURLToPath(import.meta.url))
const THEMES = ['nova']

function herouiScopePlugin() {
  const prefixer = herouiPrefixPlugin()
  const keyframes = herouiKeyframesPlugin()

  async function prefixCss(css) {
    const result = await postcss([prefixer, keyframes]).process(css, { from: 'heroui.css' })
    return result.css
  }

  return {
    name: 'heroui-scope',
    enforce: 'post',
    async transform(code, id) {
      const file = id.split('?')[0].replaceAll('\\', '/')
      const scoped =
        file.endsWith('/heroui.css') ||
        file.endsWith('/_heroui.css') ||
        file.includes('/@heroui/styles/') ||
        file.includes('/tw-animate-css/')
      if (!scoped) {
        return
      }
      return {
        code: await prefixCss(code),
        map: null
      }
    },
    async generateBundle(_options, bundle) {
      for (const chunk of Object.values(bundle)) {
        if (chunk.type !== 'asset' || typeof chunk.source !== 'string' || !chunk.fileName.endsWith('.css')) {
          continue
        }
        if (!chunk.fileName.includes('heroui')) {
          continue
        }
        chunk.source = await prefixCss(chunk.source)
      }
    }
  }
}

export default defineConfig(({ mode }) => {
  const theme = THEMES.includes(mode) ? mode : 'nova'
  const root = resolve(ROOT, 'content/themes', theme)

  return {
    base: './',
    plugins: [tailwindcss(), herouiScopePlugin()],
    build: {
      manifest: true,
      outDir: resolve(root, 'dist'),
      emptyOutDir: true,
      rollupOptions: {
        input: {
          app: resolve(root, 'src/css/app.css'),
          admin: resolve(root, 'src/css/admin.css'),
          heroui: resolve(root, 'src/css/heroui.css'),
          ...(theme === 'nova' ? { emojis: resolve(ROOT, 'includes/assets/js/core/emojis.js') } : {})
        }
      }
    },
    server: {
      port: 5173,
      strictPort: true,
      origin: 'http://localhost:5173',
      cors: { origin: /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/ }
    }
  }
})
