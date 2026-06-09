'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { motion } from 'framer-motion'
import { cn } from '@/lib/utils'

const navItems = [
  { href: '/', label: 'Home' },
  { href: '/discover', label: 'Discover' },
  { href: '/launch', label: 'Launch' },
  { href: '/studio', label: 'Studio' },
  { href: '/dashboard', label: 'Dashboard' },
]

export function Navbar() {
  const pathname = usePathname()

  return (
    <motion.header 
      className="fixed top-0 left-0 right-0 z-50"
      initial={{ opacity: 0, y: -10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.8, delay: 0.2 }}
    >
      <div className="mx-auto max-w-screen-xl px-6 py-6">
        <div className="flex items-center justify-between">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-2.5 group">
            <div className="relative w-8 h-8 flex items-center justify-center">
              <div className="absolute inset-0 rounded-full border border-white/20 group-hover:border-white/40 transition-colors duration-500" />
              <div className="absolute inset-[5px] rounded-full border border-white/30 group-hover:border-white/50 transition-colors duration-500" />
              <div className="w-1.5 h-1.5 rounded-full bg-white/90" />
            </div>
            <span className="text-sm font-light tracking-[0.2em] text-foreground/90 group-hover:text-foreground transition-colors">
              KAGAMI
            </span>
          </Link>

          {/* Nav Links */}
          <nav className="hidden md:flex items-center gap-8">
            {navItems.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className={cn(
                  "text-[11px] tracking-[0.15em] uppercase transition-colors duration-300",
                  pathname === item.href
                    ? 'text-foreground'
                    : 'text-muted-foreground hover:text-foreground'
                )}
              >
                {item.label}
              </Link>
            ))}
          </nav>

          {/* Connect */}
          <button className="rounded-full border border-white/20 px-5 py-2 text-[11px] tracking-[0.15em] uppercase text-foreground/80 hover:bg-white/5 hover:border-white/30 transition-all duration-300">
            Connect
          </button>
        </div>
      </div>
    </motion.header>
  )
}
