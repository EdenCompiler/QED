# Registro de validação — 12 de setembro de 2026

## Núcleo, lógica e campanha

`make testar` concluiu **247 verificações**, todas aprovadas e nenhuma
ignorada. A suíte FiveAM não abre janela nem carrega o renderer. Ela cobre:

- leitura restrita, limites, aliases em português e inglês e preservação da
  última biblioteca válida;
- prioridade, desempate, lemas, escopo, unificação com occurs-check,
  retrocesso, limites da resolução SLD, custos, fizzle e efeitos autorizados;
- física, salto, interrupção segura, remoção de alvos, morte, alternância de
  personagem e determinismo;
- as sete telas, passagens fechadas, inventário, mineração, construções
  atômicas, requisitos e progressão única da campanha;
- aproximação, preparação e recuperação da Sentinela e do Guardião, mitigação
  do chefe,
  ausência de reaparecimento após a vitória e retorno regional após a morte;
- persistência v3, recuperação por backup e migração das versões v1 e v2;
- conclusão guiada da campanha pelas duas classes usando os avaliadores reais
  de regras e provas.

Uma regressão adicional posiciona o Mago diante de uma madeira sobre plataforma
elevada. O alvo agora herda a altura da superfície ao criar e carregar o mundo;
o Mago prova a coleta, remove o recurso e retoma o deslocamento. Esse caso evita
o ciclo em que o personagem alcançava o mesmo `x`, mas permanecia fora do
alcance por uma coordenada vertical antiga no save.

`make simular` executou 108.000 ticks para cada classe:

| Personagem | XP | Madeira | Posição final |
|---|---:|---:|---:|
| Guerreiro | 670 | 295 | 392,4 |
| Mago | 688 | 294 | 391 |

Entradas e seed iguais continuam produzindo o mesmo estado sem depender da
taxa de renderização.

## Aplicativo e executável

`make verificar-interface` abriu uma janela OpenGL oculta, montou o atlas
FreeType e verificou navegação, limites, cliques, cinco telas, pausa, seleção
Unicode, clipboard, desfazer/refazer e redimensionamento. O ensaio terminou
com zero assets pendentes.

As telas Mundo, Teoremas, Ontologia, Acampamento e Guia foram verificadas em
1280×800 e 1440×900. As capturas versionadas em `documentacao/imagens/`
incluem a Clareira, a Mina, o Observatório e o Acampamento.

`make compilar` gerou `build/qed`. O executável compilado iniciou pela linha de
comando, carregou as dependências nativas e encerrou um ensaio de 120 quadros
com zero assets pendentes. O ASDF ainda exibe o aviso externo do
`cl-freetype2` sobre o nome do sistema auxiliar `cl-freetype2-doc`; a fonte,
os acentos e a renderização funcionam neste ambiente.

## Arte

`make verificar-arte` aprovou **48 faixas e 276 quadros**: dimensões, alfa,
paleta, durações, projetos Aseprite e comparação dos GIFs. A Sentinela e o
Guardião possuem estados distintos de espera, preparação, ataque, recuperação,
dano e morte. Mina, ruínas, minerais, passagens e construções também possuem
projetos editáveis e exports integrados.

`make verificar-arte-interface` aprovou os **19 assets da interface**, incluindo
dimensões, transparência, margens e projetos Aseprite. Todos os projetos foram
preparados e exportados sob Xvfb, sem janela visível. Os originais gerados e os
prompts permanecem em `art-source/`.

## Ensaio prolongado

O ensaio de 30 minutos reais usa:

```sh
make ensaio-30-minutos
```

Ele mantém a janela oculta, deixa a simulação avançar sem foco, edita e aplica
uma biblioteca, alterna os personagens, pausa manualmente e redimensiona a
janela. O log fica em `build/ensaio-campanha-30min.log` e a captura final em
`build/ensaio-30min.ppm`.

A execução final completou **58.549 quadros em 1.800,18 segundos reais**, com
zero assets pendentes. Após a edição, a pausa e a troca programadas, o
Guerreiro terminou com 541 ticks e o Mago com 107.399 ticks. O Mago alcançou
686 XP e 293 madeiras durante a janela oculta, confirmando que a simulação
continuou sem foco. O comando usou `--sem-salvar`, portanto não leu nem alterou
a partida do jogador.
