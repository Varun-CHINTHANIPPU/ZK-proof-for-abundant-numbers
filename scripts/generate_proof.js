const snarkjs = require("snarkjs");
const fs = require("fs");

async function run() {
	const input = {
  		 n: "12",
	    	divisors: ["1","2","3","4","6","12"],
   		 quotients: ["12","6","4","3","2","1"]
	};    


    console.log("🚀 Generating proof...");

    const { proof, publicSignals } = await snarkjs.groth16.fullProve(
        input,
        "build/divisor_completeness_js/divisor_completeness.wasm",
        "divisor_completeness.zkey"
    );

    console.log("✅ Proof generated");

    const vKey = JSON.parse(fs.readFileSync("keys/verification_key.json"));

    const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);

    console.log("🔍 Verification result:", res);

    fs.writeFileSync("proof.json", JSON.stringify(proof, null, 2));
    fs.writeFileSync("public.json", JSON.stringify(publicSignals, null, 2));
}

run();
