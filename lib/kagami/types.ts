export type KagamiChainKey = 'baseSepolia' | 'baseMainnet'

export type KagamiShardType = 'token' | 'dynamic-nft' | 'prediction-market' | 'yield-vault' | 'agent'

export type KagamiRevenueRecipient = 'creator' | 'stakers' | 'treasury'

export interface KagamiChainConfig {
  key: KagamiChainKey
  chainId: number
  name: string
  network: string
  rpcEnvKey: string
  explorerUrl: string
  isTestnet: boolean
}

export interface KagamiShardDefinition {
  type: KagamiShardType
  label: string
  description: string
  phase: number
}

export interface KagamiRevenueSplit {
  recipient: KagamiRevenueRecipient
  label: string
  percent: number
}

