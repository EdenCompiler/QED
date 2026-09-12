;; Domínios conceituais. Posição: coluna e linha na árvore de cada classe.
((:id "existencia" :titulo "Existência" :classes (:fighter :wizard) :custo 0
  :requisitos () :posicao (1 0)
  :descricao "Entidades, identidade e fatos observáveis. Toda justificativa começa pelo que existe no mundo."
  :vocabulario ("self" "enemy" "state" "stat" "and" "or" "not" "exists")
  :exemplo "(state :idle)")
 (:id "espaco" :titulo "Espaço" :classes (:fighter :wizard) :custo 0
  :requisitos ("existencia") :posicao (0 1)
  :descricao "Posição, distância, alcance e caminhos. Justifica deslocamento e fuga; o executor realiza os saltos."
  :vocabulario ("position" "nearest" "quest-target" "within-range" "reachable" "move-to" "flee" "travel-law" "flee-law")
  :exemplo "(move-to (quest-target))")
 (:id "materia" :titulo "Matéria" :classes (:fighter :wizard) :custo 0
  :requisitos ("existencia") :posicao (1 1)
  :descricao "Recursos, inventário e propriedades físicas. Madeira usa chop; ferro e cristal usam mine após a Oficina."
  :vocabulario ("resource-type" "resource-nearby" "inventory" "gatherable" "interact :chop" "interact :mine" "wet" "gather-law")
  :exemplo "(>= (inventory :iron-ore) 20)")
 (:id "conflito" :titulo "Conflito" :classes (:fighter) :custo 0
  :requisitos ("existencia") :posicao (2 1)
  :descricao "Ameaças e ataque básico. Regras relacionam a presença de um inimigo à ação de combate."
  :vocabulario ("enemy-in-range" "enemy-state" "nearest-threat" "slime" "sentinel" "guardian" "attack :basic")
  :exemplo "(theorem combat
  :class fighter :priority 30
  :premises ((enemy-in-range :melee))
  :conclusion (attack :basic))")
 (:id "estados" :titulo "Estados" :classes (:fighter) :custo 1
  :requisitos ("materia") :posicao (0 2) :libera "status"
  :descricao "Propriedades que podem mudar. Libera status para usar o estado molhado de uma entidade nas premissas."
  :vocabulario ("status")
  :exemplo "(lemma wet-target () (status enemy :wet))")
 (:id "impacto" :titulo "Impacto" :classes (:fighter) :custo 1
  :requisitos ("conflito") :posicao (2 2) :libera ":heavy-strike"
  :descricao "Consequências do contato físico. Libera a conclusão de golpe pesado: 28 de dano por impacto."
  :vocabulario ("attack :heavy-strike")
  :exemplo "(theorem combat
  :class fighter :priority 30
  :premises ((enemy-in-range :melee))
  :conclusion (attack :heavy-strike))")
 (:id "afinidade" :titulo "Afinidade" :classes (:wizard) :custo 0
  :requisitos ("existencia") :posicao (2 1)
  :descricao "Relação entre foco e tempestade. Centelha e relâmpago aceitam qualquer inimigo alcançável."
  :vocabulario ("affinity" "elemental-affinity" "spark-law" "strikes spark")
  :exemplo "(theorem defensive-spark
  :class wizard :priority 30
  :goal (prove (strikes spark enemy)
    :given ((enemy-nearby))
    :using-axioms (elemental-affinity spark-law))
  :on-success (manifest :spark :target enemy)
  :on-failure (fizzle :reason))")
 (:id "conducao" :titulo "Condução" :classes (:wizard) :custo 1
  :requisitos ("materia") :posicao (0 2) :libera "storm-conduction"
  :descricao "Relação causal entre um alvo molhado e sua condutividade. Libera o axioma que será necessário para provar relâmpago."
  :vocabulario ("conductive" "storm-conduction")
  :exemplo "(wet enemy)")
 (:id "tempestade" :titulo "Tempestade" :classes (:wizard) :custo 1
  :requisitos ("afinidade" "conducao") :posicao (2 2) :libera "lightning-law"
  :descricao "Composição de afinidade e condução. Libera a lei de relâmpago: 40 de dano, exigindo alvo molhado, alcance, visão e mana."
  :vocabulario ("lightning-law" "strikes lightning")
  :exemplo "(theorem lightning-strike
  :class wizard :priority 40
  :goal
  (prove (strikes lightning enemy)
    :given ((wet enemy))
    :using-axioms
    (elemental-affinity
     storm-conduction lightning-law))
  :on-success
  (manifest :lightning-bolt
    :target enemy)
  :on-failure (fizzle :reason))")
 (:id "composicao" :titulo "Composição" :classes (:fighter :wizard) :custo 1
  :requisitos ("existencia") :posicao (1 3) :libera "slot"
  :descricao "Amplia o conjunto de decisões: libera o quinto slot de teorema. Lemas continuam sem consumir slots."
  :vocabulario ("quinto slot")
  :exemplo "(lemma low-health () (< (stat :hp) 25))"))
