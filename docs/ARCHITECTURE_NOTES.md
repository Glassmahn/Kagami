# Architecture Notes

These notes summarize the PDFs and guide implementation while preserving the existing frontend.

## Core Entities

- `Seed`: raw idea text, URL, or social post that starts a Kagami.
- `Kagami`: root container that owns all child shards and tracks creator metadata.
- `Shard`: child primitive such as token, NFT, prediction market, or yield vault.
- `Agent`: autonomous process with a smart wallet that can act inside Kagamis.
- `$KAGAMI`: protocol governance and revenue-share token.

## Onchain Layer

- Chain: Base, with Base Sepolia first.
- Contracts: Solidity `^0.8.25`.
- Framework: Foundry.
- Core contracts: `KagamiFactory`, `KagamiRoot`, `ReflectionEngine`, `RevenueRouter`, `AgentWalletFactory`, `GovernanceModule`, `KAGAMIToken`, `StakingVault`.
- Shards: `ShardToken`, `DynamicNFT`, `PredictionMarket`, `YieldVault`.

## App Layer

- Existing stack: Next.js, TypeScript, Tailwind, shadcn/ui, Framer Motion, Three.js.
- Wallet direction: Coinbase Smart Wallet and Base-compatible wagmi/viem config.
- Current pages remain the frontend baseline: home, discover, launch, dashboard, studio.

## Data Layer

- Onchain state is canonical.
- Ponder indexes contract events into PostgreSQL.
- Redis supports sessions, cache, queues, and rate limits.
- Meilisearch supports seed and Kagami search.
- Arweave/IPFS store NFT metadata and seed archives.

## Agent Layer

- ElizaOS is the initial runtime choice.
- Agents are stateless workers.
- Agent actions are evented and displayed in the existing UI.
- LLM prompts are versioned and user seed text is sanitized before model calls.

## Defaults

- Linear bonding curve for v1 ShardTokens.
- Fixed `$KAGAMI` supply.
- Creator revenue split defaults to `75%`.
- Protocol treasury defaults to `10%`.
- Staker share defaults to `15%`.
- Manual prediction settlement on testnet; UMA on mainnet.
- Base-only through the first public beta.
