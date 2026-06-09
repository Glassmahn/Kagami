# Environment Setup

Copy `.env.example` to `.env.local` for local frontend development.

## Required First

- `NEXT_PUBLIC_BASE_SEPOLIA_RPC_URL`: Base Sepolia RPC URL.
- `ALCHEMY_API_KEY`: event subscriptions and RPC fallback.
- `BASESCAN_API_KEY`: contract verification.

## Required When Features Land

- `DATABASE_URL`: PostgreSQL for indexed Kagami data.
- `REDIS_URL`: sessions, rate limits, queue, and cache.
- `ANTHROPIC_API_KEY`: agent seed enrichment and generated content.
- `PINATA_JWT` and `ARWEAVE_KEY_JSON`: NFT metadata and seed archive storage.
- `FARCASTER_NEYNAR_API_KEY`: Farcaster frame and attention ingestion.
- `X_CLIENT_ID` and `X_CLIENT_SECRET`: X mention-to-create bot.

## Chain Defaults

- Local development starts on Base Sepolia.
- Mainnet keys stay unset until testnet integration is complete.
- Browser-exposed variables must use the `NEXT_PUBLIC_` prefix.

