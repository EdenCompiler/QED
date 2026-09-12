# Interface de QED

A interface acompanha a fantasia arcana do cenário: bronze envelhecido,
ferro escurecido, couro azul e selos conceituais. Os ornamentos delimitam
painéis; fonte e estados continuam sendo desenhados pelo aplicativo.

## Pesquisa aplicada

Fontes primárias consultadas em 10 de setembro de 2026:

| Referência | Aplicação em QED |
|---|---|
| [Xbox Accessibility Guideline 102 — Contraste](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/102) | Fundos escurecidos sob texto, aumento da luminosidade do texto secundário e estados escritos: Liberada, 1 ponto, Requisitos e Sem pontos. |
| [Xbox Accessibility Guideline 112 — Navegação](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/112) | Mesmas abas nas cinco telas; setas acompanham a posição dos cartões; a árvore não retorna à borda oposta. |
| [Xbox Accessibility Guideline 113 — Foco](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/113) | Área selecionada com contorno de dois pixels e moldura própria; estado ativo das abas persistente e realce ao passar o mouse. |
| [Godot — NinePatchRect](https://docs.godotengine.org/en/stable/classes/class_ninepatchrect.html) | Técnica de nove recortes implementada no renderer OpenGL: cantos conservam proporção, bordas e centro acomodam o tamanho do painel. O jogo não depende de Godot. |

Estas são aplicações parciais das referências, não uma declaração de
conformidade com as XAGs. O texto permanece em 16 pixels, sem escala ajustável,
narração ou suporte a controle. A legibilidade foi inspecionada em capturas
reais de 1440×900 e 1280×800; não há auditoria de contraste de todos os pixels.

## Organização e interação

O cabeçalho mantém identidade da classe, estado da simulação, as cinco telas
e o botão de pausa. Mundo destaca a ação, os recursos e o objetivo atual.
Teoremas mantém editor e diagnóstico lado a lado. Ontologia reserva o painel
direito para requisitos, vocabulário, exemplo e compra. Acampamento apresenta
as quatro construções e valida seus custos. Guia usa o mesmo painel de grimório.

As setas procuram cartões no setor da direção solicitada, favorecendo
alinhamento e proximidade. Empates preservam a ordem dos dados. Ao chegar à
borda, a seleção permanece no cartão. Selecionar não gasta pontos: Enter ou o
botão de desbloqueio confirmam a compra pelos requisitos reais do núcleo.

A navegação por mouse usa as mesmas regiões desenhadas. Trocar de tela retira
a entrada de texto do editor; a simulação só pausa quando solicitado.

## Assets e exportação

A geração usou a ferramenta integrada `image_gen`. Os três originais e os
[prompts completos](../art-source/interface/PROMPTS.md) estão preservados.
Aseprite executou em Xvfb, sem abrir janela no desktop.

| Conjunto | Quantidade | Exportação |
|---|---:|---|
| Painel, grimório, bloqueado, liberado, selecionado e botão | 6 | 256×256, nove recortes com bordas de 32 pixels na fonte |
| Selos de conceitos, cadeado e conhecimento | 12 | 96×96, margem transparente de 2 pixels |
| Fundo arcano | 1 | 960×540, opaco |

Os PNGs finais ficam em `assets/interface/`; os projetos `.aseprite` e os
originais, em `art-source/interface/`. O manifesto versionado registra as
dimensões e margens. A interface usa RGBA próprio, separado da paleta indexada
dos sprites do mundo, com filtro nearest no jogo.

As folhas geradas trouxeram quadriculado pintado. O script Aseprite remove o
fundo conectado às bordas de cada célula, mantém o componente principal e
exporta com amostragem nearest. Nenhuma fonte ou texto de botão é rasterizado
pela geração de imagem.

```sh
make arte-interface
make verificar-arte-interface
```

A exportação reutiliza os originais locais, sem chamar novamente serviços de
IA. A verificação é somente leitura: dimensões, alfa, margens e cabeçalho dos
19 projetos Aseprite. O aplicativo também verifica as dimensões ao carregar.

## Capturas reproduzíveis

```sh
sbcl --script ferramentas/capturar-interface.lisp
```

O script avança sessões novas pela simulação real, captura Guerreiro em
combate, Mago com XP suficiente para liberar Condução e as cinco telas.
Os arquivos PPM ficam em `build/capturas/`. A janela permanece oculta e nenhum
save é lido ou gravado. As versões PNG no manual são conversões dessas capturas.
