ex37 <- data.frame('y' = c(0, 1, 3, 5),
                   'n' = c(5, 5, 5, 5),
                   'x' = c(-0.86, -0.30, -0.05, 0.73))

# Start with 4SEs in either direction
dAlpha <- 0.1
dBeta <- 0.1
alpha <- seq(-3, 6, ,length = dAlpha)
beta <- seq(-10, 50, length = dBeta)

alpha.beta.grid <- expand.grid('alpha' = alpha, 'beta' = beta)
