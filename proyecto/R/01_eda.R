# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Punto 1: análisis exploratorio
# Uso: Rscript proyecto/R/01_eda.R   (desde la raíz del repo)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
source("proyecto/R/00_setup.R")

## ---- eda_lectura ----
# Sin header = TRUE explícito la lectura falla; omitiéndolo, read.table lo
# detecta porque la primera línea tiene un campo menos que las demás.
x_sin <- try(read.table("data/Foxes.txt", header = FALSE), silent = TRUE)
error_sin_header <- conditionMessage(attr(x_sin, "condition"))
dim(X)
head(X)

## ---- eda_resumen ----
# Media (desviación estándar) global y por país
med_de <- function(v) sprintf("%.2f (%.2f)", mean(v), sd(v))
resumen <- data.frame(
  Variable = unname(vars),
  Todos    = sapply(X, med_de),
  B        = sapply(X[pais == "B", ], med_de),
  U        = sapply(X[pais == "U", ], med_de),
  row.names = names(X)
)
resumen

# Prueba t de Welch B contra U (solo para describir, no entra al clustering)
p_pais <- sapply(X, function(v) t.test(v ~ pais)$p.value)
signif(p_pais, 3)

# Varianzas: muestran por qué conviene escalar (cm contra kg)
varianzas <- sapply(X, var)
round(varianzas, 2)
round(cor(X), 2)

## ---- eda_cajas ----
op <- par(mfrow = c(1, 3), mar = c(4, 4.5, 1, 1))
for (v in names(X)) {
  boxplot(X[[v]] ~ pais, col = pal_pais, ylab = vars[v], xlab = "País",
          las = 1, outline = FALSE)
  stripchart(X[[v]] ~ pais, vertical = TRUE, method = "jitter", add = TRUE,
             pch = 16, cex = 0.7, col = "grey25")
}
par(op)

## ---- eda_pairs ----
panel_hist <- function(x, ...) {
  usr <- par("usr"); on.exit(par(usr = usr))
  h <- hist(x, plot = FALSE, breaks = 8)
  par(usr = c(usr[1:2], 0, max(h$counts) * 1.4))
  rect(head(h$breaks, -1), 0, tail(h$breaks, -1), h$counts, col = "grey85")
}
pairs(X, labels = c("F1 altura (cm)", "F2 longitud (cm)", "F3 peso (kg)"),
      col = col_pais, pch = as.character(pais), cex = 0.9,
      diag.panel = panel_hist, gap = 0.4)
