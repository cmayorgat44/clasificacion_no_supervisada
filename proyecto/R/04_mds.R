# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Punto 4: escalamiento multidimensional clásico con k = 2 dimensiones
# Uso: Rscript proyecto/R/04_mds.R   (desde la raíz del repo)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
source("proyecto/R/02_kmedias.R")   # trae X, pais y grupo_km

## ---- mds_ajuste ----
# Distancia euclidiana de los datos originales (sin escalar), como pide el enunciado
Delta <- dist(X, method = "euclidean")
mds <- cmdscale(Delta, k = 2, eig = TRUE)
Xmds <- mds$points
colnames(Xmds) <- c("Dim1", "Dim2")
# El signo de cada dimensión es arbitrario: se orienta para que Dim1 crezca
# con la longitud (F2) y Dim2 con la altura (F1). No cambia las distancias.
signos <- sign(c(cor(Xmds[, 1], X$F2), cor(Xmds[, 2], X$F1)))
Xmds <- sweep(Xmds, 2, signos, "*")

# Eigenvalores y proporción de la variación absoluta total en 2 dimensiones
eig <- mds$eig
round(head(eig, 4), 3)
prop_abs <- sum(abs(eig[1:2])) / sum(abs(eig))
prop_dim <- abs(eig[1:3]) / sum(abs(eig))
round(c(prop_abs = prop_abs, prop_dim), 4)

# Qué variable original describe cada dimensión
cor_mds <- cor(Xmds, X)
round(cor_mds, 3)

## ---- mds_fig ----
plot(Xmds, pch = rownames(X), col = c("grey20", "red3")[grupo_km],
     xlab = bquote(Dim[1]), ylab = bquote(Dim[2]), las = 1, asp = 1)
abline(h = 0, v = 0, lty = 3, col = "grey60")
