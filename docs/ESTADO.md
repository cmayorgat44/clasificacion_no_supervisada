# Estado del proyecto final (zorros)

Leyenda: ⬜ pendiente · 🟨 en progreso · ✅ hecho
Última actualización: 2026-11-15

## Infraestructura
- ✅ Repo git, `CLAUDE.md`, hooks, skills y subagente revisor
- ✅ `proyecto/R/00_setup.R` (lectura de datos, paquetes, semilla, colores U/B)
- ✅ Esqueleto de `proyecto/reporte/reporte_zorros.Rnw` (estilo de la tarea)

## 1. Análisis exploratorio (`R/01_eda.R`)
- ⬜ Responder: ¿por qué hace falta `header = TRUE`?
- ⬜ Resumen numérico de F1–F3 (global y por país)
- ⬜ Histogramas / densidades
- ⬜ Diagramas de dispersión por pares (color U/B)
- ⬜ Cajas y bigotes por país
- ⬜ Decidir si se escalan las variables (→ `DECISIONES.md`)

## 2. Jerárquico + k-medias (`R/02_kmedias.R`)
- ⬜ Dendrogramas con varios enlaces y elección justificada del enlace
- ⬜ Criterios para k (TWSS/codo, silueta, salto en el dendrograma)
- ⬜ k-medias con `nstart = 100`; tamaños, vectores de medias, BSS/TSS
- ⬜ Justificación de k "como investigador" (relación con U/B)

## 3. Mixtura de densidades (`R/03_mixturas.R`)
- ⬜ `Mclust` con el k elegido; modelo elegido y BIC
- ⬜ Vectores de medias, ponderadores π y matrices de covarianza
- ⬜ Comparación con k-medias (tabla cruzada, ARI, incertidumbre)

## 4. Escalamiento multidimensional (`R/04_mds.R`)
- ⬜ Matriz Δ euclidiana de los datos originales
- ⬜ `cmdscale` con k = 2, gráfica con `pch = rownames(X)`
- ⬜ Proporción de la variación total en 2 dimensiones (eigenvalores)

## Reporte (`reporte/reporte_zorros.Rnw`)
- ⬜ Redacción de las secciones para un experto en zorros con estadística básica
- ⬜ Figuras más relevantes, explicadas en el texto
- ⬜ Máximo 8 páginas sin contar el apéndice; sin código en el cuerpo
- ⬜ Apéndice con todo el código
- ⬜ Revisión con el subagente `revisor-reporte`

## Entrega
- ⬜ PDF final
- ⬜ Envío a jacob.cancino@anahuac.mx (fecha por confirmar)

## Bloqueos / dudas para el profe
- La fecha de entrega aún no se define.
