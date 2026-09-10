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
(lema vida-baixa ()
  (< (atributo :vida) (* 0.25 (atributo :vida-maxima))))
```

Um teorema de Guerreiro é uma regra de produção:

```lisp
(teorema recuar
  :classe guerreiro
  :prioridade 100
  :premissas ((vida-baixa) (inimigo-proximo))
  :conclusao (fugir (ameaca-mais-proxima)))
```

Um teorema de Mago solicita uma prova e declara o único efeito autorizado:

```lisp
(teorema centelha-defensiva
  :classe mago
  :prioridade 30
  :objetivo (provar (atinge centelha inimigo)
    :dado ((inimigo-proximo))
    :usando-axiomas (afinidade-elemental lei-centelha))
  :ao-sucesso (manifestar :centelha :alvo inimigo)
:ao-falha (falhar :motivo))
```

A mesma definição em inglês, preservando o nome de autoria:

```lisp
(theorem centelha-defensiva
  :class wizard
  :priority 30
  :goal (prove (strikes spark enemy)
    :given ((enemy-nearby))
    :using-axioms (elemental-affinity spark-law))
  :on-success (manifest :spark :target enemy)
  :on-failure (fizzle :reason))
```

Omitir `:using-axioms` permite a base desbloqueada completa. Informar
`:using-axioms ()` permite nenhum axioma. Os predicados em `:given` continuam
sendo consultas aos fatos do mundo em ambos os casos.

`:dado` não introduz fatos. Cada condição ali é consultada no mundo e faz a
prova falhar como `dado-falso` se não for confirmada. O efeito de sucesso deve
corresponder ao objetivo provado: por exemplo, provar centelha não autoriza
relâmpago nem um alvo diferente.

Variáveis relacionais começam com `?`, como `?alvo`. A forma `existe` também
aceita um vínculo local tipado, como `(existe (r recurso) ...)`. Seletores
empatados usam o menor identificador estável.

## Condições, seletores e ações

Condições gerais:

- `estado`, `atributo`, `posicao`, `tipo-recurso`, `dentro-do-alcance`;
- `inimigo-em-alcance`, `recurso-proximo`, `inimigo-proximo`;
- `linha-de-visao`, `mana-disponivel`, `alcancavel`, `condicao`;
- `e`, `ou`, `nao`, `existe`, `<`, `>`, `<=`, `>=`, `=`, `+`, `-`, `*`, `/`.

Seletores: `eu`, `inimigo`, `recurso`, `mais-proximo` e
`ameaca-mais-proxima`. Distâncias da DSL são medidas em tiles de 16 pixels.

Ações do Guerreiro: `mover-para`, `atacar`, `interagir`, `fugir`, `esperar` e
`fazer`. `fazer` contém de uma a oito ações sequenciais.

Objetivos utilitários do Mago: `pode-mover`, `pode-coletar`, `pode-fugir` e
`pode-esperar`. Objetivos mágicos: `(atinge centelha alvo)` e, depois do
desbloqueio, `(atinge relampago alvo)`.

## Axiomas iniciais

| Axioma | Prova |
|---|---|
| `lei-deslocamento` | o destino é alcançável |
| `lei-coleta` | o alvo é madeira e está a 1,875 tile |
| `lei-fuga` | a ameaça está a até 12,5 tiles |
| `lei-espera` | sempre disponível |
| `afinidade-elemental` | o Mago tem foco e afinidade de tempestade |
| `conducao-tempestade` | o alvo está molhado; requer a área Condução |
| `lei-centelha` | alvo inimigo, afinidade, alcance, visão e mana |
| `lei-relampago` | como centelha, mais condução; requer a área Tempestade |

## Progressão

Todos começam com quatro slots e as áreas fundamentais liberadas. Aos 30,
60 e 100 XP, o personagem recebe um ponto de conhecimento para escolher uma
área na árvore de ontologia (`F6`). Cada área custa um ponto:

- Guerreiro: Estados libera `status` (alias `condicao`); Impacto libera
  `:golpe-pesado`; Composição libera o quinto slot.
- Mago: Condução libera `conducao-tempestade`; Tempestade exige Condução e
  libera `lei-relampago`; Composição libera o quinto slot.

Receber XP não libera essas áreas automaticamente. A escolha é validada pelo
núcleo e afeta o avaliador imediatamente; copiar um exemplo não aplica a
biblioteca. Os três pontos encerram a progressão desta fatia.

O vocabulário bilíngue completo está em `dados/vocabulario.sexp`. Essa é a
única tabela que traduz gramática, classes, predicados, ações, axiomas e
constantes. Nomes próprios de teoremas, lemas e variáveis são preservados.
Constantes sem dois-pontos como `ocioso`, `madeira` e `cortar` também são aceitas.
`molhado` é o predicado; `:molhado` é a constante usada por `condicao`.

As formas `hipótese`, `padrao` e `juramento`, bem como as classes futuras, são
reconhecidas como vocabulário reservado e recebem o diagnóstico “indisponível
na v1”.
