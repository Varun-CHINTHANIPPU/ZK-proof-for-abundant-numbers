pragma circom 2.0.0;

/*
Check if value exists in array
*/

template MembershipCheck(n) {
    signal input value;
    signal input array[n];
    signal output isMember;

    signal diff[n];
    signal inv[n];
    signal matches[n];

    for (var i = 0; i < n; i++) {
        diff[i] <== value - array[i];
        inv[i] <-- 1 / diff[i];
        matches[i] <== 1 - diff[i] * inv[i];
    }

    signal sum[n+1];
    sum[0] <== 0;

    for (var i = 0; i < n; i++) {
        sum[i+1] <== sum[i] + matches[i];
    }

    // binary output (0 or ≥1 → clamp later if needed)
    isMember <== sum[n];
}
