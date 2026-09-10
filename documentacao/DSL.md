# Especificação da DSL de QED

## Modelo de leitura

A linguagem usa s-expressions lidas pelo leitor de Common Lisp em uma readtable
isolada. O leitor desativa `*read-eval*`, rejeita dispatch `#`, quote, quasiquote,
vírgula, barras verticais, referências a packages e listas impróprias. A entrada
é limitada a 65.536 caracteres, 8.192 nós, 48 níveis e tokens de 80 caracteres.

O texto nunca passa por `eval`, `compile` ou `load`. Após a leitura, o validador
aceita somente formas, operadores e aridades declaradas pelo jogo.
Cada definição validada conserva nome, classe, árvore canônica, trecho original,
posição inicial no documento e idioma da forma principal.
`biblioteca-documento` mantém lemas e teoremas na ordem de autoria;
`biblioteca-definicoes` contém os teoremas na ordem de execução por prioridade.

## Definições

Um lema é uma condição pura e não recursiva:

```lisp
(lemma low-health ()
  (< (stat :hp) (* 0.25 (stat :max-hp))))
```

Um teorema de Guerreiro é uma regra de produção:

```lisp
(theorem retreat
  :class fighter
  :priority 100
  :premises ((low-health) (enemy-nearby))
  :conclusion (flee (nearest-threat)))
```

Um teorema de Mago solicita uma prova e declara o único efeito autorizado:

```lisp
(theorem defensive-spark
  :class wizard
  :priority 30
  :goal (prove (strikes spark enemy)
    :given ((enemy-nearby))
    :using-axioms (elemental-affinity spark-law))
  :on-success (manifest :spark :target enemy)
  :on-failure (fizzle :reason))
```

Os exemplos usam inglês. Aliases portugueses continuam aceitos; nomes de
teoremas, lemas e variáveis são preservados como escritos pelo jogador.

Omitir `:using-axioms` permite a base desbloqueada completa. Informar
`:using-axioms ()` permite nenhum axioma. Os predicados em `:given` continuam
sendo consultas aos fatos do mundo em ambos os casos.

`:given` não introduz fatos. Cada condição ali é consultada no mundo e faz a
prova falhar como `dado-falso` se não for confirmada. O efeito de sucesso deve
corresponder ao objetivo provado: por exemplo, provar centelha não autoriza
relâmpago nem um alvo diferente.

Variáveis relacionais começam com `?`, como `?target`. A forma `exists` também
aceita um vínculo local tipado, como `(exists (r resource) ...)`. Seletores
empatados usam o menor identificador estável.

## Condições, seletores e ações

Condições gerais:

- `state`, `stat`, `position`, `resource-type`, `within-range`;
- `enemy-in-range`, `resource-nearby`, `enemy-nearby`;
- `line-of-sight`, `mana-available`, `reachable`, `status`;
- `and`, `or`, `not`, `exists`, `<`, `>`, `<=`, `>=`, `=`, `+`, `-`, `*`, `/`.

Seletores: `self`, `enemy`, `resource`, `nearest` e
`nearest-threat`. Distâncias da DSL são medidas em tiles de 16 pixels.

Ações do Guerreiro: `move-to`, `attack`, `interact`, `flee`, `wait` e
`do`. `do` contém de uma a oito ações sequenciais.

Objetivos utilitários do Mago: `can-move`, `can-gather`, `can-flee` e
`can-wait`. Objetivos mágicos: `(strikes spark enemy)` e, depois do
desbloqueio, `(strikes lightning enemy)`.

## Axiomas iniciais

| Axioma | Prova |
|---|---|
| `travel-law` | o destino é alcançável |
| `gather-law` | o alvo é madeira e está a 1,875 tile |
| `flee-law` | a ameaça está a até 12,5 tiles |
| `wait-law` | sempre disponível |
| `elemental-affinity` | o Mago tem foco e afinidade de tempestade |
| `storm-conduction` | o alvo está molhado; requer a área Condução |
| `spark-law` | alvo inimigo, afinidade, alcance, visão e mana |
| `lightning-law` | como centelha, mais condução; requer a área Tempestade |

## Progressão

Todos começam com quatro slots e as áreas fundamentais liberadas. Aos 30,
60 e 100 XP, o personagem recebe um ponto de conhecimento para escolher uma
área na árvore de ontologia (`F6`). Cada área custa um ponto:

- Guerreiro: Estados libera `status` (alias português `condicao`); Impacto libera
  `:heavy-strike`; Composição libera o quinto slot.
- Mago: Condução libera `storm-conduction`; Tempestade exige Condução e
  libera `lightning-law`; Composição libera o quinto slot.

Receber XP não libera essas áreas automaticamente. A escolha é validada pelo
núcleo e afeta o avaliador imediatamente; copiar um exemplo não aplica a
biblioteca. Os três pontos encerram a progressão desta fatia.

O vocabulário bilíngue completo está em `dados/vocabulario.sexp`. Essa é a
única tabela que traduz gramática, classes, predicados, ações, axiomas e
constantes. Nomes próprios de teoremas, lemas e variáveis são preservados.
Constantes sem dois-pontos como `idle`, `wood` e `chop` também são aceitas.
`wet` é o predicado; `:wet` é a constante usada por `status`.

As formas `hypothesis`, `default` e `oath`, bem como as classes futuras, são
reconhecidas como vocabulário reservado e recebem o diagnóstico “indisponível
na v1”.
