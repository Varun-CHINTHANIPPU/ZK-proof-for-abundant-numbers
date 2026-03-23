#!/bin/bash

CIRCUIT="abundant_complete_system"
POT=12

echo "[1] Compiling..."
circom circuits/${CIRCUIT}.circom --r1cs --wasm -o build

echo "[2] Powers of Tau..."
npx snarkjs powersoftau new bn128 $POT pot.ptau

echo "[3] Contribute..."
npx snarkjs powersoftau contribute pot.ptau pot1.ptau --name="first"

echo "[4] Prepare..."
npx snarkjs powersoftau prepare phase2 pot1.ptau pot_final.ptau

echo "[5] Setup Groth16..."
npx snarkjs groth16 setup build/${CIRCUIT}.r1cs pot_final.ptau ${CIRCUIT}.zkey

echo "[6] Export verification key..."
npx snarkjs zkey export verificationkey ${CIRCUIT}.zkey keys/verification_key.json

echo "✅ DONE"
