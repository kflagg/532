data {
    int<lower=0> N;
    int<lower=0> p;
    vector[N] y;
    matrix[N, p] x;
}

parameters {
    vector[p] beta;
    real<lower=0> sigma;
}

model {
    for(i in 1:p)
    {
        beta[i] ~ normal(0, 100);
    }
    y ~ normal(x * beta, sigma);
}
