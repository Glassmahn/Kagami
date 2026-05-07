'use client'

import { motion } from 'framer-motion'
import { Navbar } from '@/components/kagami/navbar'

interface Notification {
  id: number
  type: 'revenue' | 'milestone' | 'liquidation' | 'system'
  title: string
  message: string
  time: string
  read: boolean
}

export default function NotificationsPage() {
  const [notifications, setNotifications] = useState<Notification[]>([
    { id: 1, type: 'revenue', title: 'Revenue Received', message: 'Your "Doge Reborn" reflection earned $450', time: '2 min ago', read: false },
    { id: 2, type: 'milestone', title: '100 Holders', message: '"AI Poetry Bot" reached 100 holders', time: '1 hour ago', read: false },
    { id: 3, type: 'system', title: 'Upgrade Complete', message: 'KagamiCore upgraded to v1.2.0', time: '3 hours ago', read: true },
    { id: 4, type: 'liquidation', title: 'Warning', message: '"Abstract Dreams" below threshold', time: '1 day ago', read: true },
  ])

  const markAsRead = (id: number) => {
    setNotifications(prev => 
      prev.map(n => n.id === id ? { ...n, read: true } : n)
    )
  }

  const unreadCount = notifications.filter(n => !n.read).length

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
            <h1 className="text-2xl font-light tracking-tight text-foreground">Notifications</h1>
            <p className="mt-2 text-sm text-muted-foreground font-light">
              {unreadCount} unread
            </p>
          </motion.div>
          
          <motion.div
            className="mt-10 space-y-3"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.1 }}
          >
            {notifications.map((notif) => (
              <div
                key={notif.id}
                onClick={() => markAsRead(notif.id)}
                className={`p-5 rounded-lg border transition-all cursor-pointer ${
                  notif.read 
                    ? 'border-white/10 hover:border-white/20' 
                    : 'border-white/30 bg-white/[0.02]'
                }`}
              >
                <div className="flex items-start justify-between gap-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <div className={`h-2 w-2 rounded-full ${
                        notif.type === 'revenue' ? 'bg-green-400' :
                        notif.type === 'milestone' ? 'bg-blue-400' :
                        notif.type === 'liquidation' ? 'bg-red-400' : 'bg-gray-400'
                      }`} />
                      <h3 className={`text-sm font-light ${
                        notif.read ? 'text-muted-foreground' : 'text-foreground'
                      }`}>
                        {notif.title}
                      </h3>
                    </div>
                    <p className="mt-1 text-xs text-muted-foreground font-light">
                      {notif.message}
                    </p>
                    <p className="mt-2 text-[10px] uppercase tracking-wider text-muted-foreground/50">
                      {notif.time}
                    </p>
                  </div>
                  
                  {!notif.read && (
                    <div className="h-2 w-2 rounded-full bg-white mt-1.5" />
                  )}
                </div>
              </div>
            ))}
          </motion.div>
          
          {notifications.length === 0 && (
            <div className="mt-20 text-center text-sm text-muted-foreground">
              No notifications yet
            </div>
          )}
        </div>
      </div>
    </main>
  )
}
