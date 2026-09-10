# Registro de validação — 8 de setembro de 2026

## Núcleo e lógica

`sbcl --script iniciar.lisp --testes`: 108 verificações aprovadas, nenhuma
falha ou teste ignorado. A suíte FiveAM carrega somente `qed/logic` e
`qed/core`; não abre janela nem carrega dependências gráficas.

Os casos cobrem prioridade, desempate, idioma, escopo, fontes inspecionáveis,
leitura restrita, recursão proibida, dependências compartilhadas, unificação,
retrocesso, limites de busca, fatos falsos, efeitos incompatíveis, mana,
condução, desbloqueios, lemas reutilizados, determinismo, alternância, física,
interrupções, remoção de alvo, morte, persistência e recuperação de backup.

`sbcl --script iniciar.lisp --simular 1800` completou 108.000 ticks para cada
classe na versão atual:

| Personagem | XP | Madeira |
|---|---:|---:|
| Guerreiro | 2.152 | 306 |
| Mago | 494 | 47 |

## Aplicativo

O ensaio curto abriu uma janela OpenGL, montou o atlas FreeType, verificou
seleção Unicode, desfazer/refazer, clipboard com acentos, traduções do
diagnóstico e preservação de variáveis. Executou alternância de personagem,
redimensionamento para 1280 × 800 e ocultação da janela. A captura
`build/interface-final.png` foi inspecionada visualmente.

Duas execuções do launcher com `XDG_DATA_HOME` apontando para uma pasta
temporária confirmaram gravação ao fechar, criação de backup e continuidade
do tick ao reabrir, sem avançar o personagem inativo.

A compilação de `qed/app` passou. O ASDF emite um aviso da dependência
`cl-freetype2` sobre o nome do sistema auxiliar `cl-freetype2-doc`; a fonte,
os acentos e o renderer funcionaram neste ambiente.

## Ensaio prolongado

O comando abaixo completou 79.752 quadros em 1.800,14 segundos reais:

```sh
sbcl --script iniciar.lisp --sem-salvar --oculta --duracao 1800 \
  --ensaio-real --captura build/ensaio-30min.ppm
```

Durante essa sessão, o programa editou e aplicou uma biblioteca, pausou por um
segundo, alternou para o Mago e redimensionou a janela. A janela permaneceu
oculta, verificando continuidade da simulação sem foco. O Guerreiro terminou
com 539 ticks; o Mago, com 107.399. O registro original está em
`build/ensaio-30min.log`.

Essa sessão começou antes das correções finais de aliases, interrupções e
diagnóstico. Depois dessas correções, a suíte, a simulação de 30 minutos por
classe e o ensaio gráfico curto foram executados novamente. O ensaio de 30
minutos reais não foi repetido após elas.

## Arte gerada — 9 de setembro de 2026

Por solicitação do usuário, os assets finais passaram a usar geração de
imagem, personagens em 64 × 64 e paleta compartilhada de 255 cores mais
transparência. Há nove projetos Aseprite, 26 faixas PNG e 170 quadros.

`make verificar-arte` passou: dimensões, alfa binário, cores autorizadas,
durações, cabeçalhos nativos e contagem de quadros. O carregador do jogo
retornou zero assets pendentes. A suíte de lógica continuou com 108/108.

O ensaio gráfico com a arte gerada completou 1.800 quadros em 20,54 segundos
reais, com 1.275 ticks para Guerreiro e 107.950 para Mago. É uma execução
acelerada de aproximadamente 30 minutos simulados, não uma sessão de 30
minutos reais. Captura: `build/arte/mundo-gerado-final.png`.

A revisão visual identificou pixels de poses vizinhas em ataque, coleta,
dano, conjuração e morte, além de pouca alternância de pernas na caminhada
do Mago. A caminhada foi gerada novamente; os recortes passaram a remover
componentes desconectados de poses vizinhas. Os GIFs correspondentes foram
reexportados para inspeção.

A revisão seguinte corrigiu o ataque do Guerreiro: recortes específicos
acomodam o arco fora das colunas regulares, a extração preserva a lâmina
clara e o filtro conserva os fragmentos azuis dos dois quadros de impacto.
A inspeção dos oito quadros confirmou margem transparente em todas as
bordas e o arco presente somente durante o golpe. PNGs e GIFs passaram
novamente na comparação quadro a quadro.

O ensaio de 30 minutos reais descrito acima antecede a arte atual. Ele ainda
não foi repetido com estes assets; a validação técnica não substitui a
aprovação artística dos ciclos gerados.

## Interface, ontologia e executável — 9 de setembro de 2026

A suíte passou em 171 verificações após a progressão por escolhas. Os casos
adicionais cobrem compra atômica, saldo, dependências, vocabulário bloqueado,
escolhas por classe, migração v1 para v2, impacto único e recuperação segura.

`make compilar` gerou `build/qed`, com runtime SBCL e sistemas carregados.
O handle nativo do FreeType é encerrado antes de salvar a imagem e recriado
na inicialização do executável. O binário abriu a árvore e a vista ampliada
em ensaios ocultos, inclusive a partir de `/tmp`, com zero assets pendentes.
O ensaio do editor também passou, com Unicode, clipboard e redimensionamento.
Capturas inspecionadas: `build/ontologia-compilada.png` e
`build/mundo-compilado.png`. A compilação é local e utiliza os assets do
projeto e as bibliotecas nativas instaladas nesta máquina.

A sessão de 30 minutos reais ainda não foi repetida após estas alterações.

## Tema arcano e exemplos em inglês — 10 de setembro de 2026

A interface integra 19 novos PNGs: seis molduras, doze selos e um fundo.
`make verificar-arte-interface` passou para dimensões, transparência binária,
margens e projetos Aseprite. A exportação foi executada em Xvfb, sem janela
visível, a partir dos originais gerados com `image_gen`.

`make testar` permaneceu em 171/171. A comparação das bibliotecas iniciais em
português e inglês confirmou ASTs equivalentes após renomear os exemplos e
estados resumidos idênticos após 5.000 ticks de cada classe. Os teoremas e lemas
publicados na árvore e no guia também foram validados. O exemplo de relâmpago
usa `lightning-strike`, evitando a constante reservada `lightning` como nome.
Os arquivos iniciais agora são `exemplos/warrior.lisp` e `exemplos/wizard.lisp`;
o carregador usa esses nomes. Bibliotecas já salvas pelo jogador são preservadas.

O ensaio `make verificar-interface` passou com navegação espacial, limites da
árvore, detecção de cliques, troca de telas, pausa, Unicode, clipboard e
redimensionamento para 1280×800. As capturas reais das quatro telas em
1440×900 estão em `documentacao/imagens/`. A revisão corrigiu texto cortado,
margens junto aos ornamentos e quebra de palavras no guia.

`make compilar` gerou novamente `build/qed`; o executável iniciou uma sessão
nova em janela oculta com a árvore, sem assets pendentes. Os ensaios usaram
`--sem-salvar`. O README agora apresenta o jogo com capturas e instruções de
primeira experiência; a pesquisa aplicada está em [UI.md](UI.md).

Não foi repetida uma sessão de trinta minutos reais nesta atualização.
