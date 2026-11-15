#!/bin/bash
# SessionStart: inyecta el estado del proyecto y la última entrada del devlog al contexto.
cd "$CLAUDE_PROJECT_DIR" || exit 0

echo "Contrato de sesión (ver CLAUDE.md): resume dónde vamos y el siguiente paso antes de trabajar."
echo
echo "===== docs/ESTADO.md ====="
cat docs/ESTADO.md 2>/dev/null || echo "(no existe)"
echo
echo "===== Última entrada de docs/DEVLOG.md ====="
# Las entradas empiezan con "## "; la primera es la más reciente.
awk '/^## /{n++} n==1' docs/DEVLOG.md 2>/dev/null
exit 0
