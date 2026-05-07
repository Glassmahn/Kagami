'use client'

import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import { Navbar } from '@/components/kagami/navbar'
import { useReadContract } from 'wagmi'
import { kagamiCoreAbi } from '@/lib/abis'
import { KAGAMI_CORE_ADDRESS } from '@/lib/constants'

interface Reflection {
  id: number
  name: string
  type: string
  value: string
  change: string
  agents: number
}

export default function DashboardPage() {
  const [reflections, setReflections] = useState<Reflection[]>([])
  const [stats, setStats] = useState({
    totalValue: '$0',
    activeReflections: '0',
    totalRevenue: '$0',
    activeAgents: '0'
  })
  
  const { data: totalReflections } = useReadContract({
    address: KAGAMI_CORE_ADDRESS,
    abi: kagamiCoreAbi,
    functionName: 'totalReflections',
  })
  
  // Fetch reflections (simplified - in production, use subgraph or indexer)
  useEffect(() => {
    if (totalReflections) {
      // Mock data for now - replace with actual contract calls
      setReflections([
        { id: 1, name: 'My First Kagami', type: 'Token', value: '$1,250', change: '+15.2%', agents: 2 },
      { id: 2, name: 'AI Assistant', type: 'Agent', value: '$850', change: '+8.7%', agents: 1 },
      { id: 3, name: 'Meme Collection', type: 'NFT', value: '$2,100', change: '+22.1%', agents: 3 },
    ])
    setStats({
      totalValue: '$4,200',
      activeReflections: totalReflections.toString(),
      totalRevenue: '$320',
      activeAgents: '6'
    })
    }
  }, [totalReflections])
  
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
              { label: 'Total Value', value: stats.totalValue },
              { label: 'Active Reflections', value: stats.activeReflections },
              { label: 'Total Revenue', value: stats.totalRevenue },
              { label: 'Active Agents', value: stats.activeAgents },
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
