import { Navbar } from '@/components/kagami/navbar'
import { HeroSection } from '@/components/kagami/hero-section'
import { InfiniteMirror } from '@/components/kagami/infinite-mirror'

export default function HomePage() {
  return (
    <main className="min-h-screen bg-background fractal-bg">
      <Navbar />
      <HeroSection />
      <InfiniteMirror />
    </main>
  )
}
