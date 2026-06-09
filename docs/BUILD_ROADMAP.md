# KAGAMI Build Roadmap

KAGAMI turns one seed idea into a Base-native onchain economy made of a root Kagami, tradable shards, dynamic NFTs, prediction markets, yield vaults, creator revenue, and autonomous agents.

The existing Next.js frontend is the product shell and visual baseline. Build around it rather than replacing it.

## Build Principles

- Preserve the current frontend structure and design language.
- Add protocol layers beside the app: `contracts/`, `indexer/`, `agents/`, and `packages/agent-sdk`.
- Replace mocked frontend data gradually with typed local data, then API/indexer data, then live Base data.
- Commit small, useful milestones to `main` and push steadily.
- Keep Base Sepolia as the first integration target before mainnet.

## Phase 0: Foundation

- Keep the current frontend at repo root.
- Add project docs, environment templates, and protocol constants.
- Define Base chain config and public protocol metadata.
- Add typed route and feature maps used by the existing UI.
- Add CI for install, lint, type-check, and build.

## Phase 1: Contract Core

- Scaffold Foundry under `contracts/`.
- Add `KagamiFactory`, `KagamiRoot`, `ReflectionEngine`, and `RevenueRouter`.
- Add first shard interfaces and stubs for token, NFT, market, and vault shards.
- Add tests for Kagami creation, shard registration, role checks, revenue routing, and claims.

## Phase 2: Frontend Wiring

- Keep the visual frontend intact.
- Centralize mock reflections, dashboard stats, nav items, and shard options into typed modules.
- Add wallet/provider scaffolding for Base and Base Sepolia.
- Add contract client configuration with placeholder addresses.
- Rename or alias product routes only after the current pages remain stable.

## Phase 3: Indexer and API

- Add Ponder indexer for Kagami and revenue events.
- Add API routes for explore, dashboard, Kagami detail, and agent activity.
- Add database schema notes and Supabase migrations.
- Swap frontend mocks for API reads with loading and empty states.

## Phase 4: Economics

- Implement `$KAGAMI`, staking, creator claims, protocol treasury, and revenue split enforcement.
- Wire ShardToken fees, DynamicNFT mint fees, PredictionMarket fees, and YieldVault harvest fees into `RevenueRouter`.
- Add Morpho/Aerodrome strategy integration after testnet behavior is stable.

## Phase 5: Agents and SDK

- Add `AgentWalletFactory`.
- Build Curator, Evolver, Promoter, Keeper, and Battler workers.
- Publish `@kagami/agent-sdk` with typed helpers for creating and evolving Kagamis.
- Show agent activity in the existing dashboard/detail surfaces.

## Phase 6: Distribution

- Add Farcaster frame creation.
- Add X mention-to-create bot.
- Add Arweave/IPFS metadata flow.
- Add embeddable Kagami widget.
- Add notification triggers for creation, milestones, claims, and market settlement.

## Phase 7: Launch Readiness

- Add monitoring, alerting, and incident-response docs.
- Run Base Sepolia integration tests.
- Prepare mainnet deployment runbook.
- Verify contracts, deploy web, and publish docs.
