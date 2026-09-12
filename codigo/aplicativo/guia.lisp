(in-package #:qed.aplicativo)

(defun nome-conhecimento (chave)
  (cond ((equal chave "ponto") "1 ponto de conhecimento")
        ((equal chave "status") "Consulta de estados")
        ((equal chave ":heavy-strike") "Golpe pesado")
        ((equal chave "lightning-law") "Lei de relâmpago")
        ((equal chave "slot") "Quinto slot de teorema")
        (t chave)))

(defun exemplo-do-guia (heroi)
  "Texto copiável em inglês. Copiar nunca aplica nem altera a biblioteca."
  (let ((etapa (etapa-campanha heroi)))
    (cond
      ((member etapa '(:arsenal :sentinels :observatory))
       (if (eq (heroi-classe heroi) :fighter)
           "(theorem mine-materials
  :class fighter :priority 25
  :premises ((exists (ore resource)
    (and (gatherable ore) (within-range ore 1.8))))
  :conclusion (interact :mine))"
           (format nil "(theorem mine-materials
  :class wizard :priority 25
  :goal (prove (can-gather (nearest resource ~A))
    :using-axioms (gather-law))
  :on-success (interact :mine)
  :on-failure (fizzle :reason))"
                   (if (and (eq etapa :sentinels)
                            (>= (quantidade-material heroi :iron-ore) 20))
                       ":arcane-crystal" ":iron-ore"))))
      ((eq etapa :guardian)
       (if (eq (heroi-classe heroi) :fighter)
           "(theorem evade-windup
  :class fighter :priority 110
  :premises ((enemy-state enemy :windup))
  :conclusion (flee (nearest-threat)))"
           "(theorem evade-windup
  :class wizard :priority 110
  :goal (prove (can-flee enemy)
    :given ((enemy-state enemy :windup))
    :using-axioms (flee-law))
  :on-success (flee enemy)
  :on-failure (fizzle :reason))"))
      (t
       (let ((id (if (eq (heroi-classe heroi) :fighter)
                     (if (area-liberada-p heroi "impacto") "impacto" "conflito")
                     (if (area-liberada-p heroi "tempestade") "tempestade" "afinidade"))))
         (getf (buscar-area heroi id) :exemplo))))))

(defun linhas-do-guia (heroi biblioteca)
  (append
   (list "COMO JOGAR"
         "Seu personagem age pela biblioteca. Não há controle direto de caminhada ou golpes."
         "1. Observe a regra ativa ou a árvore de prova."
         "2. F8 fecha este guia. Edite à direita."
         "3. Ctrl+Enter valida e aplica. Erros conservam a última biblioteca válida."
         "4. F4 amplia o mundo. F9 abre o Acampamento. F2 pausa. F1 troca a classe e congela o anterior."
         "Madeira: 2 XP. Ferro: 4 XP. Cristal: 6 XP. Slime: 10 XP. Vida se recupera longe de ameaças."
         "O progresso continua sem foco. Fechar salva; tempo com o jogo fechado não concede ganhos."
         "" "PONTOS DE CONHECIMENTO"
         (format nil "~D XP | ~D de ~D slots ocupados"
                 (heroi-xp heroi) (length (biblioteca-definicoes biblioteca)) (heroi-slots heroi)))
   (loop for (xp chave) in (marcos-progressao (heroi-classe heroi)) collect
     (format nil "~A ~D XP: ~A" (if (>= (heroi-xp heroi) xp) "[RECEBIDO]" "[PENDENTE]") xp (nome-conhecimento chave)))
   (when (and (eq (heroi-classe heroi) :fighter) (area-liberada-p heroi "estados"))
     '("Consulta liberada: (status enemy :wet). Use-a como premissa para consultar o estado do alvo."))
   (list "" "CAMPANHA"
         (resumo-campanha heroi)
         "Fatos úteis: (inventory :wood), (quest-target) e (enemy-state enemy :windup)."
         "Mineração exige a Oficina e (interact :mine). Ataques anunciados têm preparação e recuperação visíveis."
         "" "EXEMPLO DISPONÍVEL — F7 COPIA"
         (if (eq (heroi-classe heroi) :fighter)
             "Substitua seu teorema de ataque por este exemplo; não duplique o nome."
             (if (area-liberada-p heroi "tempestade")
                 (if (area-liberada-p heroi "composicao")
                     "Adicione lightning-strike como quinto teorema. O slime na área úmida permite condução."
                     "Até obter o quinto slot, substitua seu teorema de centelha por este exemplo. Relâmpago exige alvo molhado; centelha funciona em alvos secos.")
                 "Substitua seu teorema de centelha por este exemplo para restaurar a prova inicial.")))
   (uiop:split-string (exemplo-do-guia heroi) :separator '(#\Newline))
   '("" "Copiar não muda a biblioteca. Volte com F8, selecione a definição a substituir e cole com Ctrl+V. Aplique com Ctrl+Enter."
     "F6 abre a árvore de ontologia. Aos 30, 60 e 100 XP, você recebe um ponto para escolher uma área. Cada personagem possui suas próprias escolhas."
     "" "REGRAS E PROVAS"
     "Prioridade maior vence; empates respeitam a ordem no documento. Um lema não ocupa slot."
     "O Guerreiro seleciona a primeira regra elegível. O Mago prova cada ação e mostra os axiomas utilizados."
     "Centelha e relâmpago custam 8 + 2 por passo da prova. Provas utilitárias não gastam mana."
     "Fizzle não consome mana e aguarda um segundo antes de repetir aquele objetivo. Leia o diagnóstico para descobrir o motivo."
     "" "SETE TELAS CONTÍNUAS"
     "Clareira: x=0–1440. Mina Abandonada: x=1440–2400. Observatório: x=2400–3360. Passagens obedecem às construções.")))
