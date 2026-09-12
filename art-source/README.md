# Arte final gerada

Os projetos da campanha incluem `sentinela.aseprite`, `guardiao.aseprite`,
`mina.aseprite`, `ruinas.aseprite`, recursos, passagens e as quatro construções.
As referências originais geradas e os prompts estão em `gerados/` e
`referencias/PROMPTS-CAMPANHA.md`.

- `gerados/`: folhas originais produzidas por `image_gen`, intactas, incluindo
  a campanha e a caminhada do Mago gerada novamente após a revisão.
- `referencias/`: referência de direção, pesquisa e prompts usados.
- `*.aseprite`: projetos nativos organizados por personagem, cenário e objeto.
- `previas/`: GIFs exportados pelo Aseprite para revisão.
- `manifesto.lua`: retângulos de recorte, estados, tempos e pivôs.
- `importar.lua`: preparação dos pixels gerados; não desenha poses.
- `paleta.lua`: seleção da paleta compartilhada das imagens de origem.

Execute `make arte` na raiz para refazer a importação. Isso substitui os
projetos nativos. Para exportar edições feitas nesses projetos, use
`make exportar-arte`. As duas operações usam Aseprite em display virtual.
Detalhes no [guia de arte](../documentacao/ARTE.md).

## Interface

Painéis e selos foram gerados com `image_gen` e preparados no Aseprite em
display virtual. Os [prompts e originais](interface/PROMPTS.md), os projetos
`.aseprite` e o script de exportação estão em `interface/`. Veja as
[referências e decisões de UI](../documentacao/UI.md).
