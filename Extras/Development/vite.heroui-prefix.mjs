import prefixSelector from 'postcss-prefix-selector'

const PREFIX = '.heroui'
const DARK = `[data-theme="nova-dark"] ${PREFIX}, [data-theme="admin-dark"] ${PREFIX}`

function quotedTheme(value) {
  return new RegExp(`^\\[data-theme=(["']?)${value}\\1\\]$`)
}

function hostTheme(value) {
  return new RegExp(`^:host\\(\\[data-theme=(["']?)${value}\\1\\]\\)$`)
}

export function isLightRoot(selector) {
  const s = selector.trim()
  return (
    s === ':root' ||
    s === ':host' ||
    s === '.light' ||
    s === '.default' ||
    s === ':host(.light)' ||
    s === ':host(.default)' ||
    quotedTheme('light').test(s) ||
    quotedTheme('default').test(s) ||
    hostTheme('light').test(s) ||
    hostTheme('default').test(s)
  )
}

export function isDarkRoot(selector) {
  const s = selector.trim()
  return (
    s === '.dark' ||
    s === 'html.dark' ||
    s === ':host(.dark)' ||
    quotedTheme('dark').test(s) ||
    hostTheme('dark').test(s) ||
    /^html\[data-theme=(["']?)dark\1\]$/.test(s)
  )
}

function stripNotDark(selector) {
  return selector
    .replaceAll(':not(.dark)', '')
    .replace(/:not\(\[data-theme=(["']?)dark\1\]\)/g, '')
}

function stripLeadingDark(selector) {
  const s = selector.trim()
  const leading = [
    /^:host\(\.dark\)\s+/,
    /^:host\(\[data-theme=(["']?)dark\1\]\)\s+/,
    /^html\.dark\s+/,
    /^html\[data-theme=(["']?)dark\1\]\s+/,
    /^\.dark(?=[\s.:#[>+~]|$)\s*/,
    /^\[data-theme=(["']?)dark\1\]\s+/
  ]
  for (const pattern of leading) {
    if (pattern.test(s)) {
      return s.replace(pattern, '').trim()
    }
  }
  return null
}

function hasSubjectDark(selector) {
  return /\[data-theme=(["']?)dark\1\]/.test(selector) || /\.dark(?=[\s.:#[>+~,]|$)/.test(selector)
}

function stripSubjectDark(selector) {
  return selector
    .replace(/\[data-theme=(["']?)dark\1\]/g, '')
    .replace(/\.dark(?=[\s.:#[>+~,]|$)/g, '')
    .replace(/\s+/g, ' ')
    .trim()
}

export function remapHeroUiTheme(selector) {
  let s = selector.trim()
  const withoutNotDark = stripNotDark(s)
  const hadNotDark = withoutNotDark !== s
  s = withoutNotDark

  if (isLightRoot(s)) {
    return PREFIX
  }
  if (isDarkRoot(s)) {
    return DARK
  }

  const leading = stripLeadingDark(s)
  if (leading !== null) {
    return leading ? `${DARK} ${leading}` : DARK
  }

  if (hasSubjectDark(s)) {
    const cleaned = stripSubjectDark(s)
    return cleaned ? `${DARK} ${cleaned}` : DARK
  }

  if (hadNotDark) {
    return s ? `${PREFIX} ${s}` : PREFIX
  }

  return null
}

const COLLIDING_ROOTS = [
  'avatar',
  'card',
  'input-group',
  'input',
  'textarea',
  'label',
  'select',
  'switch',
  'checkbox',
  'radio',
  'badge',
  'menu',
  'dropdown',
  'tooltip',
  'accordion',
  'breadcrumbs',
  'pagination',
  'skeleton',
  'kbd',
  'link'
]

export function aliasCollidingClasses(selector) {
  let s = selector
  for (const name of COLLIDING_ROOTS) {
    s = s.replaceAll(new RegExp(`\\.${name}(?=$|[\\s.:#[>+~,)]|__|--)`, 'g'), `.hui-${name}`)
  }
  return s
}

const SELF_SCOPED_BUTTON = /\.heroui (?=\.button(?:--[\w-]+)?(?=$|[\s.:#[>+~,)]))/g

export function selfScopeButton(selector) {
  const own = selector.replace(SELF_SCOPED_BUTTON, PREFIX)
  return own === selector ? selector : `${selector}, ${own}`
}

export function rewriteHeroUiSelector(selector) {
  const s = selector.trim()
  let out

  if (s === PREFIX || s.startsWith(`${PREFIX}.`) || s.startsWith(`${PREFIX}:`) || s.startsWith(`${PREFIX}[`)) {
    out = s
  } else if (/^\[data-theme=(["']?)(?:nova-dark|admin|admin-dark)\1\]/.test(s)) {
    out = s
  } else if (s.startsWith(`${PREFIX} `)) {
    const remapped = remapHeroUiTheme(s.slice(PREFIX.length).trim())
    out = remapped || s
  } else {
    const remapped = remapHeroUiTheme(s)
    out = remapped || `${PREFIX} ${s}`
  }

  return selfScopeButton(aliasCollidingClasses(out))
}

export function herouiPrefixPlugin() {
  return prefixSelector({
    prefix: PREFIX,
    exclude: ['::view-transition'],
    transform(_prefix, selector) {
      return rewriteHeroUiSelector(selector)
    }
  })
}

const COLLIDING_KEYFRAMES = ['skeleton']

export function herouiKeyframesPlugin() {
  const names = new RegExp(`(?<![\\w-])(${COLLIDING_KEYFRAMES.join('|')})(?![\\w-])`, 'g')
  return {
    postcssPlugin: 'heroui-keyframes',
    Once(root) {
      root.walkAtRules(/keyframes$/, (rule) => {
        if (COLLIDING_KEYFRAMES.includes(rule.params.trim())) {
          rule.params = `hui-${rule.params.trim()}`
        }
      })
      root.walkDecls(/^animation(-name)?$/, (decl) => {
        decl.value = decl.value.replace(names, 'hui-$1')
      })
    }
  }
}
herouiKeyframesPlugin.postcss = true
