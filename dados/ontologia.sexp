;; Domínios conceituais. Posição: coluna e linha na árvore de cada classe.
((:id "existencia" :titulo "Existência" :classes (:fighter :wizard) :custo 0
  :requisitos () :posicao (1 0)
  :descricao "Entidades, identidade e fatos observáveis. Toda justificativa começa pelo que existe no mundo."
  :vocabulario ("self" "enemy" "state" "stat" "and" "or" "not" "exists")
  :exemplo "(estado :ocioso)")
 (:id "espaco" :titulo "Espaço" :classes (:fighter :wizard) :custo 0
  :requisitos ("existencia") :posicao (0 1)
  :descricao "Posição, distância, alcance e caminhos. Justifica deslocamento e fuga; o executor realiza os saltos."
  :vocabulario ("position" "nearest" "within-range" "reachable" "move-to" "flee" "travel-law" "flee-law")
  :exemplo "(mover-para (mais-proximo recurso :madeira))")
 (:id "materia" :titulo "Matéria" :classes (:fighter :wizard) :custo 0
  :requisitos ("existencia") :posicao (1 1)
  :descricao "Recursos e propriedades físicas. Identifica madeira e permite justificar a coleta."
  :vocabulario ("resource-type" "resource-nearby" "interact" "wet" "gather-law")
  :exemplo "(tipo-recurso (mais-proximo recurso :madeira) :madeira)")
 (:id "conflito" :titulo "Conflito" :classes (:fighter) :custo 0
  :requisitos ("existencia") :posicao (2 1)
  :descricao "Ameaças e ataque básico. Regras relacionam a presença de um inimigo à ação de combate."
  :vocabulario ("enemy-in-range" "nearest-threat" "attack :basic")
  :exemplo "(teorema combater :classe guerreiro :prioridade 30
  :premissas ((inimigo-em-alcance :corpo-a-corpo))
  :conclusao (atacar :basico))")
 (:id "estados" :titulo "Estados" :classes (:fighter) :custo 1
  :requisitos ("materia") :posicao (0 2) :libera "status"
  :descricao "Propriedades que podem mudar. Libera status para usar o estado molhado de uma entidade nas premissas."
  :vocabulario ("status")
  :exemplo "(lema alvo-molhado () (status inimigo :molhado))")
 (:id "impacto" :titulo "Impacto" :classes (:fighter) :custo 1
  :requisitos ("conflito") :posicao (2 2) :libera ":heavy-strike"
  :descricao "Consequências do contato físico. Libera a conclusão de golpe pesado: 28 de dano por impacto."
  :vocabulario ("attack :heavy-strike")
  :exemplo "(teorema combater :classe guerreiro :prioridade 30
  :premissas ((inimigo-em-alcance :corpo-a-corpo))
  :conclusao (atacar :golpe-pesado))")
 (:id "afinidade" :titulo "Afinidade" :classes (:wizard) :custo 0
  :requisitos ("existencia") :posicao (2 1)
  :descricao "Relação entre foco e tempestade. Os axiomas iniciais permitem provar e manifestar centelha."
  :vocabulario ("affinity" "elemental-affinity" "spark-law" "strikes spark")
  :exemplo "(teorema centelha-defensiva :classe mago :prioridade 30
  :objetivo (provar (atinge centelha inimigo)
    :dado ((inimigo-proximo))
    :usando-axiomas (afinidade-elemental lei-centelha))
  :ao-sucesso (manifestar :centelha :alvo inimigo)
  :ao-falha (falhar :motivo))")
 (:id "conducao" :titulo "Condução" :classes (:wizard) :custo 1
  :requisitos ("materia") :posicao (0 2) :libera "storm-conduction"
  :descricao "Relação causal entre um alvo molhado e sua condutividade. Libera o axioma que será necessário para provar relâmpago."
  :vocabulario ("conductive" "storm-conduction")
  :exemplo "(molhado inimigo)")
 (:id "tempestade" :titulo "Tempestade" :classes (:wizard) :custo 1
  :requisitos ("afinidade" "conducao") :posicao (2 2) :libera "lightning-law"
  :descricao "Composição de afinidade e condução. Libera a lei de relâmpago: 40 de dano, exigindo alvo molhado, alcance, visão e mana."
  :vocabulario ("lightning-law" "strikes lightning")
  :exemplo "(teorema relampago :classe mago :prioridade 40
  :objetivo (provar (atinge relampago inimigo)
    :dado ((molhado inimigo))
    :usando-axiomas (afinidade-elemental
      conducao-tempestade lei-relampago))
  :ao-sucesso (manifestar :raio :alvo inimigo)
  :ao-falha (falhar :motivo))")
 (:id "composicao" :titulo "Composição" :classes (:fighter :wizard) :custo 1
  :requisitos ("existencia") :posicao (1 3) :libera "slot"
  :descricao "Amplia o conjunto de decisões: libera o quinto slot de teorema. Lemas continuam sem consumir slots."
  :vocabulario ("quinto slot")
  :exemplo "(lema vida-baixa () (< (atributo :vida) 25))"))
