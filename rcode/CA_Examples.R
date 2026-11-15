# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Examples of Cluster Analysis
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Preamble
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

funwd <- "C:/"
outwd <- "C:/"
datwd <- "C:/"
km.wd <- "C:/"
setwd(outwd); getwd()

library(MASS) 
library(matrixcalc)
library(ellipse)
library(Cairo)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Hierarchical Cluster Analysis
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Ejemplo 3.2 hca_USArrests -----------------------------------------------

data(USArrests)
head(USArrests,10)

D <- dist(USArrests, method="euclidean", diag=T, upper=F, p=2); D

xs <- hclust(D, "single")
xa <- hclust(D, "average")
xc <- hclust(D, "complete")
xl <- list(xs,xa,xc)

class(xs)
names(xs)
str(xs)

xs$height
xs$labels
xs$order


#' Make a list of tittles for the plots and choose two points to 
#' cut the tree to analyze the number of clusters at those points.
#' 
#' Plot the dendrogram for each linkage. 
#' Note: The fraction of the plot height by which labels should
#' hang below the rest of the plot. A negative value will cause
#' the labels to hang down from 0.

ml <- c("Single","Average","Complete")
hl <- list("", c(100,60), c(200,80))

par(mfrow=c(1,3), las=1)
lapply(1:length(xl), function(x){
  plot(xl[[x]], hang=-1, main=ml[x], labels=F, sub="", xlab="")
  points(rep(0, length(xl[[x]][[2]])), xl[[x]][[2]], pch=3, 
         col=seq(xl[[x]][[2]]))
  abline(h=hl[[x]], lty=2, col=c("red","blue"))
})

xa.4 <- cutree(xa, k=4)
names(xa.4)
xa.4 <- cutree(xa, h=60)
table(xa.4)
xa.4

USArrests$cluster = NULL
tmp <- cutree(xa, k=4)
for(i in 1:4) {
  cat("Cluster", i, "consists of\n")
  print(names(tmp[tmp==i]))
  USArrests[tmp==i,"cluster"] = i
  # cat("\nAverage crime levels in the cluster are\n")
  # print(round(apply(USArrests[tmp==i,],2,mean), 2))
  # cat("\n\n")
}
round(aggregate(cbind(Murder,Assault,UrbanPop,Rape) ~ cluster,
                FUN=mean, data=USArrests),2)

with(USArrests, boxplot(Murder~cluster), main="Murder")
with(USArrests, boxplot(Assault~cluster), main="Assault")
with(USArrests, boxplot(Rape~cluster), main="Rape")

USArrests$cluster = NULL

pairs(USArrests, col=tmp, pch=tmp, cex=1)

v <- var(USArrests)
round(v,2)
sqrt(diag(v))
round(cor(USArrests),2)

with(USArrests, hist(Assault,breaks=seq(min(Assault),
                                        max(Assault)+1, 0.1)))
abline(v=c(135,225,320), lty=2, col="red")
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example 3.3 k-means -----------------------------------------------------

# + my.km() function ------------------------------------------------------

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
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
my.km

data(USArrests)
head(USArrests)

set.seed(4)
a <- my.km(USArrests, 4); a[1:3]
d <- kmeans(USArrests, centers=4, nstart=100)
table(d$cluster)
table(a$cluster,d$cluster)

rbind(a[c("between.ss", "twithin.ss", "total.ss")],
      d[c("betweenss", "tot.withinss", "totss")])

rbind(a$w.ss, d$withinss)

# x <- data.frame(cbind(my.km=a$cluster, km.fromscratch=b$cluster, km=d$cluster))
# table(x[,c(1,2)])
# table(x[,c(1,3)])
# table(x[,c(2,3)])

tmp <- d$cluster
for(i in 1:4) {
  cat("Cluster", i, "consists of\n")
  print(names(tmp[tmp==i]))
  # USArrests[tmp==i,"cluster"] = i
  cat("Average crime levels in the cluster are\n")
  print(round(apply(USArrests[tmp==i,],2,mean), 2))
  cat("\n")
}

