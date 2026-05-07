'use client'

import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import { Navbar } from '@/components/kagami/navbar'
import { useReadContract } from 'wagmi'
import { kagamiCoreAbi } from '@/lib/abis'
import { KAGAMI_CORE_ADDRESS } from '@/lib/constants'

interface Project {
  id: number
  name: string
  status: 'Active' | 'Paused'
  revenue: string
  agents: number
}

export default function StudioPage() {
  const [activeTab, setActiveTab] = useState<'projects' | 'analytics' | 'settings'>('projects')
  const [projects, setProjects] = useState<Project[]>([])

  const { data: totalReflections } = useReadContract({
    address: KAGAMI_CORE_ADDRESS,
    abi: kagamiCoreAbi,
    functionName: 'totalReflections',
  })

  useEffect(() => {
    if (totalReflections) {
      // Mock data - replace with actual contract calls
      setProjects([
        { id: 1, name: 'My Kagami #1', status: 'Active', revenue: '$1,250', agents: 2 },
        { id: 2, name: 'AI Bot', status: 'Active', revenue: '$850', agents: 1 },
      ])
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
            <h1 className="text-2xl font-light tracking-tight text-foreground">Studio</h1>
            <p className="mt-2 text-sm text-muted-foreground font-light">Advanced creator tools</p>
          </motion.div>
          
          {/* Tabs */}
          <motion.div
            className="mt-10 flex gap-8 border-b border-border/30"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8, delay: 0.1 }}
          >
            {(['projects', 'analytics', 'settings'] as const).map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`pb-4 text-xs tracking-wider uppercase transition-all ${
                  activeTab === tab
                    ? 'text-foreground border-b border-white'
                    : 'text-muted-foreground hover:text-foreground'
                }`}
              >
                {tab}
              </button>
            ))}
          </motion.div>
          
          {activeTab === 'projects' && (
            <motion.div
              className="mt-10"
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5 }}
            >
              <div className="space-y-3">
                {projects.map((project) => (
                  <div
                    key={project.id}
                    className="rounded-lg border border-border/30 p-6 flex flex-col sm:flex-row sm:items-center justify-between gap-4 hover:border-white/20 transition-colors"
                  >
                    <div>
                      <div className="flex items-center gap-3">
                        <h3 className="font-light text-foreground">{project.name}</h3>
                        <span className={`text-[10px] tracking-wider uppercase ${
                          project.status === 'Active' ? 'text-white/60' : 'text-white/30'
                        }`}>
                          {project.status}
                        </span>
                      </div>
                      <div className="mt-2 flex gap-6 text-xs text-muted-foreground">
                        <span>Revenue: {project.revenue}</span>
                        <span>Agents: {project.agents}</span>
                      </div>
                    </div>
                    <div className="flex gap-2">
                      <button className="rounded-lg border border-white/20 px-4 py-2 text-xs tracking-wider text-foreground hover:bg-white/5 transition-colors">
                        Edit
                      </button>
                      <button className="rounded-lg bg-white px-4 py-2 text-xs tracking-wider text-black hover:bg-white/90 transition-colors">
                        Manage
                      </button>
                    </div>
                  </div>
                ))}
              </div>
              
              <button className="mt-6 w-full rounded-lg border border-dashed border-white/10 py-4 text-xs tracking-wider uppercase text-muted-foreground hover:border-white/30 hover:text-foreground transition-colors">
                + New Project
              </button>
            </motion.div>
          )}
          
          {activeTab === 'analytics' && (
            <motion.div
              className="mt-10 grid grid-cols-1 md:grid-cols-2 gap-6"
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5 }}
            >
              <div className="rounded-lg border border-border/30 p-6">
                <h3 className="text-xs tracking-wider uppercase text-muted-foreground">Total Revenue</h3>
                <div className="mt-3 text-3xl font-light text-foreground">$2,100</div>
                <div className="mt-6 h-24 flex items-end gap-1">
                  {[40, 65, 45, 80, 55, 90, 70, 85, 60, 95, 75, 88].map((h, i) => (
                    <div
                      key={i}
                      className="flex-1 bg-white/10 rounded-sm"
                      style={{ height: `${h}%` }}
                    />
                  ))}
                </div>
              </div>
              
              <div className="rounded-lg border border-border/30 p-6">
                <h3 className="text-xs tracking-wider uppercase text-muted-foreground">Agent Performance</h3>
                <div className="mt-3 text-3xl font-light text-foreground">3 Active</div>
                <div className="mt-6 space-y-4">
                  {[
                    { name: 'Trading Bot', val: 85 },
                    { name: 'Content Creator', val: 72 },
                    { name: 'Community Mgr', val: 94 },
                  ].map((agent) => (
                    <div key={agent.name}>
                      <div className="flex justify-between text-xs mb-2">
                        <span className="text-foreground/80">{agent.name}</span>
                        <span className="text-muted-foreground">{agent.val}%</span>
                      </div>
                      <div className="h-px bg-white/10">
                        <div className="h-full bg-white/60" style={{ width: `${agent.val}%` }} />
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </motion.div>
          )}
          
          {activeTab === 'settings' && (
            <motion.div
              className="mt-10 max-w-lg space-y-6"
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5 }}
            >
              <div className="rounded-lg border border-border/30 p-6">
                <h3 className="text-sm font-light text-foreground">Revenue Splits</h3>
                <div className="mt-4 space-y-3">
                  {[
                    { label: 'Creator Share', val: '70%' },
                    { label: 'Agent Pool', val: '20%' },
                    { label: 'Platform Fee', val: '10%' },
                  ].map((item) => (
                    <div key={item.label} className="flex justify-between text-sm">
                      <span className="text-muted-foreground">{item.label}</span>
                      <span className="text-foreground">{item.val}</span>
                    </div>
                  ))}
                </div>
              </div>
              
              <div className="rounded-lg border border-border/30 p-6">
                <h3 className="text-sm font-light text-foreground">Agent Permissions</h3>
                <div className="mt-4 space-y-4">
                  {[
                    { label: 'Auto-mint NFTs', on: true },
                    { label: 'Execute trades', on: true },
                    { label: 'Post to social', on: false },
                  ].map((perm) => (
                    <div key={perm.label} className="flex items-center justify-between">
                      <span className="text-sm text-muted-foreground">{perm.label}</span>
                      <div className={`h-5 w-9 rounded-full p-0.5 transition-colors ${perm.on ? 'bg-white' : 'bg-white/10'}`}>
                        <div className={`h-4 w-4 rounded-full transition-all ${perm.on ? 'bg-black translate-x-4' : 'bg-white/40'}`} />
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </motion.div>
          )}
        </div>
      </div>
    </main>
  )
}
