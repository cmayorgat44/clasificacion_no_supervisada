# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# k-means algorithm -------------------------------------------------------
#
# JCR: This file comes from "Dropbox/.../MyRfuns/f.kmeans.R"
# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' #' The iris data is included in the R datasets package.
#' 
#' X     <- iris[,1:4]
#' y     <- iris[,5]
#' y_col <- c('red','green','blue')
#' 
#' 
#' pairs(X, lower.panel = NULL, col = y_col[y])
#' par(xpd = T)
#' legend(x = 0.1, y = 0.4, legend = as.character(levels(y)), fill = y_col)

#' My k-means algorithm
#'   - X: data matrix
#'   - k: number of clusters
#'   - tol: convergence criterion with default 0.0001.

#' Define a function for the sum of squares
ss <- function(x) sum(scale(x, scale = FALSE)^2)

my.km <- function(X, k, tol=1e-5){
  X <- as.matrix(X)
  p <- ncol(X)  # number of variables
  n <- nrow(X)  # number of observations
  delta   <- 1   # to be compared against tol
  iter    <- 0   # initialize counter
  itermax <- 30  # maximum number of iterations
  cmat <- NULL
  X.hat <- X
  between.ss <- twithin.ss <- within.ss <- NULL
  # ............................................................
  # Total sum of squares is sum((x[r]-mu_total)^2)
  total.ss   <- ss(X)
   
  while(delta > tol && iter <= itermax){
    # initiation
    if(iter == 0){
      #' Initial mean vector is a random sample of k rows of X.
      #' For now no cluster assignment is necessary.
      mu <- lapply(sample(n, k), function(j) as.numeric(X[j,]))
      mu_iter <- mu  # Estimate of previous iteration
      twithin.ss <- ss(X) # Initialize as the total sum of squares
    }
    
    # Update clustering assignment (equivalent to E-step)
    d <- sapply(1:k, function(j)
      sapply(1:n, function(r)  sum((X[r,]-mu[[j]])^2)))
    
    cluster <- apply(d, 1, which.min)
    nj <-table(cluster)
    
    # Update the mean vectors (equivalent to M-step)
    mu <- lapply(1:k, function(j)  apply(X[cluster==j,], 2, mean))
    
    # Fitted x is the mean vector of the assigned cluster.
    for(r in 1:n){ X.hat[r,] <- mu[[cluster[r]]] }
    
    # Residuals
    resid.X <- X - X.hat
    
    between.ss <- c(between.ss, ss(X.hat))
    w.ss       <- sapply(1:k, function(j) ss(resid.X[cluster==j,])) 
    twithin.ss <- c(twithin.ss, ss(resid.X)) ## Same as sum(w.ss)
    # w.ss <- sapply(1:k, function(j) sum((X[cluster==j,]-X.hat[cluster==j,])^2))
    # w.ss <- sapply(1:k, function(j) ss(X[cluster==j,]-X.hat[cluster==j,]))
    # w.ss <- sapply(1:k, function(j) sum(resid.X[cluster==j,]^2))
    # w.ss       <- sapply(1:k, function(j)          
    #   sum((scale(resid.X[cluster==j,], scale=FALSE)^2)))
    
    cmat <- cbind(cmat, cluster)
    
    iter <- iter + 1
    mu_iter <- mu
    delta <- -1*diff(twithin.ss)[iter]
  }
  
  total.ss   <- ss(X)
  
  cmat <- as.data.frame(cmat)
  names(cmat) <- paste0("iter_", 1:iter)
  
  return(list(mu=do.call(rbind,mu), size=nj, cluster=cluster, 
              iter=iter, delta=delta, clustmat=cmat,
              total.ss=total.ss, between.ss=tail(between.ss,1), 
              w.ss=w.ss, twithin.ss=tail(twithin.ss,1)))
}


#' run K-means
#' 
#' Uncomment the following lines to check my.km function

#' a <- my.km(X,3); a[1:3]
#' d <- kmeans(X, 3, nstart=101)
#' 
#' x <- ncol(a$clustmat)
#' a$clustmat[,x]==a$clustmat[,(x-1)]
#' 
#' all(a$clustmat[,x]==a$clustmat[,x-1])
#' 
#' #' Compare the three methods:
#' 
#' table(y,a$cluster)
#' table(y,d$cluster)
#' 
#' rbind(a[c("between.ss", "twithin.ss", "total.ss")],
#'       d[c("betweenss", "tot.withinss", "totss")])
#' 
#' rbind(a$w.ss, d$withinss)
#' 
#' pairs(X, lower.panel = NULL, col = a$cluster)
#' pairs(X, lower.panel = NULL, col = d$cluster)
