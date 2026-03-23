pragma circom 2.0.0;

/*
Batch verification of divisors (quadratic-safe)
*/

template BatchDivisorCheck(nDivs) {
    signal input n;
    signal input divisors[nDivs];
    signal input quotients[nDivs];

    signal product[nDivs+1];
    signal temp[nDivs];

    product[0] <== 1;

    for (var i = 0; i < nDivs; i++) {
        temp[i] <== divisors[i] * quotients[i];
        product[i+1] <== product[i] * temp[i];
    }

    signal expected;
    expected <-- n ** nDivs;

    product[nDivs] === expected;
}
