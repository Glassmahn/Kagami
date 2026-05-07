# KAGAMI

**One idea. Infinite reflections on Base.**

Transform any idea (meme, trend, brand campaign, random thought) into an infinite, self-running onchain ecosystem consisting of token shards, autonomous AI agents, dynamic NFTs, prediction markets, and auto-yield vaults. All revenue automatically flows back to the original creator/agent. Fully permissionless and agent-native.

## Tech Stack

- **Smart Contracts**: Foundry (Solidity 0.8.26+), OpenZeppelin, Chainlink, Pyth
- **Frontend**: Next.js 15 (App Router), TypeScript, Tailwind CSS, shadcn/ui, Coinbase OnchainKit, viem/wagmi
- **Chain**: Base (Sepolia + Mainnet)
- **Styling**: Dark cyber-Japanese mirror aesthetic (deep blacks, glassmorphism, subtle infinite fractal reflections, neon accents)
- **Mobile**: React Native (coming soon)
- **Indexing**: The Graph / custom indexer
- **Real-time**: WebSockets + subgraph

## Quick Start

### Prerequisites
- Node.js v20+
- pnpm
- Foundry
- Git

### Installation
```bash
pnpm install
```

### Development
```bash
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) to see the KAGAMI mirror in action.

### Smart Contracts
```bash
cd contracts
forge install OpenZeppelin/openzeppelin-contracts
forge test
# Deploy to Base Sepolia
forge script script/Deploy.s.sol --rpc-url $BASE_SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --verify --etherscan-api-key $BASE_SCAN_API_KEY
```

## Base Deployment

All contracts deploy to Base. Update `foundry.toml` with your RPC URLs. Frontend uses OnchainKit for Base Smart Wallet (gasless via paymaster) integration by default.

## Project Structure

```
kagami/
├── app/                    # Next.js App Router pages
│   ├── launch/            # Idea drop + live reflection preview
│   ├── dashboard/         # Personal reflection portfolio
│   ├── discover/          # Explore reflections
│   ├── studio/            # Creator dashboard
│   └── [id]/              # Individual kagami view
├── components/            # Reusable UI components
│   ├── kagami/           # KAGAMI-specific components
│   └── ui/               # shadcn/ui components
├── contracts/             # Foundry smart contracts
├── hooks/                 # Custom React hooks
├── lib/                   # Utility functions
├── styles/                # Global styles + mirror.css
└── public/                # Static assets
```

## Roadmap

- **Phase 1 (Weeks 1-3)**: Foundation - Core engine + main web app
- **Phase 2 (Weeks 4-6)**: Core Protocol & Revenue - Revenue sharing, dynamic yield, liquidation
- **Phase 3 (Weeks 7-9)**: AI Agent Layer - Autonomous agents
- **Phase 4 (Weeks 10-12)**: Integrations - Farcaster, X, mobile, embed
- **Phase 5 (Weeks 13-20)**: Community & Scale - Grants, memes, ambassadors

## License

MIT
