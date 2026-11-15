# Instrucciones para agentes de código

Este repo usa **`CLAUDE.md` como fuente única de reglas** para cualquier agente (Claude Code, Codex,
Cursor, Copilot, etc.). Léelo completo antes de hacer cualquier cosa.

Si tu agente **no es Claude Code**, los hooks y las skills de `.claude/` no se ejecutan solos.
Haz a mano lo que hacen:

| En Claude Code (automático) | Con otro agente (manual) |
|---|---|
| Hook `SessionStart` muestra `docs/ESTADO.md` y el último `docs/DEVLOG.md` | Léelos al empezar, junto con `docs/DECISIONES.md` |
| Hook `PostToolUse` valida la sintaxis de R | Corre el script editado: `Rscript proyecto/R/<script>.R` |
| Hook `Stop` exige actualizar el devlog | Actualiza `docs/DEVLOG.md` antes de terminar |
| Skill `/cierre` | Sigue `.claude/skills/cierre/SKILL.md` |
| Skill `compilar-reporte` | Sigue `.claude/skills/compilar-reporte/SKILL.md` |
| Skill `analisis-zorros` | Lee `.claude/skills/analisis-zorros/SKILL.md` antes de tocar el análisis |
| Subagente `revisor-reporte` | Usa `.claude/agents/revisor-reporte.md` como prompt de revisión |
