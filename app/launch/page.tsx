'use client'

import { useState } from 'react'
import { motion } from 'framer-motion'
import { Navbar } from '@/components/kagami/navbar'
import { useKagami } from '@/hooks/use-kagami'

export default function LaunchPage() {
  const [idea, setIdea] = useState('')
  const [step, setStep] = useState(1)
  const [selectedTypes, setSelectedTypes] = useState<string[]>(['Token', 'Agent'])
  
  const { launchReflection, isLaunching, isSuccess } = useKagami()
  
  const toggleType = (type: string) => {
    setSelectedTypes(prev => 
      prev.includes(type) ? prev.filter(t => t !== type) : [...prev, type]
    )
  }
  
  const handleLaunch = () => {
    if (!idea) return
    launchReflection(idea, selectedTypes)
  }
  
  if (isSuccess) {
    setStep(3)
  }

  return (
    <main className="min-h-screen bg-background">
      <Navbar />
      
      <div className="pt-28 pb-20 px-6">
        <div className="mx-auto max-w-2xl">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8 }}
            className="text-center"
          >
            <h1 className="text-2xl font-light tracking-tight text-foreground">Launch</h1>
            <p className="mt-2 text-sm text-muted-foreground font-light">Create a new reflection</p>
          </motion.div>

          {/* Progress */}
          <motion.div
            className="mt-12 flex items-center justify-center gap-4"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8, delay: 0.1 }}
          >
            {[1, 2, 3].map((s) => (
              <div key={s} className="flex items-center gap-4">
                <div className={`h-8 w-8 rounded-full flex items-center justify-center text-xs font-light border transition-all ${
                  step >= s ? 'border-white text-foreground' : 'border-white/10 text-muted-foreground'
                }`}>
                  {s}
                </div>
                {s < 3 && <div className={`w-12 h-px transition-colors ${step > s ? 'bg-white/60' : 'bg-white/10'}`} />}
              </div>
            ))}
          </motion.div>

          {/* Step Content */}
          <motion.div
            className="mt-12"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
          >
            {step === 1 && (
              <div className="rounded-lg border border-border/30 p-8">
                <h2 className="text-sm tracking-widest uppercase text-muted-foreground">Your Idea</h2>
                
                <textarea
                  value={idea}
                  onChange={(e) => setIdea(e.target.value)}
                  placeholder="Describe your concept..."
                  className="mt-6 w-full h-36 rounded-lg border border-border/30 bg-transparent px-4 py-3 text-foreground placeholder:text-muted-foreground/40 focus:outline-none focus:border-white/30 resize-none font-light"
                />

                <div className="mt-4 flex flex-wrap gap-2">
                  {['Meme Coin', 'AI Agent', 'NFT Collection', 'DAO'].map((tag) => (
                    <button
                      key={tag}
                      onClick={() => setIdea(tag)}
                      className="px-3 py-1.5 text-[10px] tracking-widest uppercase rounded-full border border-white/10 text-muted-foreground hover:border-white/30 hover:text-foreground transition-all"
                    >
                      {tag}
                    </button>
                  ))}
                </div>

                <button
                  onClick={() => setStep(2)}
                  disabled={!idea}
                  className="mt-8 w-full rounded-lg bg-white py-3.5 text-xs tracking-widest uppercase text-black font-medium transition-all hover:bg-white/90 disabled:opacity-30 disabled:cursor-not-allowed"
                >
                  Continue
                </button>
              </div>
            )}

            {step === 2 && (
              <div className="rounded-lg border border-border/30 p-8">
                <h2 className="text-sm tracking-widest uppercase text-muted-foreground">Configuration</h2>
                
                <div className="mt-6 space-y-3">
                  {[
                    { type: 'Token', desc: 'Fungible token for trading' },
                    { type: 'Agent', desc: 'AI agent to manage growth' },
                    { type: 'NFT', desc: 'Unique collectibles' },
                  ].map((item) => (
                    <div
                      key={item.type}
                      onClick={() => toggleType(item.type)}
                      className={`rounded-lg border p-4 cursor-pointer transition-all ${
                        selectedTypes.includes(item.type) ? 'border-white/40 bg-white/[0.02]' : 'border-white/10 hover:border-white/20'
                      }`}
                    >
                      <div className="flex items-center justify-between">
                        <div>
                          <div className="text-sm text-foreground font-light">{item.type}</div>
                          <div className="text-xs text-muted-foreground mt-0.5">{item.desc}</div>
                        </div>
                        <div className={`h-4 w-4 rounded-full border transition-all ${
                          selectedTypes.includes(item.type) ? 'border-white bg-white' : 'border-white/20'
                        }`}>
                          {selectedTypes.includes(item.type) && (
                            <svg className="h-4 w-4 text-black" fill="currentColor" viewBox="0 0 12 12">
                              <path d="M10.28 2.28L3.989 8.575 1.695 6.28A1 1 0 00.28 7.695l3 3a1 1 0 001.414 0l7-7A1 1 0 0010.28 2.28z" />
                            </svg>
                          )}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>

                <div className="mt-8 flex gap-3">
                  <button
                    onClick={() => setStep(1)}
                    className="flex-1 rounded-lg border border-white/20 py-3.5 text-xs tracking-widest uppercase text-foreground hover:bg-white/5 transition-all"
                  >
                    Back
                  </button>
                  <button
                    onClick={() => setStep(3)}
                    className="flex-1 rounded-lg bg-white py-3.5 text-xs tracking-widest uppercase text-black font-medium hover:bg-white/90 transition-all"
                  >
                    Continue
                  </button>
                </div>
              </div>
            )}

            {step === 3 && (
              <div className="rounded-lg border border-border/30 p-8 text-center">
                <div className="mx-auto h-14 w-14 rounded-full border border-white/20 flex items-center justify-center">
                  <svg className="h-6 w-6 text-foreground" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M5 13l4 4L19 7" />
                  </svg>
                </div>
                
                <h2 className="mt-6 text-sm tracking-widest uppercase text-muted-foreground">Ready</h2>
                <p className="mt-3 text-xs text-muted-foreground/70 max-w-xs mx-auto leading-relaxed">
                  Your reflection will deploy to Base. Gasless and instant.
                </p>

                <div className="mt-8 rounded-lg bg-white/[0.02] border border-white/10 p-4 text-left">
                  <div className="text-[10px] tracking-widest uppercase text-muted-foreground">Idea</div>
                  <div className="mt-1 text-sm text-foreground font-light">{idea}</div>
                  <div className="mt-3 text-[10px] tracking-widest uppercase text-muted-foreground">Types</div>
                  <div className="mt-1 text-sm text-foreground font-light">{selectedTypes.join(', ')}</div>
                </div>

                <div className="mt-8 flex gap-3">
                  <button
                    onClick={() => setStep(2)}
                    className="flex-1 rounded-lg border border-white/20 py-3.5 text-xs tracking-widest uppercase text-foreground hover:bg-white/5 transition-all"
                  >
                    Back
                  </button>
                  <button className="flex-1 rounded-lg bg-white py-3.5 text-xs tracking-widest uppercase text-black font-medium hover:bg-white/90 transition-all">
                    Launch
                  </button>
                </div>
              </div>
            )}
          </motion.div>
        </div>
      </div>
    </main>
  )
}
