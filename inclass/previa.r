## 1. Prior density

# Big string of ifelse
ptheta<-function(theta){
  return(ifelse(theta < 0, 0,
                ifelse(theta < 0.385, 0.5,
                       ifelse(theta < 0.485, 50*(theta-0.385)+0.5,
                              ifelse(theta < 0.585, 50*(0.585-theta)+0.5,
                                     ifelse(theta <= 1, 0.5, 0))))))
}


## 2. Plot

curve(ptheta(x), from = -0.05, to = 1.05, n = 1001, xlab = expression(theta), ylab = expression(p(theta)), main = 'Prior Density')


## 3. Numerical integration

n.rects <- 1000

# Left endpoints
theta.grid.l <- seq(0, 1, length.out = n.rects + 1)[1:n.rects]

# Right endpoints
theta.grid.r <- seq(0, 1, length.out = n.rects + 1)[(1:n.rects)+1]

# Midpoints
theta.grid.m <- (theta.grid.l + theta.grid.r) / 2

areas.l <- sapply(theta.grid.l, ptheta) / n.rects
areas.r <- sapply(theta.grid.r, ptheta) / n.rects
areas.m <- sapply(theta.grid.m, ptheta) / n.rects

sum.l <- sum(areas.l)
sum.r <- sum(areas.r)
sum.m <- sum(areas.m)

cat('Left sum = ', sum.l, ', Right sum = ', sum.r, ', Middle sum = ', sum.m, sep = '')


## 4. Random draws

draws <- sample(theta.grid.m, size = 1000, prob = areas.m / sum.m, replace = TRUE)
hist(draws, breaks = 20, freq = FALSE, ylim = c(0, 6), xlab = expression(theta), main = 'Histogram of 1000 Prior Draws')
curve(ptheta(x), n = 1001, col = 'red', add = TRUE)


## 5. Summary of draws

cat('Mean = ', mean(draws), ', Median = ', median(draws), sep = '')
cat('Proportion below 0.385 is', mean(draws < 0.385))
cat('Proportion between 0.385 and 0.485 is', mean(draws > 0.385 & draws < 0.485))


## 6. Likelihood

Ltheta <- function(theta, count, n){
  return(dbinom(count, n, theta))
}


## 7. Plot

curve(ptheta(x), from = 0, to = 1, n = 1001, lwd = 2, col = 'grey', ylim = c(0, 6), yaxt = 'n', xlab = expression(theta), ylab = '', main = 'Likelihood and Prior Density')
curve(Ltheta(x, 437, 980) * 200, n = 1001, add = TRUE)


## 8. MLE

segments(x0 = 437 / 980, y0 = 0, y1 = Ltheta(437 / 980, 437, 980) * 200,
         lty = 2, col = 'red')

## 9. Unnormalized posterior

proppost <- function(theta, count, n){
  return(Ltheta(theta, count, n) * ptheta(theta))
}


## 10. Normlized posterior

areas.p.l <- sapply(theta.grid.l, function(x){proppost(x, count = 437, n = 980)}) / n.rects
areas.p.r <- sapply(theta.grid.r, function(x){proppost(x, count = 437, n = 980)}) / n.rects
areas.p.m <- sapply(theta.grid.m, function(x){proppost(x, count = 437, n = 980)}) / n.rects

sum.p.l <- sum(areas.p.l)
sum.p.r <- sum(areas.p.r)
sum.p.m <- sum(areas.p.m)

cat('Left sum = ', sum.p.l, ', Right sum = ', sum.p.r, ', Middle sum = ', sum.p.m, sep = '')

# Normalizing constant is the mean of the three sums
pthetay <- function(theta, count, n){
  return(Ltheta(theta, count, n) * ptheta(theta) / 0.003616404298344817313388)
}


## 11. Plot
curve(ptheta(x), from = 0, to = 1, n = 1001, lwd = 2, lty = 1, col = 'grey', ylim = c(0, 6), yaxt = 'n', xlab = expression(theta), ylab = '', main = 'Prior Density, Likelihood, and Posterior Density', sub = 'Scaled to appear in the same range.')
curve(Ltheta(x, 437, 980) * 150, n = 1001, add = TRUE, lwd = 1, lty = 3, col = 'blue')
curve(pthetay(x, 437, 980) / 5, n = 1001, add = TRUE, lwd = 1, lty = 2, col = 'black')
legend('topright', lwd = c(2, 1, 1), lty = c(1, 3, 2), col = c('grey', 'blue', 'black'), legend = c('Prior', 'Likelihood', 'Posterior'))
