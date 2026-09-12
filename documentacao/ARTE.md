# Pipeline de arte para QED

A direção atual é fantasia séria: armadura de bronze e aço, capa vinho,
mago em tecido índigo com bordado dourado, slime esmeralda e floresta antiga
com ruínas. O usuário substituiu a produção manual por geração de imagem
e escolheu quadros de 64 × 64 para os personagens.

## Fontes e processamento

Os originais estão em `art-source/gerados/`: personagens, elementos, três
cenários, inimigos e objetos da campanha. Foram produzidos pela ferramenta integrada `image_gen`; os prompts
estão em `art-source/referencias/PROMPTS-ASSETS.md`, `PROMPTS-CENARIO.md`
e `PROMPT-CAMINHADA-MAGO.md`, além de `PROMPTS-CAMPANHA.md`.
O estudo de direção anterior permanece como referência, sem ser recortado
para fabricar os sprites finais.

`art-source/manifesto.lua` registra os recortes medidos nas folhas recebidas.
Aseprite executa `importar.lua` para retirar o quadriculado que veio pintado
nas folhas dos personagens, recortar, reduzir sem suavização, alinhar os
pés e converter para cor indexada. A caminhada revisada usa fundo magenta
para extração, e não o quadriculado. O filtro remove componentes de poses
vizinhas e conserva efeitos desconectados à frente, em ataque e conjuração.
O ataque do Guerreiro usa recortes medidos por pose, com exclusões dos
vizinhos e escala uniforme para acomodar o arco inteiro em 64 × 64.
Nos dois quadros de impacto, preserva também fragmentos finos azuis do arco;
a lâmina erguida tem proteção contra a remoção do fundo claro. Essas
exceções ficam registradas no manifesto. Não desenha corpos nem inventa poses.
Os originais permanecem intactos, permitindo revisar o processamento.

A paleta inicial de 24 cores foi ampliada para até 255 cores compartilhadas,
mais transparência, para preservar os materiais da arte gerada. A paleta
efetiva está em `dados/paleta-gerada.sexp`. `paleta.lua` deriva as cores das
fontes por corte mediano ponderado. O jogo valida cores e alfa binário.

## Arquivos e tempos

| Grupo | Animações | Quadro e pivô |
|---|---|---|
| Guerreiro | `idle`, `walk`, `attack`, `gather`, `hurt`, `death`, `jump` | 64 × 64, `(32 60)` |
| Mago | anteriores mais `cast` | 64 × 64, `(32 60)` |
| Slime | `idle`, `attack`, `hurt`, `death` | 64 × 64, `(32 60)` |
| Sentinela | `idle`, `windup`, `attack`, `recovery`, `hurt`, `death` | 64 × 64, `(32 60)` |
| Guardião | `idle`, `windup`, `attack`, `recovery`, `hurt`, `death` | 64 × 64, `(32 60)` |
| Ferro e cristal | `idle` | 32 × 32, `(16 30)` |
| Passagens e construções | `idle` | 64 × 64, pivô inferior central |
| Madeira | `idle` | 16 × 16, `(8 15)` |
| Terreno | `idle`, atlas com grama e solo | 16 × 16, `(0 0)` |
| Magia | `spark`, `lightning` | 32 × 32, `(16 16)` |
| Ícones | `idle`, atlas madeira, vida, mana e XP | 16 × 16, `(0 0)` |
| Água | `idle` | 16 × 16, `(0 0)` |
| Clareira, mina e ruínas | `idle` | 480 × 270, `(0 0)` |

Guerreiro e Mago usam oito quadros por animação, exceto morte, com sete poses
recebidas. Repouso: 100 ms; caminhada, ataque, coleta, salto e conjuração:
75 ms; dano: 50 ms; morte: 125 ms. Slime usa oito quadros por estado: repouso
e morte a 100 ms, ataque a 75 ms e dano a 50 ms. Somente repouso e caminhada
dos personagens repetem. As durações específicas dos outros grupos estão
nos metadados. Sentinela e Guardião usam preparação de 100 ms por quadro,
ataque de 75 ms e recuperação de 150 ms. Há 48 faixas e 276 quadros no total.

## Reproduzir e editar

```sh
make arte
make exportar-arte
make verificar-arte
```

Requisitos de produção: Aseprite com API Lua, Xvfb e `xvfb-run`. A verificação
usa Python/Pillow somente para leitura. Importação e exportação rodam em
display virtual. Referências oficiais: [API de Sprite](https://www.aseprite.org/api/sprite),
[API de Image](https://www.aseprite.org/api/image) e [CLI](https://www.aseprite.org/docs/cli/).

Para editar os projetos nativos, preserve as etiquetas e dimensões. Use
`make exportar-arte` após a edição. `make arte` reconstrói os projetos a partir
dos originais gerados e substitui alterações locais nos projetos nativos.
Ao mudar quantidade ou duração dos quadros, atualize o manifesto, a tabela
de exportação e a especificação do carregador.

Cada faixa horizontal tem um `.sexp` ao lado, sem trimming, rotação ou
padding. Exemplo:

```lisp
(:versao 1 :arquivo "idle.png" :quadro (64 64) :quadros 8
 :duracao-ms 100 :repetir 1 :pivo (32 60))
```

`F5` recarrega os exports. `F4` permite inspecionar a arte em vista ampliada.
Os GIFs de revisão em `art-source/previas/` repetem para facilitar a inspeção;
isso não altera a semântica das animações no jogo. Conferir o movimento no
renderer continua necessário: coerência entre poses geradas não é garantida
apenas pela contagem de quadros ou pela validação técnica.
