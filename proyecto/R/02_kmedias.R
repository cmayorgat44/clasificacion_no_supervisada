# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Punto 2: dendrograma como punto de partida, elección de k y k-medias
# Uso: Rscript proyecto/R/02_kmedias.R   (desde la raíz del repo)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
source("proyecto/R/00_setup.R")

## ---- km_escala ----
# Las variables están en cm y kg con varianzas muy distintas; sin escalar,
# la longitud (F2) decide casi sola las distancias. Se estandarizan.
Xs <- scale(X)

## ---- km_dendros ----
enlaces <- c(Simple = "single", Completo = "complete",
             Promedio = "average", Ward = "ward.D2")
hc <- lapply(enlaces, function(m) hclust(dist(Xs), method = m))
# Las cuatro alturas de fusión más grandes de cada árbol
sapply(hc, function(h) round(rev(tail(h$height, 4)), 2))
# Partición en 2 grupos de cada enlace contra el país
lapply(hc, function(h) table(grupo = cutree(h, 2), pais))

## ---- km_dendros_fig ----
op <- par(mfrow = c(2, 2), mar = c(1, 4, 2, 0.5))
for (nm in names(hc)) {
  # Las hojas muestran el país (B/U) para poder leerlas en el reporte
  plot(hc[[nm]], hang = -1, cex = 0.85, main = nm, xlab = "", sub = "",
       ylab = "Altura", las = 1, labels = as.character(pais))
  if (nm == "Ward") rect.hclust(hc[[nm]], k = 2, border = "grey40")
}
par(op)

## ---- km_criterios ----
# TWSS y silueta promedio de k-medias para k = 1, ..., 6
ks <- 1:6
criterios <- t(sapply(ks, function(k) {
  set.seed(5519)
  fit <- kmeans(Xs, centers = k, nstart = 100)
  sil <- if (k > 1) mean(silhouette(fit$cluster, dist(Xs))[, "sil_width"]) else NA
  c(k = k, TWSS = fit$tot.withinss, BSS_TSS = fit$betweenss / fit$totss,
    silueta = sil)
}))
round(criterios, 3)

## ---- km_criterios_fig ----
op <- par(mfrow = c(1, 2), mar = c(4, 4.5, 1, 1))
plot(criterios[, "k"], criterios[, "TWSS"], type = "b", pch = 16, las = 1,
     xlab = "Número de grupos k", ylab = "TWSS")
plot(criterios[-1, "k"], criterios[-1, "silueta"], type = "b", pch = 16,
     las = 1, xlab = "Número de grupos k", ylab = "Silueta promedio")
par(op)

## ---- km_ajuste ----
set.seed(5519)
km <- kmeans(Xs, centers = 2, nstart = 100)
# Etiquetas estables: grupo 1 = cuerpo más corto, grupo 2 = más largo
grupo_km <- ifelse(km$cluster == which.min(km$centers[, "F2"]), 1, 2)
table(grupo_km)

# Vectores de medias en las unidades originales
medias_km <- sapply(split(X, grupo_km), colMeans)
round(medias_km, 2)
round(c(BSS_TSS = km$betweenss / km$totss), 3)

# La altura difiere poco entre grupos, pero no es igual
p_altura_km <- t.test(X$F1 ~ grupo_km)$p.value
round(p_altura_km, 3)

# Silueta promedio de cada grupo
sil_grupo <- summary(silhouette(km$cluster, dist(Xs)))$clus.avg.widths
round(sil_grupo, 3)

# Comparación con el país (no se usó para ajustar)
tab_km_pais <- table(grupo = grupo_km, pais)
tab_km_pais
mal_km <- rownames(X)[grupo_km != ifelse(pais == "B", 1, 2)]
X[mal_km, ]
# Los tres son más altos que el zorro típico de B
mediana_F1_B <- median(X$F1[pais == "B"])
mediana_F1_B

# Composición de los dos grupos de Ward
tab_ward_pais <- table(ward = cutree(hc$Ward, 2), pais)
tab_ward_pais

# Ward con k = 2 contra k-medias
table(ward = cutree(hc$Ward, 2), kmedias = grupo_km)

## ---- km_k3 ----
# Alternativa k = 3: el grupo extra son los zorros más altos de ambos países
set.seed(5519)
km3 <- kmeans(Xs, centers = 3, nstart = 100)
medias_km3 <- sapply(split(X, km3$cluster), colMeans)
round(medias_km3, 2)
tab_km3_pais <- table(grupo = km3$cluster, pais)
tab_km3_pais
