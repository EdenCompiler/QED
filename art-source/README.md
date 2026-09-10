# Arte final gerada

- `gerados/`: cinco folhas originais produzidas por `image_gen`, intactas,
  incluindo a caminhada do Mago gerada novamente após a revisão.
- `referencias/`: referência de direção, pesquisa e prompts usados.
- `*.aseprite`: nove projetos nativos organizados por animação.
- `previas/`: GIFs exportados pelo Aseprite para revisão.
- `manifesto.lua`: retângulos de recorte, estados, tempos e pivôs.
- `importar.lua`: preparação dos pixels gerados; não desenha poses.
- `paleta.lua`: seleção da paleta compartilhada das imagens de origem.

Execute `make arte` na raiz para refazer a importação. Isso substitui os
projetos nativos. Para exportar edições feitas nesses projetos, use
`make exportar-arte`. As duas operações usam Aseprite em display virtual.
Detalhes no [guia de arte](../documentacao/ARTE.md).