z <- data.frame(state=rownames(USArrests), cluster=a$cluster)
for(i in 1:4) {
  cat("Cluster", i, "consists of\n")
  print(z[z$cluster==i,'state'])
  # USArrests[a$cluster==i,"cluster"] = i
  cat("\nAverage crime levels in the cluster are\n")
  print(round(a$mu[i,], 2))
  cat("\n")
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
setwd(datwd); getwd()
y <- read.table("sim_kmeans_sep.txt", header=TRUE, sep="\t")
head(y)

# Plot the original data

plot(y[,1],y[,2],cex=1, xlab="y1", ylab="y2", 
     col=y[,3], las=1, pch=19)

# Separate the true labels from the continuous variables
X <- y[,-3]
u <- y[,3]

# Do kmeans clustering with each function: my.km and kmeans
set.seed(6)
a <- my.km(X,3)
d <- kmeans(X, 3, nstart=101)

#' Compare the clusters' size:
table(my.km=a$cluster, kmeans=d$cluster)

#' Compare clusters vs true labels
table(u, my.km=a$cluster)

#' Compare the between, total within-cluster and 
#' total sum of squares.
com <- 
  rbind(my.km=a[c("between.ss", "twithin.ss", "total.ss")],
        kmeans=d[c("betweenss", "tot.withinss", "totss")])
com

#' Compare the within-cluster sum of squares.
rbind(my.km=a$w.ss, kmeans=d$withinss)

#' Plot the clusters
plot(X, col=a$cluster+1, pch=19, xlab=bquote(y[1]), 
     ylab=bquote(y[2]), las=1)
points(a$mu[,1], a$mu[,2], pch=19)
plot(X, col=d$cluster+1, pch=19, xlab=bquote(y[1]), 
     ylab=bquote(y[2]), las=1)
points(d$centers[,1], d$centers[,2], pch=19)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example 3.4 k-means analysis of USA crime rates -------------------------

my.km

data(USArrests)
head(USArrests)

set.seed(4)
a <- my.km(USArrests, 4); a[1:3]
d <- kmeans(USArrests, centers=4, nstart=100)

tmp <- d$cluster
for(i in 1:4) {
  cat("Cluster", i, "consists of\n")
  print(names(tmp[tmp==i]))
  # USArrests[tmp==i,"cluster"] = i
  cat("Average crime levels in the cluster are\n")
  print(round(apply(USArrests[tmp==i,],2,mean), 2))
  cat("\n")
}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example 3.5 Optimal number of clusters ----------------------------------

#' Create a vectorized function to extract the TWSS from the 
#' kmeans function
f.twss <- function(X,k){
  twss <- sapply(k, function(k) 
    (kmeans(X, k, nstart=101)$tot.withinss))
  return(cbind(k=k, twss=twss))
}

f.twss_scalar <- function(X,k){
  twss <- kmeans(X, k, nstart=101)$tot.withinss
  return(cbind(k=k, twss=twss))
}

X <- USArrests
f.twss_scalar(X,k=c(2,3))

f.twss(X,k=c(2,3))

#' Extract the TWSS for 1-10 clusters
twss <- f.twss(USArrests, 1:10)

a <- kmeans(X, centers=3, nstart=101)$totss
names(a)
kmeans(X, centers=3, nstart=101)$totss
kmeans(X, centers=4, nstart=101)$totss
kmeans(X, centers=5, nstart=101)$totss

#' Plot the results
plot(twss, las=1, type="b", col=4, bty="l", xaxt="n", lty=1, 
     pch=19, xlab="Number of clusters k",  ylab="")
axis(1, at=as.numeric(twss[,1]), las=1)
mtext("Total Within-cluster Sum of Squares", side=3, line=1, adj=-0.3)
abline(v=3, lty=2)

#' Use factoextra::fviz_nbclust
if(!require(factoextra)) install.packages("factoextra")
library(factoextra)

fviz_nbclust(USArrests, kmeans, method = "wss") +
  geom_vline(xintercept = 3, linetype = 2)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example 3.6 FMD Algorithm -----------------------------------------------

setwd(km.wd)
source("fmd_EM.R")
source("my_kmeans.R")
setwd( datwd )
y <- read.table("sim_kmeans_ovl.txt ", header=TRUE, sep="\t")
setwd(outwd)
head(y)

# Plot the original data
plot (y[,1],y[,2], cex =1, xlab ="y1", ylab ="y2",
      col= y[ ,3] , las =1, pch =19)
# Separate the true labels from the continuous variables
X <- y[,-3]
u <- y[ ,3]

# Fit a finite mixture mode with each function .
library(mclust)
set.seed (4)
a <- my_fmd_gauss(X,3)

d <- Mclust (X, 3, modelNames = c("VVV"))
d

# Compare the clusters ’ size .
x <- data.frame (cbind (my.fmd=a$cluster, Mclust =d$ classification ))
table (x)

# Compare clusters vs true labels
table (u, my.fmd =a$ cluster )

table (u, Mclust =d$ classification )

# Plot the clusters .
plot (X, col = a$ cluster, pch =19, xlab = bquote (y[1]),
      ylab = bquote(y[2]), las =1)
points (a$mu[1 ,], a$mu[2 ,], pch =19)
plot (X, col=d$classification, pch =19 , xlab = bquote (y[1]),
      ylab = bquote(y[2]), las=1)
points (d$parameters$mean[1 ,], d$parameters$mean[2,], pch =19)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Finite mixture density classification -----------------------------------

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
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example 3.7 FMD of USArrests --------------------------------------------

library(mclust)
data(USArrests)
head(USArrests,10)

mc <- Mclust(USArrests, 3, modelNames=c("VEI"))
mc

mc$parameters$pro

mc$parameters$mean

mc$parameters$variance$sigma

tmp <- mc$classification
names(tmp)

for(i in 1:3) {
  cat("Cluster", i, "consists of\n")
  print(names(tmp[tmp==i]))
  USArrests[tmp==i,"cluster"] = i
  # cat("\nAverage crime levels in the cluster are\n")
  # print(round(apply(USArrests[tmp==i,],2,mean), 2))
  # cat("\n\n")
}

# Comparing clusterings

USArrests <- USArrests[-5]

hc.a <- hclust(dist(USArrests), "average")
hcc <- cutree(hc.a, k=4)
mcc <- mc$classification
table(hcc, mcc)

uprplt <- function(x,y) {points(x, y, col=hcc, pch=hcc)}
lwrplt <- function(x,y) {points(x, y, col=mcc, pch=mcc)}

pairs(USArrests, lower.panel=lwrplt, upper.panel=uprplt)
head(USArrests)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example 4.2 Morse code data ---------------------------------------------

#' Data stored as a symmetric matrix of squared 
#' dissimilarities, "Delta"

setwd(datwd)
Delta <- as.matrix(read.table("morse-dist.txt"))
Delta
cbind(c(1:9,0), rownames(Delta))

#' Compute matrices H, A and B

n <- ncol(Delta)
H <- diag(n) - rep(1/n, n, n)
A <- -0.5*Delta; A
B <- H %*% A %*% H; B

#' Do a spectral decomposition of B

eB <- eigen(B)
evals <- eB$values; round(evals ,2)
evecs <- eB$vectors; round(evecs,2)

#' Choose a dimension k=2 

sum(evals[1:2]) / sum(abs(evals))

#' Construct a configuration matrix X (n times k)

X <- evecs[,1:2] %*% diag(sqrt(evals[1:2]))
round(X, 4)

plot(X, pch=as.character(c(1:9,0)), asp=1,
     xlab="morse", ylab="morse", las=1)

#' Use the cmdscale() function to compute the classic MDS 
#' solution in 2 dimensions, plot and compare.

morse.mds <- cmdscale(sqrt(Delta), k=2)
round(morse.mds, 4)
str(morse.mds)
plot(morse.mds, pch=as.character(c(1:9,0)), 
     asp=1, xlab="Morse", ylab="Morse", las=1)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example 4.3 Seriation and Horseshoe effect ------------------------------

# Create the vector x with the numbers 1-51
x <- c(1:51)

# Compute the distance matrix D[r,s] = |r-s|
D <- abs(outer(x, x , "-"))

# Compute the square root matrix Delta = sqrt(D[r,s])
Delta <- sqrt(D)

# Display the first 5 rows and 10 columns of D and Delta
D[1:5,1:5]
round(Delta[1:5,1:5],2)

# Carry on the MDS analysis for D and Delta with k=2 components
D.mds <- cmdscale(D,2)
Delta.mds <- cmdscale(Delta,2)

# Display the first lines of the result
head(D.mds)
head(Delta.mds)

plot(D.mds, asp=1, xlab=bquote(D[",1"]), ylab=bquote(D[",2"])) #; title(sub="(a)")
plot(Delta.mds, asp=1, xlab=bquote(Delta[",1"]), ylab=bquote(Delta[",2"])) #; title(sub="(b)")

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example 5.2 Analysis of compositional data of white cells ---------------

datwd <- "D://..."
setwd(datwd); getwd()
wc <- read.table("WhiteCells.txt", sep="\t", header=T)
head(wc)

#' Split the data with respect to the method assigned to: 
#'   (a) m: microscopic method
#'   (b) i: automatic image analysis

X <- list("m"=as.matrix(wc[,1:3]), "i"=as.matrix(wc[,4:6]))

#' Produce the matrix of the vertices of the ternary diagram

A <- cbind(c(1, 0), c(-0.5, sqrt(3)/2), c(-0.5, -sqrt(3)/2))
A

#' Multiply X %*% A so that we can represent X in the plane

U <- lapply(X, function(x) x %*% t(A)) # so U1 and U2 have two columns
lapply(U, head)

#' log transform X before multiplying by A
#' V1 and V2 are ternary representations of the additive centered
#' logistic transform of data -- why?

V <- lapply(X, function(x) log(x) %*% t(A)) # so U1 and U2 have two columns
lapply(V, head)

Udif <- do.call("-", U) # U[[1]]-U[[2]]
Vdif <- do.call("-", V) # V[[1]]-V[[2]]

#' Plot the data

#' Vertices of the single triangle
Xtri <- matrix(c(1,0,0,0,1,0,0,0,1,1,0,0),4,3,byrow=TRUE)
#' Vertices of the simplex
Utri <- Xtri%*%t(A)

#' Plot original data
plot(Utri, type="l", asp=1, las=1)
points(U[[1]], col="skyblue", pch=19, lwd=1)
points(U[[2]], col="red", pch=17, lwd=1)
segments(U[[1]][,1],U[[1]][,2], U[[2]][,1],U[[2]][,2])

#' Plot the log transformed data
plot(do.call(rbind, V), type="n", asp=1, las=1)
points(V[[1]], col="skyblue", pch=19, lwd=1)
points(V[[2]], col="red", pch=17, lwd=1)
segments(V[[1]][,1],V[[1]][,2],V[[2]][,1],V[[2]][,2])

#' Compute the mean vectors and covariance matrices of Udiff and Vdiff

mU <- apply(Udif,2,"mean")
SU <- var(Udif)
mV <- apply(Vdif,2,"mean")
SV <- var(Vdif)

#' Compute the Hotelling's T^2 statistic for U and V

T2U <- 30*t(mU) %*% solve(SU,mU)
T2V <- 30*t(mV) %*% solve(SV,mV)

T2 <- c('original data'=T2U, 'calt data'=T2V)
T2

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
