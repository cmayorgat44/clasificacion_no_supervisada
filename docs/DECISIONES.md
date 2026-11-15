# Decisiones

Una línea por decisión: fecha, decisión y porqué. Las más recientes abajo.

- 2026-11-15 — Reporte en `.Rnw` con el mismo formato que la tarea. Consistencia con lo ya entregado.
- 2026-11-15 — El ejercicio 3.1 de la tarea (MDS, C positiva semidefinida) queda fuera del alcance de este repo de trabajo.
- 2026-11-15 — El código vive en `proyecto/R/` y el `.Rnw` lo carga con `read_chunk()`. Así el apéndice es exactamente el código que produjo los resultados.
- 2026-11-15 — Las etiquetas U/B no entran a ningún ajuste; solo sirven para interpretar.
- 2026-11-15 — Estandarizar F1–F3 para el dendrograma y k-medias. Las varianzas son 36.8 (F2), 7.8 (F1) y 0.20 (F3, kg); sin escalar, la longitud decide sola y el peso, que sí distingue a los países (p < 0.001), no cuenta.
- 2026-11-15 — Enlace de Ward. El simple encadena (aísla un zorro); el completo y el promedio dan particiones mezcladas o desbalanceadas; Ward usa el mismo criterio que k-medias.
- 2026-11-15 — k = 2. TWSS y silueta no deciden (siluetas de 0.28 a 0.32); k = 3 solo separa a los zorros más altos de ambos países (tamaño individual); k = 2 da un perfil claro (corto y pesado contra largo y ligero), coincide con el país en 32/35 y lo reproduce Mclust.
- 2026-11-15 — Mclust en unidades originales con G = 2 fijo (lo pide el enunciado). Se reporta con honestidad que el BIC libre prefiere G = 1.
- 2026-11-15 — MDS con distancias sin escalar, como pide el enunciado. Los ejes se orientan (signo) para que Dim1 crezca con la longitud y Dim2 con la altura.
- 2026-11-15 — Semilla 5519 para todo lo aleatorio.
