
# Privacy-Preserving Verification of Abundant Numbers Using Zero-Knowledge Proofs

### A zk-SNARK Research Prototype Using Circom, Groth16, and snarkjs

This repository contains an experimental implementation of a **zero-knowledge proof system for abundant-number verification**, developed as part of research into privacy-preserving number-theoretic computation.

The project investigates how arithmetic circuits, divisor-completeness checks, layered predicates, and batch verification techniques can be combined within the Groth16 zk-SNARK framework.

The broader research objective is to enable a prover to demonstrate that a private integer satisfies the mathematical definition of an abundant number without disclosing the integer or its divisors.

**Research title:** *Privacy-Preserving Verification of Abundant Numbers via Zero-Knowledge Proofs: Soundness Gadgets, Layered Predicates, and Batch Optimization*

> **Implementation status:** Research prototype. The repository contains experimental circuits and proof-generation scripts. The current constraints do not yet establish a fully sound proof of abundant-number classification. See [Security and Current Limitations](#security-and-current-limitations).

---

## 1. Overview

### What Is an Abundant Number?

A positive integer is classified as **abundant** when the sum of its proper positive divisors exceeds the number itself.

Equivalently, if $\sigma(n)$ denotes the sum of all positive divisors of $n$, then:

$$
\sigma(n) > 2n
$$

For example, consider the integer 12.

Its positive divisors are:

$$
D(12) = \{1,2,3,4,6,12\}
$$

Their sum is:

$$
\sigma(12) = 1+2+3+4+6+12 = 28
$$

Since:

$$
28 > 2(12) = 24
$$

12 is an abundant number.

### Why Zero-Knowledge Proofs?

Traditional verification of abundance requires knowledge of the integer and sufficient information about its divisors.

In privacy-sensitive environments, revealing these values may be undesirable.

Zero-knowledge proofs offer a cryptographic approach in which a prover demonstrates knowledge of a witness satisfying a specified arithmetic relation while keeping designated witness values private.

The intended system separates:

- **Prover:** Holds the private integer, divisors, and corresponding quotient witnesses.
- **Arithmetic circuit:** Enforces mathematical relations on the supplied witness.
- **Proof generator:** Produces a succinct cryptographic proof using Groth16.
- **Verifier:** Checks the proof using a verification key and any designated public inputs.

The central challenge is not merely verifying that supplied numbers divide an integer, but ensuring that the arithmetic constraints correctly characterize abundance and cannot be satisfied using incomplete or manipulated divisor sets.

---

## 2. Research Objectives

The project explores four interconnected objectives.

### Objective 1: Privacy-Preserving Abundance Verification

Represent the mathematical conditions for abundant-number classification using Circom arithmetic circuits.

The intended protocol should allow verification without exposing the underlying integer or its complete divisor set.

### Objective 2: Divisor Completeness and Soundness

Investigate arithmetic constraints that prevent a prover from providing an incomplete, duplicated, or otherwise manipulated divisor witness.

Divisibility alone is insufficient for proving abundance.

The implementation explores complementary-divisor membership checks and arithmetic consistency constraints as components of this problem.

### Objective 3: Layered Arithmetic Predicates

Investigate a modular circuit architecture in which individual mathematical properties are represented as separate constraint layers.

The architecture is intended to make additional number-theoretic predicates easier to incorporate and evaluate.

### Objective 4: Batch Verification and Performance Analysis

Explore aggregate arithmetic relations for verifying multiple divisor relationships.

The project includes scripts for measuring proof-generation time, verification time, and serialized proof size.

---

## 3. Technology Stack

| Technology | Purpose |
|------------|---------|
| Circom 2 | Arithmetic circuit development |
| Groth16 | zk-SNARK proving system |
| snarkjs | Trusted setup, proof generation, and verification |
| JavaScript | Proof-generation and benchmarking scripts |
| Node.js | JavaScript execution environment |
| npm | Dependency management |
| BN254 / bn128 | Elliptic-curve environment used by the proving workflow |
| R1CS | Rank-1 Constraint System representation |
| WebAssembly | Compiled circuit witness-generation environment |
| Git / GitHub | Version control and source-code hosting |

The Node.js dependency declared in `package.json` is `snarkjs` version `^0.7.6`.

The Circom compiler must be installed separately.

---

## 4. Repository Structure

```text
ZK-proof-for-abundant-numbers/
│
├── circuits/
│   ├── abundant_complete_system.circom
│   ├── divisor_completeness.circom
│   ├── batch_divisor_check.circom
│   ├── layered_predicates.circom
│   │
│   └── lib/
│       └── membership_check.circom
│
├── scripts/
│   ├── setup.sh
│   ├── generate_proof.js
│   ├── generate_proof_all_layers.js
│   ├── benchmark.js
│   └── construct_batch_inputs.js
│
├── test_data/
│   └── test_cases.json
│
├── package.json
├── package-lock.json
├── proof.json
├── public.json
│
├── pot.ptau
├── pot1.ptau
├── pot_final.ptau
│
├── .gitignore
└── README.md
```

### Core Circuit Components

| File | Responsibility |
|------|---------------|
| `abundant_complete_system.circom` | Integrates the principal circuit components |
| `divisor_completeness.circom` | Applies divisibility, complementary-divisor membership, and arithmetic conditions |
| `batch_divisor_check.circom` | Implements an aggregate product relation across divisor-quotient pairs |
| `layered_predicates.circom` | Defines abundance-related and additional experimental predicate layers |
| `membership_check.circom` | Provides an array-membership component |

### Supporting Scripts

| File | Responsibility |
|------|---------------|
| `setup.sh` | Circuit compilation and Groth16 setup |
| `generate_proof.js` | Proof generation for the standalone divisor-completeness workflow |
| `generate_proof_all_layers.js` | Proof generation using the integrated circuit |
| `benchmark.js` | Timing of proof generation and verification |
| `construct_batch_inputs.js` | Placeholder for batch-input construction |

---

## 5. System Architecture

The system follows a conventional zk-SNARK development workflow.

```text
                  PRIVATE WITNESS
              ┌─────────────────────┐
              │ Integer n           │
              │ Divisors[]          │
              │ Quotients[]         │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │  Circom Circuit     │
              ├─────────────────────┤
              │ Divisibility        │
              │ Membership Checks   │
              │ Aggregate Products  │
              │ Arithmetic Layers   │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │   R1CS Constraints  │
              │   Witness Generator │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │  Groth16 Prover     │
              │  Proving Key        │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ Cryptographic Proof │
              │ Public Signals      │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ Groth16 Verifier    │
              │ Verification Key    │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │ true / false        │
              └─────────────────────┘
```

**Important:** A successful cryptographic verification establishes satisfaction of the implemented circuit constraints. It does not automatically establish the mathematical correctness or completeness of those constraints.

---

## 6. Circuit Design

### 6.1 Divisor Verification

For each supplied divisor $d_i$, the circuit uses a quotient witness $q_i$ and checks:

$$
d_i q_i = n
$$

This relation is enforced in:

`circuits/divisor_completeness.circom`

The intended relationship is that every supplied divisor divides the private integer.

### 6.2 Complementary-Divisor Membership

For every divisor-quotient pair, the circuit also attempts to establish:

$$
q_i \in D
$$

where $D$ denotes the supplied divisor array.

This check is implemented using:

`circuits/lib/membership_check.circom`

The purpose is to enforce complementary-pair consistency within the supplied witness.

However, complementary-pair consistency alone does not prove that every positive divisor of the integer has been included.

### 6.3 Divisor Summation

The circuit constructs an accumulated sum of the supplied divisor values:

$$
S = \sum_{i=1}^{k} d_i
$$

where $k$ is the fixed circuit array length.

For a complete, duplicate-free divisor set, this sum should equal:

$$
S = \sigma(n)
$$

The current implementation does not independently establish that the supplied array is the complete set of distinct positive divisors.

### 6.4 Abundance Predicate

The intended abundance condition is:

$$
\sigma(n) - 2n > 0
$$

The current implementation constructs:

```circom
diff <== sigma - 2 * n;
inv <-- 1 / diff;
diff * inv === 1;
```

This enforces that `diff` is nonzero in the circuit field.

It does **not** establish that `diff` is a strictly positive integer.

An integer-range comparison gadget is required to distinguish the intended inequality from nonzero field arithmetic.

### 6.5 Batch Divisor Verification

The batch-checking circuit constructs the product:

$$
P = \prod_{i=1}^{k}(d_iq_i)
$$

and compares it against:

$$
n^k
$$

The intended aggregate relation is:

$$
\prod_{i=1}^{k}(d_iq_i) = n^k
$$

This provides an experimental aggregate consistency check.

The aggregate product equality by itself does not prove that every individual divisor relationship is correct. The integrated circuit separately includes individual divisibility constraints.

### 6.6 Layered Predicates

The `LayeredPredicates` template organizes arithmetic checks into conceptual layers.

**Layer 1 — Abundance-related arithmetic**

Constructs the divisor sum and nonzero difference check.

**Layer 2 — Divisor count**

Uses a fixed circuit array length rather than dynamically validating the mathematical number of divisors.

**Layer 3 — Congruence-related predicates**

Contains commented-out experimental logic for an even-sum condition.

The third layer is not currently enforced.

### 6.7 Integrated Circuit

The main circuit combines the three primary components:

```circom
component c1 = DivisorCompleteness(nDivs);
component c2 = BatchDivisorCheck(nDivs);
component c3 = LayeredPredicates(nDivs);
```

The entry point is:

```circom
component main = FullSystem(16);
```

Therefore, the current integrated circuit expects arrays containing exactly 16 divisor and quotient slots.

---

## 7. Installation

### Prerequisites

Install the following before running the project:

- Node.js and npm
- Circom compiler version 2.x
- Git
- A shell environment capable of running Bash scripts

Circom installation instructions are available from the official documentation:

https://docs.circom.io/

### Step 1: Clone the Repository

```bash
git clone https://github.com/Varun-CHINTHANIPPU/ZK-proof-for-abundant-numbers.git

cd ZK-proof-for-abundant-numbers
```

### Step 2: Install Dependencies

```bash
npm ci
```

### Step 3: Verify the Tools

```bash
node --version
npm --version
circom --version
npx snarkjs --version
```

### Step 4: Prepare Build Directories

```bash
mkdir -p build keys
```

These directories are required by the provided setup workflow.

---

## 8. Circuit Compilation and Trusted Setup

The repository includes:

```bash
scripts/setup.sh
```

This script performs the following operations:

1. Compiles the integrated Circom circuit.
2. Initializes a Powers of Tau ceremony.
3. Performs a local ceremony contribution.
4. Prepares the phase-two ceremony parameters.
5. Generates a Groth16 proving key.
6. Exports the verification key.

The setup workflow can be invoked from the repository root using:

```bash
bash scripts/setup.sh
```

The script contains commands corresponding to the following stages.

### Circuit Compilation

```bash
circom circuits/abundant_complete_system.circom \
  --r1cs \
  --wasm \
  -o build
```

### Groth16 Setup

```bash
npx snarkjs groth16 setup \
  build/abundant_complete_system.r1cs \
  pot_final.ptau \
  abundant_complete_system.zkey
```

### Verification Key Export

```bash
npx snarkjs zkey export verificationkey \
  abundant_complete_system.zkey \
  keys/verification_key.json
```

**Setup notes:**

- The setup script has not been established as a fully reproducible, unattended installation process.
- The Powers of Tau contribution may request interactive randomness.
- The project already contains ceremony artifacts. Running setup commands may overwrite files with matching names.
- The generated proving and verification keys must correspond to the same circuit and trusted setup.
- Local ceremony artifacts should not be assumed suitable for production security.

---

## 9. Proof Generation and Verification

### Integrated Proof Workflow

The integrated proof-generation script is:

```bash
node scripts/generate_proof_all_layers.js
```

It is designed to execute multiple example cases using the integrated circuit.

The script attempts to:

1. Construct quotient witnesses.
2. Pad divisor and quotient arrays to 16 elements.
3. Generate a Groth16 proof.
4. Load the verification key.
5. Verify the generated proof.
6. Print performance information.

The script expects the following generated artifacts:

```text
build/abundant_complete_system_js/
    abundant_complete_system.wasm

abundant_complete_system.zkey

keys/
    verification_key.json
```

### Standalone Proof Workflow

The repository also contains:

```bash
node scripts/generate_proof.js
```

This script targets a separate divisor-completeness workflow and references:

```text
build/divisor_completeness_js/divisor_completeness.wasm

divisor_completeness.zkey

keys/verification_key.json
```

These files are not produced by the integrated setup script.

Consequently, the standalone workflow requires its own compatible compilation and setup artifacts.

**Execution note:** The provided scripts are experimental. Successful end-to-end execution is not guaranteed by the repository's current configuration. The circuit and witness-generation limitations described below may cause compilation, proof-generation, or verification failures.

---

## 10. Test Cases

The repository contains illustrative abundant-number test inputs.

### Basic Inputs

The `test_data/test_cases.json` file contains examples for:

| Integer | Divisors | Classification |
|---------|----------|----------------|
| 12 | 1, 2, 3, 4, 6, 12 | Abundant |
| 18 | 1, 2, 3, 6, 9, 18 | Abundant |

### Integrated Script Cases

The integrated proof-generation script contains the following cases:

| Integer | Sum of Divisors | Classification |
|---------|-----------------|----------------|
| 12 | 28 | Abundant |
| 20 | 42 | Abundant |
| 24 | 60 | Abundant |
| 30 | 72 | Abundant |
| 40 | 90 | Abundant |
| 48 | 124 | Abundant |
| 60 | 168 | Abundant |
| 84 | 224 | Abundant |
| 96 | 252 | Abundant |
| 120 | 360 | Abundant |

These values represent the mathematical classifications of the supplied examples, not a claim that the current circuit successfully proves each case.

The present examples focus on abundant numbers. They do not constitute a comprehensive adversarial test suite.

---

## 11. Performance Evaluation

The project contains functionality for measuring three primary performance characteristics.

### Proof Generation Time

Measures the elapsed time required to generate a Groth16 proof.

### Proof Verification Time

Measures the elapsed time required for the Groth16 verifier to validate a proof.

### Proof Size

Measures the serialized size of the generated proof in kilobytes.

The integrated script reports values in the following format:

```text
n = <integer>
σ(n) = <sum>

Proving time: <seconds>
Verify time: <seconds>
Proof size: <kilobytes>
Valid: <true/false>
```

The repository also contains:

```bash
scripts/benchmark.js
```

This benchmark uses the standalone divisor-completeness circuit artifacts.

Its execution requires the corresponding compiled witness generator, proving key, and verification key.

**No general performance or scalability claim should be inferred solely from the existence of these scripts.** Reproducible measurements and correctness validation are separate requirements.

---

## 12. Expected Outputs

Depending on the workflow executed, the project can produce the following artifacts.

| Artifact | Description |
|----------|-------------|
| `.r1cs` | Compiled arithmetic constraints |
| `.wasm` | Circuit witness-generation module |
| `.zkey` | Groth16 proving-key artifact |
| `verification_key.json` | Verification key |
| `proof.json` | Serialized Groth16 proof |
| `public.json` | Public signal values |
| Console timing output | Proving and verification measurements |

The standalone proof-generation script writes `proof.json` and `public.json`.

The integrated proof-generation script primarily prints proof and timing information to the console.

The existing `public.json` contains an empty array. The integrated circuit currently declares no explicit public inputs, meaning a verifier cannot directly associate the proof with an externally specified integer or commitment.

---

## 13. Security and Current Limitations

This project is intended for academic experimentation and must not be treated as a production-ready cryptographic proof system.

Several important limitations remain in the current implementation.

### 13.1 Incomplete Divisor-Set Soundness

Verifying:

$$
d_iq_i=n
$$

and checking complementary-divisor membership does not establish that every positive divisor of $n$ has been included.

The circuit also does not fully enforce positive, distinct, bounded integer divisors.

Therefore, the current constraints do not guarantee:

$$
S=\sigma(n)
$$

### 13.2 Nonzero Is Not Greater Than Zero

The abundance-related constraint uses an inverse witness to enforce:

$$
S-2n \ne 0
$$

over the circuit field.

This is not equivalent to the required integer inequality:

$$
S>2n
$$

A sound abundance predicate requires appropriate integer representations, range constraints, and comparison logic.

### 13.3 Array Padding

The integrated JavaScript script pads smaller divisor arrays by repeating their final element.

This can introduce duplicate divisors and alter the calculated sum.

It can also conflict with the current membership-checking behavior.

Padding must not be interpreted as mathematically preserving the divisor set.

### 13.4 Membership Gadget

The membership component uses inverse witnesses and accumulated equality indicators.

Its handling of zero differences, duplicate values, and witness constraints requires additional soundness review.

### 13.5 Aggregate Product Constraints

The batch product relation alone does not ensure that every divisor-quotient pair is valid.

It must not replace the individual constraints without an independently justified soundness argument.

### 13.6 Public Statement Binding

The integrated circuit does not declare a public integer, commitment, or other externally bound statement.

Accordingly, a verifying party cannot use the present proof interface to establish that a particular externally identified private integer is abundant.

### 13.7 Cryptographic Setup

The repository includes experimental Powers of Tau artifacts.

Their presence does not establish that the setup was generated through a publicly verifiable or production-grade trusted ceremony.

### 13.8 Testing and Validation

The repository does not currently contain a complete automated regression suite for the mathematical and cryptographic security properties.

In particular, successful proving for selected examples would not establish general soundness.

**Security conclusion:** A verified Groth16 proof demonstrates satisfaction of the implemented R1CS relation under the proving system's cryptographic assumptions. The present R1CS relation is not yet a complete or sound characterization of abundant numbers.

---

## 14. Research Significance

Abundant-number verification provides a useful case study for investigating the boundary between ordinary computational checks and cryptographically sound mathematical statements.

In particular, it illustrates several challenges in zero-knowledge circuit development:

- Translating integer number theory into finite-field arithmetic.
- Distinguishing divisor membership from divisor-set completeness.
- Preventing manipulated or duplicated arithmetic witnesses.
- Designing valid range and comparison constraints.
- Constructing reusable arithmetic components.
- Evaluating aggregate constraint strategies without weakening soundness.
- Separating proof-system validity from application-level correctness.
- Balancing circuit complexity, proof generation, and verification performance.

Although abundant numbers form the motivating application, these challenges are relevant to broader research on verifiable computation, privacy-preserving mathematics, and constraint-system design.

---

## 15. Related Research

**Privacy-Preserving Verification of Abundant Numbers via Zero-Knowledge Proofs: Soundness Gadgets, Layered Predicates, and Batch Optimization**

This repository explores implementation concepts associated with the above research topic.

The project focuses on the use of zero-knowledge arithmetic circuits to represent number-theoretic properties, investigate potential soundness failures, and examine proof-generation and verification workflows.

The repository should be regarded as an experimental codebase rather than a fully validated reference implementation of the research claims.

---

## 16. References and Documentation

The following resources provide background information about the principal technologies.

1. **Circom Documentation**  
   https://docs.circom.io/

2. **snarkjs Repository**  
   https://github.com/iden3/snarkjs

3. **Circom Source Code**  
   https://github.com/iden3/circom

4. **Groth16 — On the Size of Pairing-Based Non-interactive Arguments**  
   Jens Groth, EUROCRYPT 2016.  
   https://doi.org/10.1007/978-3-662-49896-5_11

5. **Rank-1 Constraint Systems and Arithmetic Circuits**  
   https://docs.circom.io/background/background/

---

## 17. Repository

**GitHub:**  
https://github.com/Varun-CHINTHANIPPU/ZK-proof-for-abundant-numbers

**Maintainer:** [Varun-CHINTHANIPPU](https://github.com/Varun-CHINTHANIPPU)

**Research Areas:**

- Zero-Knowledge Proofs
- zk-SNARKs
- Applied Cryptography
- Number Theory
- Privacy-Preserving Computation
- Arithmetic Circuit Design
- Cryptographic Protocol Verification

---

## Disclaimer

This repository is provided for research, learning, and experimental evaluation.

The circuit implementations, setup artifacts, and proof-generation scripts have not been established as production-secure or independently audited.

Do not use the current implementation to support security-critical claims about the abundance of private integers without additional mathematical, constraint-level, and cryptographic validation.
