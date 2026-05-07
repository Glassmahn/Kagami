'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'
import { InfiniteMirror } from './infinite-mirror'

export function HeroSection() {
  const [idea, setIdea] = useState('')

  return (
    <section className="relative h-screen flex items-center justify-center overflow-hidden">
      <InfiniteMirror />
      
      {/* Vignette overlay */}
      <div className="absolute inset-0 z-[1] pointer-events-none bg-[radial-gradient(ellipse_at_center,transparent_0%,rgba(0,0,0,0.4)_70%,rgba(0,0,0,0.8)_100%)]" />
      
      <div className="relative z-10 mx-auto max-w-xl px-6 text-center">
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 1.5, ease: 'easeOut' }}
        >
          <h1 className="text-5xl sm:text-6xl md:text-7xl font-extralight tracking-tight text-foreground leading-[1.05]">
            <span className="block">鏡</span>
            <span className="block mt-2 text-3xl sm:text-4xl md:text-5xl text-muted-foreground font-light">KAGAMI</span>
          </h1>
          
          <p className="mt-8 text-base text-muted-foreground font-light tracking-wide">
            Reflect ideas into tokens, agents, NFTs
          </p>
        </motion.div>

        <motion.div
          className="mt-12"
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1, delay: 0.5, ease: 'easeOut' }}
        >
          <div className="relative group">
            <div className="absolute -inset-0.5 bg-gradient-to-r from-white/10 via-white/5 to-white/10 rounded-lg blur-sm opacity-0 group-focus-within:opacity-100 transition-opacity duration-500" />
            <input
              type="text"
              value={idea}
              onChange={(e) => setIdea(e.target.value)}
              placeholder="Enter your idea"
              className="relative w-full rounded-lg border border-border/50 bg-black/60 backdrop-blur-sm px-5 py-4 text-foreground text-center placeholder:text-muted-foreground/60 focus:outline-none focus:border-white/30 transition-all font-light tracking-wide"
            />
          </div>
          
          <button className="mt-4 rounded-lg bg-white px-8 py-3 text-sm font-medium text-black transition-all hover:bg-white/90 active:scale-[0.98]">
            Reflect
          </button>
        </motion.div>

        <motion.div
          className="mt-20 flex items-center justify-center gap-12 text-xs tracking-widest uppercase"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 1, delay: 1 }}
        >
          <div className="text-center">
            <div className="text-xl font-light text-foreground">12.4K</div>
            <div className="mt-1 text-muted-foreground/60">Reflections</div>
          </div>
          <div className="h-6 w-px bg-border/30" />
          <div className="text-center">
            <div className="text-xl font-light text-foreground">$4.2M</div>
            <div className="mt-1 text-muted-foreground/60">Volume</div>
          </div>
          <div className="h-6 w-px bg-border/30" />
          <div className="text-center">
            <div className="text-xl font-light text-foreground">847</div>
            <div className="mt-1 text-muted-foreground/60">Agents</div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
