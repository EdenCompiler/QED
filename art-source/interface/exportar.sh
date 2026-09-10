#!/usr/bin/env bash
set -euo pipefail
raiz_qed="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
xvfb-run -a aseprite --batch --script-param "raiz=$raiz_qed" --script "$raiz_qed/art-source/interface/exportar.lua"
