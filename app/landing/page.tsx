'use client'

import { motion } from 'framer-motion'
import { Button } from '@/components/ui/button'
import { Navbar } from '@/components/kagami/navbar'

export default function LandingPage() {
  return (
    <main className="min-h-screen bg-background fractal-bg">
      <Navbar />
      
      <div className="pt-32 pb-20 px-6">
        <div className="mx-auto max-w-4xl text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1 }}
          >
            <h1 className="text-5xl md:text-7xl font-light tracking-tight text-foreground">
              One idea.<br />
              <span className="neon-text">Infinite reflections</span>
              <br />
              <span className="text-foreground">on Base.</span>
            </h1>
            
            <p className="mt-8 text-lg text-muted-foreground font-light max-w-2xl mx-auto">
              Transform any idea into tokens, agents, and NFTs instantly. 
              Fully permissionless. Agent-native. Gasless by default.
            </p>
          </motion.div>
          
          <motion.div
            className="mt-12 flex flex-col sm:flex-row gap-4 justify-center"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 1, delay: 0.3 }}
          >
            <Button className="bg-white text-black px-8 py-4 text-sm tracking-widest uppercase hover:bg-white/90">
              Launch Your Idea
            </Button>
            <Button variant="outline" className="border-white/20 px-8 py-4 text-sm tracking-widest uppercase hover:bg-white/5">
              View Docs
            </Button>
          </motion.div>
          
          {/* Social Proof */}
          <motion.div
            className="mt-20 text-center"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 1, delay: 0.6 }}
          >
            <p className="text-xs tracking-widest uppercase text-muted-foreground/50 mb-6">
              Trusted by creators on Base
            </p>
            <div className="flex justify-center gap-8 text-muted-foreground/30">
              {['1,200+', 'Reflections', 'Created'].map((stat, i) => (
                <div key={i} className="text-center">
                  <div className="text-2xl font-light text-foreground/80">{stat}</div>
                </div>
              ))}
            </div>
          </motion.div>
        </div>
      </div>
    </main>
  )
}
