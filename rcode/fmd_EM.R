# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Finite mixture density classification -----------------------------------

# JCR
# 
# This file comes from 
#   - "Dropbox/.../MyRfuns/f.Finite_mixture_density_EM.R" and
#   - "Dropbox/.../MyRscripts/Finite_mixture_density_EM.R"
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# if(!require(magick)) install.packages("magick")
# library(magick)
library(MASS)
library(mvtnorm)
library(mclust)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# My function for Finite Mixture Modelling (Gaussian) ---------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Uses EM algorithm with multivariate normal densities
#' to estimate cluster probability

#' multivariate Gaussian pdf for vector xi
#' Apply dmvnorm to all rows of matrix X
#' Much faster if we use the dmvnorm function of the 

dmvnorm_mat <- function(X, mu, Sigma){
  p <- ncol(X)
  apply(X, 1, function(xi) dmvnorm(matrix(xi, ncol=p), mu, Sigma))
}

#' Function to calculate the covariance matrix of each cluster

f.cov <- function(X,mu,n,w){
  Sj <- lapply(1:nrow(X), function(r) w[r]*(X[r,]-mu) %*% t(X[r,]-mu))
  S <- Reduce("+", Sj)
  return(1/n * S)
}

A <- matrix(rep(1,4),ncol=2)
m <- rep(0.5,2)
n <- nrow(A)
w <- rep(1,n)
f.cov(A,m,n,w)

#' My finite mixture density algorithm for Gaussian distributions
#'   - X: data matrix
#'   - k: number of clusters
#'   - tol: convergence criterion with default 0.0001.

# k <- 3

my_fmd_gauss <- function(X, k, tol=1e-5, itermax=60){
  X <- as.matrix(X)
  p <- ncol(X)  # number of variables
  n <- nrow(X)  # number of observations
  delta   <- 1   # 
  iter    <- 0   # initialize counter
  # ......................................................................
  while(delta > tol && iter <= itermax){
    # initiation
    if(iter == 0){
      km.init <- my.km(X, k)
      mu <- lapply(1:k, function(j) km.init$mu[j,])
      mu_iter <- mu
      nj <- as.numeric(table(km.init$cluster))
      pij <- nj/n
      
      cmat <- lapply(1:k, function(j) 
        f.cov(X[km.init$cluster==j, ], mu[[j]], n, rep(1,n)))
    }
    # E-step: Posterior probabilities Pr(cluster j | x_r)
    # Using the dmvnorm function is faster.

    f <- lapply(1:k, function(j) dmvnorm_mat(X, mu[[j]], cmat[[j]]))
    num <- lapply(1:k, function(j) pij[j] * f[[j]])
    den <- Reduce("+", num)
    pos <- lapply(num, function(x) x/den)
    
    # M-step
    
    nj <- sapply(pos, sum)
    pij <- 1/n * nj
    mu <- lapply(1:k, function(j) 1/nj[j] * colSums(X * pos[[j]]))
    
    cmat <- lapply(1:k, function(j) f.cov(X, mu[[j]], nj[j], pos[[j]]))
    
    # Next iteration
    
    delta <- sum(unlist(lapply(1:k, function(j) (mu[[j]] - mu_iter[[j]])^2)))
    iter <- iter + 1
    mu_iter <- mu
    cat('\niteration =',iter,'delta = ',delta)
  }
  # ......................................................................
  posterior <- do.call(cbind,pos)
  mu <- do.call(cbind,mu)
  cluster <- apply(posterior, 1, which.max)
  return(list(mu=mu, weights=pij, Sigma=cmat, size=table(cluster), 
	      softcluster = posterior, cluster = cluster))
}
# system.time(myfmd <- my_fmd_gauss(X, 3, 1e-4))
# system.time(gmm <- Mclust(X, 3))
# pairs(X, lower.panel = NULL, col = myfmd$cluster)

