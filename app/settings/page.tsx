'use client'

import { motion } from 'framer-motion'
import { Navbar } from '@/components/kagami/navbar'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Switch } from '@/components/ui/switch'

export default function SettingsPage() {
  return (
    <main className="min-h-screen bg-background">
      <Navbar />
      
      <div className="pt-28 pb-20 px-6">
        <div className="mx-auto max-w-2xl">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8 }}
          >
            <h1 className="text-2xl font-light tracking-tight text-foreground">Settings</h1>
            <p className="mt-2 text-sm text-muted-foreground font-light">Wallet & preferences</p>
          </motion.div>
          
          {/* Wallet Section */}
          <motion.div
            className="mt-12 rounded-lg border border-border/30 p-6"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.1 }}
          >
            <h2 className="text-sm tracking-widest uppercase text-muted-foreground">Wallet</h2>
            <div className="mt-6 space-y-4">
              <div>
                <Label className="text-xs uppercase tracking-wider text-muted-foreground">Connected Wallet</Label>
                <div className="mt-2 flex items-center justify-between">
                  <span className="text-sm font-light text-foreground">0x1a2...3b4c</span>
                  <Button variant="outline" size="sm" className="text-xs">Disconnect</Button>
                </div>
              </div>
              
              <div>
                <Label className="text-xs uppercase tracking-wider text-muted-foreground">Gasless Mode</Label>
                <div className="mt-2 flex items-center justify-between">
                  <span className="text-sm text-muted-foreground">Use Coinbase Smart Wallet Paymaster</span>
                  <Switch checked={true} onCheckedChange={() => {}} />
                </div>
              </div>
            </div>
          </motion.div>
          
          {/* Preferences */}
          <motion.div
            className="mt-6 rounded-lg border border-border/30 p-6"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
          >
            <h2 className="text-sm tracking-widest uppercase text-muted-foreground">Preferences</h2>
            <div className="mt-6 space-y-4">
              <div>
                <Label className="text-xs uppercase tracking-wider text-muted-foreground">Default Chain</Label>
                <div className="mt-2 text-sm font-light text-foreground">Base Mainnet</div>
              </div>
              
              <div>
                <Label className="text-xs uppercase tracking-wider text-muted-foreground">Notifications</Label>
                <div className="mt-2 space-y-3">
                  {['Revenue Alerts', 'Liquidation Warnings', 'Milestone Updates'].map((item) => (
                    <div key={item} className="flex items-center justify-between">
                      <span className="text-sm text-muted-foreground">{item}</span>
                      <Switch checked={true} onCheckedChange={() => {}} />
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </motion.div>
          
          {/* Danger Zone */}
          <motion.div
            className="mt-6 rounded-lg border border-red-500/20 p-6"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.3 }}
          >
            <h2 className="text-sm tracking-widest uppercase text-red-400/80">Danger Zone</h2>
            <div className="mt-4 flex gap-3">
              <Button variant="outline" className="border-red-500/30 text-red-400 hover:bg-red-500/10">
                Deactivate All Agents
              </Button>
              <Button variant="outline" className="border-red-500/30 text-red-400 hover:bg-red-500/10">
                Delete Account
              </Button>
            </div>
          </motion.div>
        </div>
      </div>
    </main>
  )
}
