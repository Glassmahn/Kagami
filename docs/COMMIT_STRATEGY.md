# Commit Strategy

The project target is at least 100 meaningful commits. Commits should be small enough to review and large enough to represent real progress.

## Commit Groups

- 10-15 commits: project setup, docs, CI, environment templates.
- 15-20 commits: frontend data centralization and wallet wiring.
- 25-30 commits: smart contract scaffolding, implementation, and tests.
- 15-20 commits: indexer, API, and persistence.
- 10-15 commits: revenue, token, staking, and economics.
- 15-20 commits: agents, SDK, and runtime.
- 10-20 commits: social integrations, deployment, monitoring, and polish.

## Rules

- Push each completed commit to `main`.
- Keep the existing frontend intact unless a change is needed to wire real data or product behavior.
- Prefer one feature, one test group, or one config layer per commit.
- Avoid filler commits that do not improve the project.
- Mention the subsystem in each commit message.
