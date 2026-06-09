export const KAGAMI_ROUTES = {
  home: '/',
  discover: '/discover',
  launch: '/launch',
  studio: '/studio',
  dashboard: '/dashboard',
  agents: '/agents',
  governance: '/governance',
  docs: '/docs',
} as const

export const KAGAMI_NAV_ITEMS = [
  { href: KAGAMI_ROUTES.home, label: 'Home' },
  { href: KAGAMI_ROUTES.discover, label: 'Discover' },
  { href: KAGAMI_ROUTES.launch, label: 'Launch' },
  { href: KAGAMI_ROUTES.studio, label: 'Studio' },
  { href: KAGAMI_ROUTES.dashboard, label: 'Dashboard' },
] as const

