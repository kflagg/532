require(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

###########################################################################
##                    Sampling a normal distribution                     ##
###########################################################################

stan1 <- stan_model(file = 'sample_normal.stan', model_name = 'normal')
samp1 <- sampling(stan1, chains = 4, iter = 1000000)
theta <- extract(samp1)$theta

hist(theta, freq = FALSE, breaks = 100)
curve(dnorm(x, 0, 1), add = TRUE)

###########################################################################
##                             Linear model                              ##
###########################################################################

data(mtcars)
head(mtcars)

lm(mpg ~ hp + cyl + wt, mtcars)

cars.data <- with(mtcars, list(y = mpg,
                               x = cbind(rep(1, length(mpg)), hp, cyl, wt),
                               N = length(mpg),
                               p = 4))

stan2 <- stan_model(file = 'sample_lm.stan', model_name = 'stanlm')
samp2 <- sampling(stan2, chains = 4, iter = 2000, data = cars.data)
samp2

###########################################################################
##                              Lightbulbs                               ##
###########################################################################

N <- 100
y <- rexp(N, 1 / 200)

hist(y, freq = FALSE, breaks = 50)

C <- 250

idx <- which(y > C)
yobs <- y[-idx]
Ncens <- length(idx)

cens_data <- list(y = yobs, N = N, Ncens = Ncens, C = C)

stan3 <- stan_model(file = 'sample_cens.stan', model_name = 'censored')
samp3 <- sampling(stan3, chains = 4, iter = 2000, data = cens_data)
lambda <- extract(samp3)$lambda
hist(lambda, freq = FALSE, breaks = 50)
curve(dgamma(x, N-Ncens+1, sum(yobs)+Ncens*C), add = TRUE)
