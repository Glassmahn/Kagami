import type { Metadata } from 'next'
import { Inter, JetBrains_Mono } from 'next/font/google'
import { Analytics } from '@vercel/analytics/next'
import './globals.css'
import '../styles/mirror.css'
import { OnchainKitProvider } from '@coinbase/onchainkit'

const inter = Inter({ 
  subsets: ["latin"],
  variable: '--font-inter'
})

const jetbrainsMono = JetBrains_Mono({ 
  subsets: ["latin"],
  variable: '--font-jetbrains'
})

export const metadata: Metadata = {
  title: 'KAGAMI — Mirror Your Ideas Into Reality',
  description: 'Transform any idea into tokens, agents, and NFTs on Base. One tap to reflect. Gasless. Instant.',
  keywords: ['Web3', 'Base', 'NFT', 'AI Agents', 'DeFi', 'Tokenization', 'Farcaster'],
  authors: [{ name: 'KAGAMI' }],
  openGraph: {
    title: 'KAGAMI — Mirror Your Ideas Into Reality',
    description: 'Transform any idea into tokens, agents, and NFTs on Base.',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'KAGAMI — Mirror Your Ideas Into Reality',
    description: 'Transform any idea into tokens, agents, and NFTs on Base.',
  },
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en" className="dark bg-background">
      <body className={`${inter.variable} ${jetbrainsMono.variable} font-sans antialiased fractal-bg`}>
        <OnchainKitProvider
          chainId={84532}
          config={{ appearance: { mode: "dark" } }}
        >
          {children}
          {process.env.NODE_ENV === 'production' && <Analytics />}
        </OnchainKitProvider>
      </body>
    </html>
  )
}
