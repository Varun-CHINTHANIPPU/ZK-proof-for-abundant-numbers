pragma circom 2.0.0;

template LayeredPredicates(nDivs) {
    signal input n;
    signal input divisors[nDivs];

    signal sum[nDivs + 1];
    sum[0] <== 0;

    for (var i = 0; i < nDivs; i++) {
        sum[i + 1] <== sum[i] + divisors[i];
    }

    signal sigma;
    sigma <== sum[nDivs];

    signal diff;
    signal inv;

    diff <== sigma - 2 * n;
    inv <-- 1 / diff;
    diff * inv === 1;
}
