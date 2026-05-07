import { Navbar } from '@/components/kagami/navbar'
import { HeroSection } from '@/components/kagami/hero-section'

export default function HomePage() {
  return (
    <main className="min-h-screen bg-background">
      <Navbar />
      <HeroSection />
    </main>
  )
}
