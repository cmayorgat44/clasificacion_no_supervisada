# MAT5519 Clasificación no Supervisada — Trabajo Final (zorros)

Repo de trabajo en equipo del curso MAT5519 (Anáhuac, sep–dic 2026). Lo inició Carlos Guillermo
Mayorga Tapia (ID 00294506) y lo continúan sus compañeros de equipo. Cada persona trabaja con su
propio agente; este archivo y `docs/` son la memoria compartida entre sesiones y entre personas.

El trabajo activo es el **proyecto final** (`proyecto/pr_CA.pdf`): análisis de clusters de
`data/Foxes.txt` (35 zorros rojos machos: 20 `B.*`, 15 `U.*`; variables F1 altura, F2 longitud, F3 peso).
**Está resuelto y el reporte está listo para revisión final**; ver `docs/ESTADO.md`.

`tarea/` es una tarea individual ya entregada: no se modifica.

## Al empezar una sesión (obligatorio)

1. Lee `docs/ESTADO.md` (qué está hecho y qué falta) y la entrada más reciente de `docs/DEVLOG.md`.
   En Claude Code el hook `SessionStart` los inyecta solo; con otros agentes, léelos tú.
2. Lee `docs/DECISIONES.md` antes de proponer cambios de método: ahí está el porqué de cada elección.
3. Haz `git pull` antes de trabajar: otra persona del equipo pudo avanzar.
4. Resume en 2–3 líneas dónde vamos y cuál es el siguiente paso, y pregunta a la persona con quien
   trabajas qué quiere hacer hoy.

## Reglas del proyecto

- **Lenguaje: R** (análisis y reporte). Nada de Python en el proyecto.
- **Idioma:** español en el reporte, comentarios, devlog y conversación.
- **Reporte:** `proyecto/reporte/reporte_zorros.Rnw` (knitr + LaTeX), con el mismo estilo que
  `tarea/Ejercicios_CA_Mayorga.Rnw`. Máximo 8 páginas carta, 11 pt, **sin código ni salida de consola
  en el cuerpo**; apéndice con todo el código y sus resultados. **El cuerpo ya ocupa 8 páginas**:
  cualquier texto que se agregue obliga a recortar en otro lado.
- **Fuente única del código:** los scripts de `proyecto/R/`. El reporte los carga con
  `knitr::read_chunk()` (chunks marcados con `## ---- etiqueta ----`) y el apéndice los reimprime
  con `ref.label`. No dupliques código de análisis dentro del `.Rnw` ni renombres etiquetas sin
  actualizar el reporte.
- **Ningún número escrito a mano en el reporte:** usa `\Sexpr{}` con objetos de los scripts. Antes de
  afirmar algo nuevo sobre los datos, verifícalo corriendo R.
- Los scripts se corren **desde la raíz del repo** (`Rscript proyecto/R/01_eda.R`). `00_setup.R` es la
  base, y `03_mixturas.R` y `04_mds.R` hacen `source()` de `02_kmedias.R`.
- Reproducibilidad: semilla 5519; `kmeans(..., nstart = 100)`.
- Las etiquetas de país (U/B) **no se usan para ajustar** los clusters; solo para interpretar y graficar.
- `rcode/` tiene funciones del profesor (`my_kmeans.R`, `fmd_EM.R`): se pueden usar, no se modifican.
- Detalle de qué pide cada punto: skill `analisis-zorros` (`.claude/skills/analisis-zorros/SKILL.md`).
- Compilar y verificar el PDF: skill `compilar-reporte`.

## Contrato de sesión

Archivos de seguimiento en `docs/`:
- `ESTADO.md`: checklist de qué está hecho y qué falta. ⬜ pendiente · 🟨 en progreso · ✅ hecho.
- `DEVLOG.md`: una entrada por sesión, la más reciente arriba, **con autor**.
- `DECISIONES.md`: decisiones de método con su porqué. Las más recientes abajo.

1. **Durante:** toda decisión de método va a `DECISIONES.md` en cuanto se toma. No re-discutas
   decisiones ya registradas salvo que la persona lo pida explícitamente; si alguien cambia una,
   agrega una línea nueva que diga qué reemplaza y por qué (no borres la anterior).
2. **Al terminar un turno con cambios en `proyecto/`:** el hook `Stop` exige que `DEVLOG.md` esté
   actualizado. Con otros agentes, hazlo a mano.
3. **Al cerrar** (`/cierre`, o a mano siguiendo `.claude/skills/cierre/SKILL.md`): entrada completa del
   devlog, `ESTADO.md` al día y un mensaje de commit **propuesto**. El agente no hace commit ni push
   sin que la persona lo confirme.

## Git y equipo

- Remoto: `github.com/cmayorgat44/clasificacion_no_supervisada` (rama única `main`).
- Cada persona usa **su propia identidad de git** (`git config user.name` / `user.email`). El agente
  no la inventa: si falta, pregunta.
- `git pull` al empezar y push al cerrar, para no pisar el trabajo de otros. Si hay conflicto en
  `docs/DEVLOG.md`, conserva ambas entradas en orden cronológico (la más reciente arriba).
- No se versionan los auxiliares de LaTeX ni el `.tex` generado; el PDF del reporte sí.

## Herramientas que usan los hooks

Requieren `jq`, `git` y `Rscript` en el PATH. Los hooks están en `.claude/hooks/`:
`inicio_sesion.sh` (contexto al iniciar), `validar_r.sh` (sintaxis de R al editar `.R`/`.Rnw`) y
`exigir_devlog.sh` (devlog al día).
