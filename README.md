# ZK Proof for Abundant Numbers

This repository is a research prototype for proving whether an integer is abundant using zero-knowledge proofs.

The project uses Circom and Groth16 through snarkjs to express arithmetic constraints, generate witnesses, and verify proofs while keeping the underlying number private.

## Overview

An abundant number is a positive integer whose sum of proper divisors is greater than the number itself.

This project explores how that property can be encoded as a zk-SNARK circuit and verified without revealing the secret value directly.

## Project structure

```text
.
├── circuits/
│   ├── abundant_complete_system.circom
│   ├── batch_divisor_check.circom
│   ├── divisor_completeness.circom
│   ├── layered_predicates.circom
│   └── lib/
│       └── membership_check.circom
├── scripts/
│   ├── benchmark.js
│   ├── generate_proof.js
│   ├── generate_proof_all_layers.js
│   └── setup.sh
├── test_data/
│   └── test_cases.json
├── .gitignore
├── README.md
├── package.json
├── package-lock.json
├── pot.ptau
├── pot1.ptau
├── pot_final.ptau
├── proof.json
├── public.json
└── README.md
```

## Prerequisites

- Node.js 18+
- npm
- Circom 2.x
- Bash-compatible shell

## Installation

```bash
git clone https://github.com/Varun-CHINTHANIPPU/ZK-proof-for-abundant-numbers.git
cd ZK-proof-for-abundant-numbers
npm ci
```

## Setup

```bash
bash scripts/setup.sh
```

This script compiles the Circom circuit, prepares the Powers of Tau files, generates the Groth16 proving key, and exports the verification key.

## Run examples

### Integrated circuit proof

```bash
node scripts/generate_proof_all_layers.js
```

### Standalone proof script

```bash
node scripts/generate_proof.js
```

### Benchmark

```bash
node scripts/benchmark.js
```

## Notes

- This is an experimental research project.
- The circuit logic is intended for learning and prototyping.
- The implementation is not presented as production-ready cryptographic validation.
- Correctness depends on the circuit design, witness generation, and trusted setup process.

## Research intent

The repository is meant to explore how a number-theoretic statement like abundance can be converted into finite-field arithmetic constraints and verified through a zk-SNARK workflow.
