'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'
import { Navbar } from '@/components/kagami/navbar'

const categories = ['All', 'Trending', 'Memes', 'AI', 'DeFi', 'Gaming', 'Art']

const reflections = [
  { id: 1, name: 'Doge Reborn', creator: '0x1a2...3b4c', category: 'Memes', price: '$0.0042', change: '+156%', volume: '$1.2M' },
  { id: 2, name: 'Neural Agent', creator: '0x5d6...7e8f', category: 'AI', price: '$2.34', change: '+42%', volume: '$890K' },
  { id: 3, name: 'Pixel Lords', creator: '0x9g0...1h2i', category: 'Gaming', price: '$0.89', change: '+28%', volume: '$456K' },
  { id: 4, name: 'Yield Oracle', creator: '0x3j4...5k6l', category: 'DeFi', price: '$12.50', change: '+15%', volume: '$2.1M' },
  { id: 5, name: 'Abstract Dreams', creator: '0x7m8...9n0o', category: 'Art', price: '$0.056', change: '-8%', volume: '$123K' },
  { id: 6, name: 'Frog Nation', creator: '0xpq1...2rs3', category: 'Memes', price: '$0.0089', change: '+89%', volume: '$567K' },
]

export default function DiscoverPage() {
  const [activeCategory, setActiveCategory] = useState('All')
  const [search, setSearch] = useState('')

  const filtered = reflections.filter(r => 
    (activeCategory === 'All' || r.category === activeCategory) &&
    r.name.toLowerCase().includes(search.toLowerCase())
  )

  return (
    <main className="min-h-screen bg-background">
      <Navbar />
      
      <div className="pt-28 pb-20 px-6">
        <div className="mx-auto max-w-5xl">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8 }}
          >
            <h1 className="text-2xl font-light tracking-tight text-foreground">Discover</h1>
            <p className="mt-2 text-sm text-muted-foreground font-light">Explore reflections</p>
          </motion.div>

          {/* Search */}
          <motion.div
            className="mt-10"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8, delay: 0.1 }}
          >
            <div className="relative">
              <input
                type="text"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                placeholder="Search..."
                className="w-full rounded-lg border border-border/30 bg-transparent px-5 py-3 text-sm text-foreground placeholder:text-muted-foreground/50 focus:outline-none focus:border-white/30 transition-colors"
              />
            </div>
          </motion.div>

          {/* Categories */}
          <motion.div
            className="mt-6 flex gap-2 overflow-x-auto pb-2"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8, delay: 0.15 }}
          >
            {categories.map((cat) => (
              <button
                key={cat}
                onClick={() => setActiveCategory(cat)}
                className={`px-4 py-2 text-[11px] tracking-widest uppercase whitespace-nowrap rounded-full border transition-all ${
                  activeCategory === cat
                    ? 'bg-white text-black border-white'
                    : 'border-white/10 text-muted-foreground hover:border-white/30 hover:text-foreground'
                }`}
              >
                {cat}
              </button>
            ))}
          </motion.div>

          {/* Grid */}
          <motion.div
            className="mt-10 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8, delay: 0.2 }}
          >
            {filtered.map((item, i) => (
              <motion.div
                key={item.id}
                className="rounded-lg border border-border/30 p-5 hover:border-white/20 transition-all cursor-pointer group"
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.4, delay: 0.05 * i }}
              >
                <div className="flex items-start justify-between">
                  <div>
                    <h3 className="font-light text-foreground">{item.name}</h3>
                    <p className="text-xs text-muted-foreground mt-1">{item.creator}</p>
                  </div>
                  <span className="text-[10px] tracking-widest uppercase text-muted-foreground">
                    {item.category}
                  </span>
                </div>

                <div className="mt-6 flex items-end justify-between">
                  <div>
                    <div className="text-xl font-light text-foreground">{item.price}</div>
                    <div className={`text-xs mt-1 ${item.change.startsWith('+') ? 'text-white/60' : 'text-white/30'}`}>
                      {item.change}
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="text-[10px] tracking-widest uppercase text-muted-foreground">Vol</div>
                    <div className="text-sm text-foreground/80">{item.volume}</div>
                  </div>
                </div>

                <button className="mt-5 w-full rounded-lg border border-white/10 py-2.5 text-xs tracking-widest uppercase text-muted-foreground group-hover:border-white/30 group-hover:text-foreground transition-all">
                  View
                </button>
              </motion.div>
            ))}
          </motion.div>

          {filtered.length === 0 && (
            <div className="mt-20 text-center text-sm text-muted-foreground">
              No reflections found
            </div>
          )}
        </div>
      </div>
    </main>
  )
}
