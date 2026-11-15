# MAT5519 Clasificación no Supervisada — Trabajo Final (zorros)

Repo del curso de Carlos Guillermo Mayorga Tapia (ID 00294506), Anáhuac, sep–dic 2026.
El trabajo activo es el **proyecto final** (`proyecto/pr_CA.pdf`): análisis de clusters de
`data/Foxes.txt` (35 zorros rojos machos: 20 `B.*`, 15 `U.*`; variables F1 altura, F2 longitud, F3 peso).

`tarea/` es una tarea ya entregada: no se modifica.

## Reglas del proyecto

- **Lenguaje: R** (análisis y reporte). Nada de Python.
- **Idioma:** español en el reporte, comentarios, devlog y conversación.
- **Reporte:** `.Rnw` (knitr + LaTeX) con el mismo estilo que `tarea/Ejercicios_CA_Mayorga.Rnw`.
  Máximo 8 páginas carta, 11 pt, **sin código ni salida de consola en el cuerpo**; apéndice con todo el código.
- **Fuente única del código:** los scripts de `proyecto/R/`. El reporte los carga con
  `knitr::read_chunk()` (chunks marcados con `## ---- etiqueta ----`) y el apéndice los reimprime.
  No duplicar código dentro del `.Rnw`.
- Los scripts se corren **desde la raíz del repo** (`Rscript proyecto/R/01_eda.R`) y empiezan con
  `source("proyecto/R/00_setup.R")`.
- Reproducibilidad: `set.seed()` antes de cualquier cosa aleatoria; `kmeans(..., nstart = 100)`.
- Se pueden reutilizar funciones de `rcode/` (`my_kmeans.R`, `fmd_EM.R`), que son del profesor.
- Las etiquetas de país (U/B) **no se usan para ajustar** los clusters; solo para interpretar y graficar.
- Detalle de qué pide cada punto: skill `analisis-zorros`.

## Contrato de sesión

Archivos de seguimiento en `docs/`:
- `ESTADO.md`: checklist de qué está hecho y qué falta. ⬜ pendiente · 🟨 en progreso · ✅ hecho.
- `DEVLOG.md`: una entrada por sesión, la más reciente arriba.
- `DECISIONES.md`: decisiones de método con su porqué.

1. **Al iniciar:** el hook `SessionStart` inyecta `ESTADO.md` y la última entrada del devlog.
   Resume en 2–3 líneas dónde vamos y cuál es el siguiente paso antes de trabajar.
2. **Durante:** toda decisión de método (escalar o no, enlace, k, modelo de Mclust…) va a
   `DECISIONES.md` en cuanto se toma. No re-discutir decisiones ya registradas salvo que Carlos lo pida.
3. **Al terminar un turno con cambios en `proyecto/`:** el hook `Stop` exige que `DEVLOG.md`
   quede actualizado (crear o ampliar la entrada de la sesión de hoy).
4. **Al cerrar** (`/cierre`): entrada completa del devlog, `ESTADO.md` al día y un mensaje de commit
   **propuesto**. Claude no hace commit ni push sin que Carlos lo confirme.
