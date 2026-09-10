# QED

QED implementa o núcleo e o editor de um RPG incremental lateral em que o
autômato só age depois que uma regra ou prova justifica sua ação. O Guerreiro
usa regras de produção; o Mago usa unificação e resolução SLD.

O núcleo, o editor e os assets estão integrados. A arte atual foi produzida
com geração de imagem, por solicitação do usuário, e preparada no Aseprite
em display virtual. A direção visual é fantasia séria, com personagens em
64 × 64. Veja os [originais e o processo](art-source/README.md).

Todo o código, as mensagens e a documentação do projeto estão em português
brasileiro. A forma canônica da DSL permanece em inglês para garantir uma
representação interna única, mas o editor aceita português, inglês e misturas
dos dois idiomas.

## Executar

Requisitos já usados pelo projeto:

- SBCL e Quicklisp;
- LWLGL 2.2 disponível pelo ASDF;
- `cl-freetype2`, FiveAM e as bibliotecas nativas GLFW, OpenGL e FreeType;
- um driver OpenGL 3.3.

Na raiz do projeto:

```sh
make executar
```

Para compilar e testar o executável local:

```sh
make compilar
./build/qed
```

O executável contém o runtime SBCL e os sistemas compilados. Ele usa os assets
desta pasta e as bibliotecas nativas instaladas nesta máquina. Para testar
sem ler nem gravar sua partida, use `./build/qed --sem-salvar`.

O launcher localiza o Quicklisp em `~/quicklisp/setup.lisp`. Para outra
instalação, informe o arquivo com `QED_QUICKLISP`. Para usar outra fonte
monoespaçada, informe um TTF com `QED_FONTE`.

Controles:

| Tecla | Ação |
|---|---|
| `Ctrl+Enter` | valida e aplica a biblioteca exibida |
| `Ctrl+S` | salva progresso, biblioteca ativa e rascunhos |
| `Ctrl+Z` / `Ctrl+Y` | desfaz/refaz a edição |
| `F1` | alterna entre Guerreiro e Mago |
| `F2` | pausa/retoma a simulação |
| `F3` | alterna diagnóstico em português, inglês e automático |
| `F4` | alterna entre editor e vista ampliada do mundo |
| `F5` | recarrega e valida os assets exportados |
| `F6` | abre a árvore de ontologia; clique nas áreas ou use as setas |
| `Enter` na árvore | gasta um ponto e libera a área selecionada, se os requisitos forem atendidos |
| `F7` na árvore ou no guia | copia o exemplo para colar no editor |
| `F8` | abre o guia de jogo |
| Roda do mouse no diagnóstico | percorre premissas e árvore de prova |
| `Esc` | salva e fecha |

Os 26 pares de PNG e metadados estão em `assets/`. Os personagens têm dois
pixels de arte por unidade do mapa: em `F4`, com janela de pelo menos
960 × 668, a vista mostra os pixels dos sprites na resolução nativa. A prévia
menor ao lado do editor reduz os personagens. A física conserva a escala do mapa.

Aos 30, 60 e 100 XP, cada personagem recebe um ponto de conhecimento. As
escolhas na árvore liberam vocabulário real para os avaliadores: Estados,
Impacto e Composição para Guerreiro; Condução, Tempestade e Composição para
Mago. Tempestade exige Condução; Composição libera o quinto slot. Escolhas e
saldo são separados por personagem e persistem ao fechar. Partidas anteriores
são migradas preservando o vocabulário já disponível.

## Desenvolvimento

```sh
make testar
make simular
make verificar-interface
make ensaio-30-minutos
make arte
make exportar-arte
make verificar-arte
```

`make testar` executa os avaliadores sem abrir uma janela. `make simular`
avança os dois personagens por 30 minutos simulados. `make
verificar-interface` abre uma janela oculta, testa edição Unicode, alternância,
redimensionamento e gera `build/interface.ppm` para inspeção visual.
`make ensaio-30-minutos` mantém a aplicação em execução por 30 minutos reais,
com edição, pausa, alternância e janela oculta, sem gravar o progresso pessoal.
Os resultados e os limites da verificação estão no
[registro de validação](documentacao/VALIDACAO.md).

`make arte` importa as imagens já geradas, sem chamar serviços de IA, e recria
os projetos e exports. `make exportar-arte` exporta os projetos Aseprite
existentes e produz GIFs de revisão. Ambos usam Xvfb; nenhuma janela Aseprite
aparece no desktop. `make verificar-arte` requer Python e Pillow.

O projeto está dividido em sistemas ASDF independentes:

- `qed/core`: mundo, entidades, física, progressão e executor de intenções;
- `qed/logic`: leitura segura, normalização bilíngue e avaliadores;
- `qed/app`: editor, fonte, renderização LWLGL e integração dos assets;
- `qed/tests`: testes sem dependência gráfica.

Leia [a especificação da DSL](documentacao/DSL.md), [o pipeline de
arte](documentacao/ARTE.md) e [as decisões técnicas](documentacao/ARQUITETURA.md)
antes de estender a fatia.
