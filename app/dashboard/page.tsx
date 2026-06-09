'use client'

import { motion } from 'framer-motion'
import { Navbar } from '@/components/kagami/navbar'

const reflections = [
  { id: 1, name: 'CryptoKitties Revival', type: 'Token', value: '$12,450', change: '+24.5%', agents: 3 },
  { id: 2, name: 'AI Poetry Bot', type: 'Agent', value: '$8,230', change: '+12.3%', agents: 1 },
  { id: 3, name: 'Indie Dev Fund', type: 'NFT', value: '$45,000', change: '+8.7%', agents: 5 },
  { id: 4, name: 'Meme Lords DAO', type: 'Token', value: '$3,120', change: '-2.1%', agents: 2 },
]

export default function DashboardPage() {
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
            <h1 className="text-2xl font-light tracking-tight text-foreground">Dashboard</h1>
            <p className="mt-2 text-sm text-muted-foreground font-light">Manage your reflections</p>
          </motion.div>

          {/* Stats Grid */}
          <motion.div
            className="mt-12 grid grid-cols-2 lg:grid-cols-4 gap-px bg-border/30 rounded-lg overflow-hidden"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.1 }}
          >
            {[
              { label: 'Total Value', value: '$68,800' },
              { label: 'Active Reflections', value: '4' },
              { label: 'Total Revenue', value: '$4,230' },
              { label: 'Active Agents', value: '11' },
            ].map((stat) => (
              <div key={stat.label} className="bg-background p-6">
                <div className="text-xs tracking-widest uppercase text-muted-foreground">{stat.label}</div>
                <div className="mt-2 text-2xl font-light text-foreground">{stat.value}</div>
              </div>
            ))}
          </motion.div>

          {/* Reflections Table */}
          <motion.div
            className="mt-12"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
          >
            <h2 className="text-sm tracking-widest uppercase text-muted-foreground mb-6">Your Reflections</h2>
            <div className="border border-border/50 rounded-lg overflow-hidden">
              <table className="w-full">
                <thead>
                  <tr className="border-b border-border/50 text-left text-xs tracking-widest uppercase text-muted-foreground">
                    <th className="px-6 py-4 font-normal">Name</th>
                    <th className="px-6 py-4 font-normal hidden sm:table-cell">Type</th>
                    <th className="px-6 py-4 font-normal">Value</th>
                    <th className="px-6 py-4 font-normal hidden md:table-cell">Change</th>
                    <th className="px-6 py-4 font-normal"></th>
                  </tr>
                </thead>
                <tbody>
                  {reflections.map((item) => (
                    <tr key={item.id} className="border-b border-border/30 last:border-0 hover:bg-white/[0.02] transition-colors">
                      <td className="px-6 py-5">
                        <span className="font-light text-foreground">{item.name}</span>
                      </td>
                      <td className="px-6 py-5 hidden sm:table-cell">
                        <span className="text-xs tracking-wider text-muted-foreground">{item.type}</span>
                      </td>
                      <td className="px-6 py-5 font-light text-foreground">{item.value}</td>
                      <td className="px-6 py-5 hidden md:table-cell">
                        <span className={item.change.startsWith('+') ? 'text-white/70' : 'text-white/40'}>
                          {item.change}
                        </span>
                      </td>
                      <td className="px-6 py-5">
                        <button className="text-xs tracking-wider text-muted-foreground hover:text-foreground transition-colors">
                          View
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </motion.div>

          {/* Quick Actions */}
          <motion.div
            className="mt-12 flex flex-wrap gap-3"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8, delay: 0.3 }}
          >
            <button className="rounded-lg bg-white px-6 py-3 text-xs tracking-widest uppercase text-black font-medium transition-all hover:bg-white/90">
              New Reflection
            </button>
            <button className="rounded-lg border border-white/20 px-6 py-3 text-xs tracking-widest uppercase text-foreground transition-all hover:bg-white/5">
              Withdraw
            </button>
          </motion.div>
        </div>
      </div>
    </main>
  )
}
