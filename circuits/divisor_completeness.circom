pragma circom 2.0.0;

include "./lib/membership_check.circom";

template DivisorCompleteness(nDivs) {
    signal input n;
    signal input divisors[nDivs];
    signal input quotients[nDivs];

    // -------------------------
    // C1: d * q = n
    // -------------------------
    for (var i = 0; i < nDivs; i++) {
        divisors[i] * quotients[i] === n;
    }

    // -------------------------
    // C2: q ∈ divisors
    // -------------------------
    component checks[nDivs];

    for (var i = 0; i < nDivs; i++) {
        checks[i] = MembershipCheck(nDivs);
        checks[i].value <== quotients[i];
        checks[i].array <== divisors;
        checks[i].isMember === 1;
    }

    // -------------------------
    // C3: sigma(n)
    // -------------------------
    signal sum[nDivs+1];
    sum[0] <== 0;

    for (var i = 0; i < nDivs; i++) {
        sum[i+1] <== sum[i] + divisors[i];
    }

    signal sigma;
    sigma <== sum[nDivs];

    // -------------------------
    // C4: sigma > 2n
    // -------------------------
    signal diff;
    signal inv;

    diff <== sigma - 2 * n;
    inv <-- 1 / diff;
    diff * inv === 1;
}

