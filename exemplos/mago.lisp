;; Todas as ações do Mago precisam de uma prova.
(teorema recuar
  :classe mago :prioridade 100
  :objetivo (provar (pode-fugir inimigo)
    :dado ((< (atributo :vida) 25) (inimigo-proximo))
    :usando-axiomas (lei-fuga))
  :ao-sucesso (fugir inimigo)
  :ao-falha (falhar :motivo))

(teorema centelha-defensiva
  :classe mago :prioridade 30
  :objetivo (provar (atinge centelha inimigo)
    :dado ((inimigo-proximo))
    :usando-axiomas (afinidade-elemental lei-centelha))
  :ao-sucesso (manifestar :centelha :alvo inimigo)
  :ao-falha (falhar :motivo))

(teorema recolher
  :classe mago :prioridade 20
  :objetivo (provar (pode-coletar (mais-proximo recurso :madeira))
    :usando-axiomas (lei-coleta))
  :ao-sucesso (interagir :cortar)
  :ao-falha (falhar :motivo))

(teorema explorar
  :classe mago :prioridade 10
  :objetivo (provar (pode-mover (mais-proximo recurso :madeira))
    :usando-axiomas (lei-deslocamento))
  :ao-sucesso (mover-para (mais-proximo recurso :madeira))
  :ao-falha (falhar :motivo))
