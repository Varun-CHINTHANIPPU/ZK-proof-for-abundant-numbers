# ZK Proof for Abundant Numbers

This repository contains a research prototype for proving that an integer is abundant using zero-knowledge proofs.

The project uses Circom and Groth16 via snarkjs to encode arithmetic constraints, generate witness data, and verify proofs without exposing the underlying secret values.

## What this project does

The circuit checks a set of divisor and quotient witnesses against arithmetic constraints related to abundance. The goal is to demonstrate a privacy-preserving verification flow for a number-theoretic property, while keeping the logic exploratory and research-focused.

## Repository structure

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
├── public.json
├── proof.json
└── README.md
```

## Prerequisites

- Node.js 18+
- npm
- Circom 2.x
- A Unix-like shell for the setup script

## Install

```bash
git clone https://github.com/Varun-CHINTHANIPPU/ZK-proof-for-abundant-numbers.git
cd ZK-proof-for-abundant-numbers
npm ci
```

## Setup and proof generation

### Compile and prepare the trusted setup

```bash
bash scripts/setup.sh
```

### Run the integrated proof script

```bash
node scripts/generate_proof_all_layers.js
```

### Run the standalone proof script

```bash
node scripts/generate_proof.js
```

### Run the benchmark

```bash
node scripts/benchmark.js
```

## Notes

- This repository is intended for experimentation and learning.
- The circuit logic is not presented as production-ready cryptographic validation.
- The implementation is best understood as a proof-of-concept for circuit design and zk-SNARK workflow development.
- Final correctness depends on the soundness of the arithmetic constraints, trusted setup, and witness generation process.

## Research context

The project explores how a number-theoretic property like abundance can be translated into finite-field arithmetic constraints, verified in a zk-SNARK, and used as a case study for privacy-preserving mathematical verification.
