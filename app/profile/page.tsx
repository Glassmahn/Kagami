'use client'

import { motion } from 'framer-motion'
import { Navbar } from '@/components/kagami/navbar'

export default function ProfilePage() {
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
            <h1 className="text-2xl font-light tracking-tight text-foreground">Profile</h1>
            <p className="mt-2 text-sm text-muted-foreground font-light">Creator dashboard</p>
          </motion.div>
          
          {/* Profile Header */}
          <motion.div
            className="mt-12 rounded-lg border border-border/30 p-8"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.1 }}
          >
            <div className="flex flex-col sm:flex-row items-start sm:items-center gap-6">
              <div className="h-20 w-20 rounded-full bg-white/10 flex items-center justify-center text-2xl">
                K
              </div>
              <div className="flex-1">
                <h2 className="text-xl font-light text-foreground">KAGAMI Creator</h2>
                <p className="mt-1 text-sm text-muted-foreground">0x1a2...3b4c</p>
                <div className="mt-4 flex gap-6 text-sm">
                  <div>
                    <span className="text-muted-foreground">Reflections: </span>
                    <span className="text-foreground font-light">3</span>
                  </div>
                  <div>
                    <span className="text-muted-foreground">Revenue: </span>
                    <span className="text-foreground font-light">$2,100</span>
                  </div>
                  <div>
                    <span className="text-muted-foreground">Agents: </span>
                    <span className="text-foreground font-light">5</span>
                  </div>
                </div>
              </div>
              <button className="rounded-lg border border-white/20 px-6 py-2.5 text-xs tracking-wider uppercase text-foreground hover:bg-white/5 transition-all">
                Edit Profile
              </button>
            </div>
          </motion.div>
          
          {/* Quick Stats */}
          <motion.div
            className="mt-10 grid grid-cols-2 md:grid-cols-4 gap-4"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
          >
            {[
              { label: 'Total Value', value: '$4,200' },
              { label: '24h Change', value: '+12.5%' },
              { label: 'Followers', value: '142' },
              { label: 'Following', value: '89' },
            ].map((stat) => (
              <div key={stat.label} className="rounded-lg border border-border/30 p-5">
                <div className="text-xs tracking-wider uppercase text-muted-foreground">{stat.label}</div>
                <div className="mt-2 text-lg font-light text-foreground">{stat.value}</div>
              </div>
            ))}
          </motion.div>
        </div>
      </div>
    </main>
  )
}
