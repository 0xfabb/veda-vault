# VedaVault - A looping mechanism to maximize yield and guarantee safer returns

This is the main repo of the VedaVault assignment, I have been given this assignment by Anthias Labs.

## About the Project

## The native description of the Assignment

Option 1: stHYPE Looping Vault

A HYPE vault that runs stHYPE looping strategy. This automates yield maximization for HYPE holders by combining staking and leveraged lending.

### Vault Strategy (Use Boring Vault Repo)

1. Accept Deposits – receive wrapped HYPE (wHYPE) from depositors.
2. Stake – stake the wHYPE through [stHYPE](https://stakedhype.fi/).
3. Supply Collateral – deposit the resulting stHYPE into Felix Vanilla Markets as collateral.
    1. Docs: [Felix Documentation](https://usefelix.gitbook.io/felix-docs/developers/market-2-vanilla)
4. Leveraged Loop – borrow additional HYPE, wrap to wHYPE and repeat steps 2‑3.

Tasks:

- Add strategy contract for the veda vault with tests
- Add decoder and sanitizer for staked hype w/ tests
- Add strategy merkle roots w/ tests

Reference: [Boring Vault Repository](https://github.com/0xdgoat/boring-vault)

### Monitoring & Reporting (Use Vault Monitor Repo)

- Implement a data pipeline that tracks vault health in real time.
- Core Metrics
  - Total vault deposits (HYPE & USD‑equivalent)
  - stHYPE supplied as collateral in Felix
  - Outstanding HYPE borrowed
  - Net annualized yield on HYPE for the vault

Recommended stack

- Ponder for event indexing
- Supabase for database management
- Free archive RPCs
  - [HL Archive Node](https://hl-archive-node.xyz)
  - [Purro RPC](https://rpc.purroofgroup.com)

Reference: [Vault Monitor Repository](https://github.com/0xdgoat/vault_monitor)

# What did i Build

this is
