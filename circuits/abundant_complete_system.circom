pragma circom 2.0.0;

include "./divisor_completeness.circom";
include "./batch_divisor_check.circom";
include "./layered_predicates.circom";

template FullSystem(nDivs) {
    signal input n;
    signal input divisors[nDivs];
    signal input quotients[nDivs];

    component c1 = DivisorCompleteness(nDivs);
    c1.n <== n;
    c1.divisors <== divisors;
    c1.quotients <== quotients;

    component c2 = BatchDivisorCheck(nDivs);
    c2.n <== n;
    c2.divisors <== divisors;
    c2.quotients <== quotients;

    component c3 = LayeredPredicates(nDivs);
    c3.n <== n;
    c3.divisors <== divisors;
}

component main = FullSystem(16);
