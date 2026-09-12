#!/usr/bin/env bash
# Exporta os projetos existentes sem gerar novas imagens ou modificar poses.
set -euo pipefail
raiz_qed="$(cd "$(dirname "$0")/.." && pwd)"
cd "$raiz_qed"
if [[ "${QED_DISPLAY_VIRTUAL:-}" != 1 ]]; then
  exec xvfb-run -a -s '-screen 0 1600x1000x24 -nolisten tcp' \
    env QED_DISPLAY_VIRTUAL=1 bash "$0"
fi
mkdir -p build/arte art-source/previas
while IFS=$'\t' read -r grupo estado intervalo; do
  aseprite --batch --frame-range "$intervalo" "art-source/$grupo.aseprite" \
    --sheet-type horizontal --sheet "assets/$grupo/$estado.png" \
    --data "build/arte/$grupo-$estado.json"
  if [[ "$grupo" == guerreiro || "$grupo" == mago || "$grupo" == slime || "$grupo" == sentinela || "$grupo" == guardiao ]]; then
    aseprite --batch --frame-range "$intervalo" "art-source/$grupo.aseprite" \
      --scale 4 --save-as "art-source/previas/$grupo-$estado.gif"
  fi
done < art-source/exportacoes.tsv

# Mantém a galeria de revisão sincronizada com cada nova exportação.
for animacao in mago-walk mago-cast mago-death guerreiro-attack guerreiro-gather guerreiro-hurt; do
  cp "art-source/previas/$animacao.gif" "art-source/previas/$animacao-corrigido.gif"
done
cp art-source/previas/guerreiro-attack.gif art-source/previas/guerreiro-attack-completo.gif
