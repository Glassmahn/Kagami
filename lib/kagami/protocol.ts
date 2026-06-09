import type { KagamiChainConfig, KagamiRevenueSplit, KagamiShardDefinition } from './types'

export const KAGAMI_PROTOCOL = {
  name: 'KAGAMI',
  tagline: 'One idea. Infinite reflections on Base.',
  seedInputLabel: 'Seed',
  defaultCreatorSharePercent: 75,
  minCreatorSharePercent: 50,
  maxCreatorSharePercent: 90,
  creationFeeEth: '0.001',
} as const

export const KAGAMI_CHAINS: Record<string, KagamiChainConfig> = {
  baseSepolia: {
    key: 'baseSepolia',
    chainId: 84532,
    name: 'Base Sepolia',
    network: 'base-sepolia',
    rpcEnvKey: 'NEXT_PUBLIC_BASE_SEPOLIA_RPC_URL',
    explorerUrl: 'https://sepolia.basescan.org',
    isTestnet: true,
  },
  baseMainnet: {
    key: 'baseMainnet',
    chainId: 8453,
    name: 'Base',
    network: 'base',
    rpcEnvKey: 'NEXT_PUBLIC_BASE_RPC_URL',
    explorerUrl: 'https://basescan.org',
    isTestnet: false,
  },
}

export const INITIAL_SHARDS: KagamiShardDefinition[] = [
  {
    type: 'token',
    label: 'Shard Token',
    description: 'Tradable ERC-20 shard with a linear bonding curve.',
    phase: 1,
  },
  {
    type: 'dynamic-nft',
    label: 'Dynamic NFT',
    description: 'ERC-721 shard whose metadata evolves with attention.',
    phase: 1,
  },
  {
    type: 'prediction-market',
    label: 'Prediction Market',
    description: 'Outcome market around the Kagami seed succeeding.',
    phase: 2,
  },
  {
    type: 'yield-vault',
    label: 'Yield Vault',
    description: 'ERC-4626 vault that routes harvested yield through revenue sharing.',
    phase: 2,
  },
  {
    type: 'agent',
    label: 'Agent',
    description: 'Autonomous worker that evolves, promotes, or manages a Kagami.',
    phase: 3,
  },
]

export const DEFAULT_REVENUE_SPLIT: KagamiRevenueSplit[] = [
  { recipient: 'creator', label: 'Creator', percent: 75 },
  { recipient: 'stakers', label: '$KAGAMI Stakers', percent: 15 },
  { recipient: 'treasury', label: 'Treasury', percent: 10 },
]

