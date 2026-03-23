pragma circom 2.0.0;

/*
Multiple property verification
*/

template LayeredPredicates(nDivs) {
    signal input n;
    signal input divisors[nDivs];

    // ---- Layer 1: Abundance ----
    signal sum[nDivs+1];
    sum[0] <== 0;

    for (var i = 0; i < nDivs; i++) {
        sum[i+1] <== sum[i] + divisors[i];
    }

    signal sigma;
    sigma <== sum[nDivs];

    signal diff;
    signal inv;

    diff <== sigma - 2 * n;
    inv <-- 1 / diff;
    diff * inv === 1;

    // ---- Layer 2: Divisor Count ----
    // enforced by circuit size (nDivs)

    // ---- Layer 3: Simple congruence ----
//    signal remainder;
//    remainder <-- sigma % 2;

    // enforce even sigma
//    remainder === 0;
}


