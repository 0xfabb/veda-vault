# VedaVault

*A Looping Mechanism to Maximize Yield and Guarantee Safer Returns*

This repository contains my implementation of the **VedaVault** strategy — a stHYPE looping vault built as part of an assignment from Anthias Labs.

---

## Assignment Goal

The goal was to create a fully on-chain vault that loops user deposits to maximize yield while maintaining safety and transparency. Inspired by **Boring Vault**, I expanded the design to include better parameter checks, sanitizer logic, monitoring tools, and a clear separation between on-chain and off-chain responsibilities.

---

## The Prompt (Option 1: stHYPE Looping Vault)

Here’s the exact assignment:

> Build a vault that accepts `wHYPE`, stakes it to `stHYPE`, and loops that collateral in Felix markets to maximize yield. The vault should borrow `HYPE`, wrap it, and repeat the loop until reaching a safe collateral ratio.  

### Loop Strategy (Summarized)

1. Accept user deposits in **wHYPE**
2. Stake those into **stHYPE**
3. Supply `stHYPE` as collateral on **Felix**
4. Borrow `HYPE`, rewrap into `wHYPE`, and repeat

---

## What I Implemented

![Architecture](https://github.com/0xfabb/veda-vault/tree/main/src/images/architecture.png)

### Vault Strategy (On-Chain)

I broke the entire on-chain logic into 4 modular phases:

#### 1. Deposit Logic

- The user calls `deposit()` with their `wHYPE`
- I transfer the tokens in, verify with sanitizers
- I mint a receipt token (`vvHYPE`) back to the user — representing their share

#### 2. Staking Logic

- I call `Overseer.mint()` to convert `wHYPE` to `stHYPE`
- The staked tokens are held by the vault

#### 3. Collateral + Borrowing

- I send the `stHYPE` to Felix as collateral
- I borrow `HYPE` based on a safe LTV
- I wrap that borrowed `HYPE` back into `wHYPE`

#### 4. Looping

- I repeat Steps 2 & 3 until the loop hits a threshold (defined by me or by automation)
- This compounds the deposit into a much larger yield-generating position

---

### Monitoring & Automation (Off-Chain)

To keep everything healthy and safe, I built off-chain scripts to:

- Monitor vault deposits (both HYPE and USD value)
- Track total stHYPE supplied to Felix
- Track outstanding HYPE borrowed
- Calculate yield (APY) over time

I designed this in a way that it could easily be plugged into automation platforms like **Gelato** or **Chainlink Keepers**.

---

## Contract Architecture

### 1. `VedaVault.sol` — The Core Contract

This is the main entry point for the user. It handles:

- Deposits
- Staking into Overseer
- Borrowing from Felix
- Token issuance (vvHYPE)
- Withdrawals (burning vvHYPE)

### 2. `Overseer` — External Protocol

Used to stake `wHYPE` into `stHYPE`. I don’t own this; I just call it.

### 3. `Sanitizers.sol` — Guard Rails

I abstracted some key validations into a reusable contract. It includes:

- `onlyEOA` — blocks contract interactions
- `onlyWhitelisted` — lets me allow/deny specific users or bots
- Parameter validators (`checkOverseerAddress`, etc.)

### 4. `vvHYPE` — Receipt Token

An ERC20 vault token that I mint 1:1 to `wHYPE` deposits.  
Users hold this token as proof of their vault share and can burn it to withdraw.

### 5. Exchange Rate Oracle (Future)

I plan to add a custom oracle that dynamically computes vault share prices. Initially, 1 vvHYPE = 1 wHYPE, but this will shift as looping and yield kick in.

---

## Automation Components

To keep everything smooth, the off-chain components do:

- Auto-reinvestment when collateral space opens
- Health checks on LTV ratios
- Emitting events to analytics dashboards (via Supabase + Ponder)
- Alerting + logging

---

## What is finished so far 

Here’s what’s fully working and tested:

- [x] User deposits `wHYPE`
- [x] Vault mints `vvHYPE`
- [x] Funds are staked into `stHYPE`
- [x] Borrowing and re-wrapping logic is ready
- [x] Merkle proofs are generated for event logs
- [x] Vault monitoring dashboard is wired up

---

## Tech Stack

- **Solidity 0.8.x**
- **OpenZeppelin Contracts**
- **Supabase** — Vault monitoring database
- **Ponder** — Indexing events from the chain
- **Felix Protocol** — For lending/borrowing
- **stHYPE Protocol** — For staking
