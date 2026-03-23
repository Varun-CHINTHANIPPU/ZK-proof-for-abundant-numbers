const { performance } = require("perf_hooks");
const snarkjs = require("snarkjs");
const fs = require("fs");

async function test(n, divisors, quotients) {
    const input = {
        n: n.toString(),
        divisors: divisors.map(String),
        quotients: quotients.map(String)
    };

    const start = performance.now();

    const { proof, publicSignals } = await snarkjs.groth16.fullProve(
        input,
        "build/divisor_completeness_js/divisor_completeness.wasm",
        "divisor_completeness.zkey"
    );

    const end = performance.now();

    const vKey = JSON.parse(fs.readFileSync("keys/verification_key.json"));
    const verifyStart = performance.now();

    const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);

    const verifyEnd = performance.now();

    return {
        n,
        time: (end - start).toFixed(2),
        verify: (verifyEnd - verifyStart).toFixed(2),
        valid: res
    };
}

async function run() {
    const tests = [
        { n: 12, d: [1,2,3,4,6,12], q: [12,6,4,3,2,1] },
        { n: 18, d: [1,2,3,6,9,18], q: [18,9,6,3,2,1] }
    ];

    for (const t of tests) {
        const res = await test(t.n, t.d, t.q);
        console.log(res);
    }
}

run();
