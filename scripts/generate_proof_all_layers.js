const snarkjs = require("snarkjs");
const fs = require("fs");

async function generateProof(n, divisors) {
    const wasmPath = "./build/abundant_complete_system_js/abundant_complete_system.wasm";
    const zkeyPath = "./abundant_complete_system.zkey";

    // compute quotients
    const quotients = divisors.map(d => n / d);
    const sigma = divisors.reduce((a, b) => a + b, 0);

    // -------- FIXED SIZE PADDING --------
    const MAX = 16;

    // repeat last valid divisor
    const paddedDivisors = [...divisors];
    while (paddedDivisors.length < MAX) {
        paddedDivisors.push(divisors[divisors.length - 1]);
    }

    // repeat last valid quotient
    const paddedQuotients = [...quotients];
    while (paddedQuotients.length < MAX) {
        paddedQuotients.push(quotients[quotients.length - 1]);
    }

    const input = {
        n: n.toString(),
        divisors: paddedDivisors.map(d => d.toString()),
        quotients: paddedQuotients.map(q => q.toString())
    };

    console.log("\n==================================================");
    console.log(`n = ${n}`);
    console.log(`σ(n) = ${sigma}`);
    console.log("==================================================");

    try {
        const start = Date.now();

        const { proof, publicSignals } = await snarkjs.groth16.fullProve(
            input,
            wasmPath,
            zkeyPath
        );

        const proveTime = (Date.now() - start) / 1000;

        const vKey = JSON.parse(fs.readFileSync("./keys/verification_key.json"));

        const verifyStart = Date.now();
        const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);
        const verifyTime = (Date.now() - verifyStart) / 1000;

        const proofSize = Buffer.byteLength(JSON.stringify(proof)) / 1024;

        console.log(`✓ Proving time: ${proveTime.toFixed(3)}s`);
        console.log(`✓ Verify time: ${verifyTime.toFixed(3)}s`);
        console.log(`✓ Proof size: ${proofSize.toFixed(2)} KB`);
        console.log(`✓ Valid: ${res}`);

        return { proveTime, verifyTime, proofSize, res };

    } catch (err) {
        console.error("❌ Error:", err.message);
        return null;
    }
}

if (require.main === module) {
    (async () => {
        const tests = [
            { n: 12, d: [1,2,3,4,6,12] },
            { n: 20, d: [1,2,4,5,10,20] },
            { n: 24, d: [1,2,3,4,6,8,12,24] },
            { n: 30, d: [1,2,3,5,6,10,15,30] },
            { n: 40, d: [1,2,4,5,8,10,20,40] },
            { n: 48, d: [1,2,3,4,6,8,12,16,24,48] },
            { n: 60, d: [1,2,3,4,5,6,10,12,15,20,30,60] },
            { n: 84, d: [1,2,3,4,6,7,12,14,21,28,42,84] },
            { n: 96, d: [1,2,3,4,6,8,12,16,24,32,48,96] },
            { n: 120, d: [1,2,3,4,5,6,8,10,12,15,20,24,30,40,60,120] }
        ];

        for (const t of tests) {
            await generateProof(t.n, t.d);
        }
    })();
}

module.exports = { generateProof };
