# Arquitetura da primeira fatia

## Fluxo de um tick

A aplicação acumula tempo de relógio e avança a simulação em passos fixos de
`1/60` segundo. Uma pausa externa maior que dois segundos é descartada; assim,
suspender o computador não concede progresso offline.

Em cada tick, o núcleo:

1. cria uma fotografia do mundo;
2. entrega essa fotografia e a biblioteca ativa ao avaliador da classe;
3. recebe um resultado com diagnóstico e, quando justificada, uma intenção;
4. revalida alvo, caminho, alcance, linha de visão e recursos;
5. executa ou interrompe a intenção;
6. aplica física, inimigos, reaparecimento e progressão.

A fotografia impede que o avaliador altere o mundo. Somente o executor aplica
efeitos. Essa separação permite testar toda a lógica sem GLFW ou OpenGL.

## Mundo e ações

A fase `dados/clareira.sexp` tem 90 × 17 tiles de 16 pixels, ou três telas de
480 × 270. O carregador converte faixas sólidas do tilemap em retângulos AABB.
O movimento consulta uma rota determinística de caminhada e salto; saltos são
passos internos da intenção justificada.

As ações são listas de dados. Uma execução mantém a sequência restante, tempo,
prioridade e custo. Movimento, fuga e espera podem ser interrompidos por uma
intenção de prioridade superior; ataque, coleta e manifestação terminam em um
ponto seguro antes de outra intenção assumir.

Madeira reaparece após seis segundos; slimes, após oito. Madeira concede 2 XP e
um recurso; slime concede 10 XP. Morrer cancela a ação e retorna o autômato ao
início depois de três segundos, preservando XP e inventário.

## Avaliadores

O Guerreiro percorre as definições já ordenadas por prioridade. Em empate,
vence a posição anterior no documento. Ele avalia premissas sobre a mesma
fotografia e transforma a conclusão da primeira regra verdadeira em intenção.

O Mago executa resolução SLD limitada, com unificação, occurs-check,
renomeação de variáveis e aprofundamento iterativo. Cada tick permite no máximo
256 tentativas de resolução, profundidade 16 e 8.192 operações primitivas. Uma
prova mágica custa `8 + 2 × passos` de mana e demora `0,2 + 0,05 × passos`
segundos. Provas utilitárias usam o mesmo mecanismo, mas custam zero mana.

O termo de prova é mantido no resultado. Isso deixa aberta a implementação do
Alquimista, que poderá usar as substituições como testemunha, e do Invocador,
porque as definições continuam como árvores inspecionáveis.

## Persistência

O arquivo versionado (v2, com migração da v1) fica em `$XDG_DATA_HOME/qed/partida.sexp` ou
`~/.local/share/qed/partida.sexp`. A gravação usa arquivo temporário, backup e
renomeação atômica. A leitura aplica os mesmos limites básicos da DSL, valida
campos, quantidades, tipos e intervalos, e nunca executa o conteúdo.

O save separa a última biblioteca aplicada do rascunho do editor. Portanto, um
erro de sintaxe pode ser salvo sem passar a comandar o personagem. A v2 inclui
as áreas escolhidas e eventual crédito de migração; pontos e slots são
recalculados e validados na leitura. Se o arquivo
principal falhar, o backup é carregado. Se ambos falharem, a sessão nova abre
com a gravação automática desativada para preservar os arquivos problemáticos.

## Limitações técnicas verificadas

- LWLGL fornece janela, entrada Unicode, clipboard, OpenGL e PNG, mas não um
  compositor de texto. O aplicativo monta um atlas de glifos com
  `cl-freetype2` e o desenha pelo LWLGL.
- O módulo STB do LWLGL exige que seu diretório nativo esteja na busca do CFFI.
  O código resolve esse caminho pelo ASDF, sem incorporar um diretório pessoal.
- Clipboard em janelas ocultas não é confiável no backend Wayland. O ensaio
  oculto usa X11 quando `DISPLAY` está disponível; a aplicação visível segue a
  mesma preferência para manter clipboard Unicode consistente.
- A validação dos sprites exige PNG RGBA com transparência binária e a paleta
  indexada compartilhada. A interface usa RGBA independente, com dimensões
  verificadas pelo carregador. Veja [o contrato da interface](UI.md).
