#!/usr/bin/env bash
# O Aseprite permanece no display virtual durante toda a importação.
set -euo pipefail
raiz_qed="$(cd "$(dirname "$0")/.." && pwd)"
cd "$raiz_qed"
xvfb-run -a -s '-screen 0 1600x1000x24 -nolisten tcp' \
  aseprite --batch --script-param "raiz=$raiz_qed" --script art-source/importar.lua
