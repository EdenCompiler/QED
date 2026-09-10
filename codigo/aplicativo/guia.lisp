(in-package #:qed.aplicativo)

(defun nome-conhecimento (chave)
  (cond ((equal chave "ponto") "1 ponto de conhecimento")
        ((equal chave "status") "Consulta de estados")
        ((equal chave ":heavy-strike") "Golpe pesado")
        ((equal chave "lightning-law") "Lei de relâmpago")
        ((equal chave "slot") "Quinto slot de teorema")
        (t chave)))

(defun exemplo-do-guia (heroi)
  "Texto copiável; nunca aplica nem substitui a biblioteca do jogador."
  (if (eq (heroi-classe heroi) :fighter)
      (if (area-liberada-p heroi (if (eq (heroi-classe heroi) :fighter) "impacto" "tempestade"))
          "(teorema combater
  :classe guerreiro :prioridade 30
  :premissas ((inimigo-em-alcance :corpo-a-corpo))
  :conclusao (atacar :golpe-pesado))"
          "(teorema combater
  :classe guerreiro :prioridade 30
  :premissas ((inimigo-em-alcance :corpo-a-corpo))
  :conclusao (atacar :basico))")
      (if (area-liberada-p heroi (if (eq (heroi-classe heroi) :fighter) "impacto" "tempestade"))
          "(teorema relampago
  :classe mago :prioridade 40
  :objetivo (provar (atinge relampago inimigo)
    :dado ((molhado inimigo))
    :usando-axiomas (afinidade-elemental
      conducao-tempestade lei-relampago))
  :ao-sucesso (manifestar :raio :alvo inimigo)
  :ao-falha (falhar :motivo))"
          "(teorema centelha-defensiva
  :classe mago :prioridade 30
  :objetivo (provar (atinge centelha inimigo)
    :dado ((inimigo-proximo))
    :usando-axiomas (afinidade-elemental lei-centelha))
  :ao-sucesso (manifestar :centelha :alvo inimigo)
  :ao-falha (falhar :motivo))")))

(defun linhas-do-guia (heroi biblioteca)
  (append
   (list "COMO JOGAR"
         "Seu personagem age pela biblioteca. Não há controle direto de caminhada ou golpes."
         "1. Observe a regra ativa ou a árvore de prova."
         "2. F8 fecha este guia. Edite à direita."
         "3. Ctrl+Enter valida e aplica. Erros conservam a última biblioteca válida."
         "4. F4 amplia o mundo. F2 pausa. F1 troca a classe e congela o personagem anterior."
         "Madeira: 2 XP. Slime: 10 XP. Vida se recupera longe de ameaças, fora de ataques e conjurações."
         "O progresso continua sem foco. Fechar salva; tempo com o jogo fechado não concede ganhos."
         "" "PONTOS DE CONHECIMENTO"
         (format nil "~D XP | ~D de ~D slots ocupados"
                 (heroi-xp heroi) (length (biblioteca-definicoes biblioteca)) (heroi-slots heroi)))
   (loop for (xp chave) in (marcos-progressao (heroi-classe heroi)) collect
     (format nil "~A ~D XP: ~A" (if (>= (heroi-xp heroi) xp) "[RECEBIDO]" "[PENDENTE]") xp (nome-conhecimento chave)))
   (when (and (eq (heroi-classe heroi) :fighter) (area-liberada-p heroi "estados"))
     '("Consulta liberada: (status inimigo :molhado). Use-a como premissa para consultar o estado do alvo."))
   (list "" "EXEMPLO DISPONÍVEL — F7 COPIA"
         (if (eq (heroi-classe heroi) :fighter)
             "Substitua o teorema combater por este exemplo; não duplique o nome."
             (if (area-liberada-p heroi "composicao")
                 "Adicione relampago como quinto teorema. O slime na área úmida permite condução."
                 (if (area-liberada-p heroi (if (eq (heroi-classe heroi) :fighter) "impacto" "tempestade"))
                     "Até obter o quinto slot, substitua centelha-defensiva por este exemplo. Relâmpago exige alvo molhado; centelha funciona em alvos secos."
                     "Substitua centelha-defensiva por este exemplo para restaurar a prova inicial."))))
   (uiop:split-string (exemplo-do-guia heroi) :separator '(#\Newline))
   '("" "Copiar não muda a biblioteca. Volte com F8, selecione a definição a substituir e cole com Ctrl+V. Aplique com Ctrl+Enter."
     "F6 abre a árvore de ontologia. Aos 30, 60 e 100 XP, você recebe um ponto para escolher uma área. Cada personagem possui suas próprias escolhas."
     "" "REGRAS E PROVAS"
     "Prioridade maior vence; empates respeitam a ordem no documento. Um lema não ocupa slot."
     "O Guerreiro seleciona a primeira regra elegível. O Mago prova cada ação e mostra os axiomas utilizados."
     "Centelha e relâmpago custam 8 + 2 por passo da prova. Provas utilitárias não gastam mana."
     "Fizzle não consome mana e aguarda um segundo antes de repetir aquele objetivo. Leia o diagnóstico para descobrir o motivo."
     "" "EXPLORE A CLAREIRA"
     "Floresta: x=0–480. Área úmida: x=480–960. Ruínas: x=960–1440. Saltos são executados pelo deslocamento justificado.")))
