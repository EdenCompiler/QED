;; Edite as regras, depois aplique com Ctrl+Enter. Distâncias em tiles.
(lema vida-baixa () (< (atributo :vida) (* 0.25 (atributo :vida-maxima))))

(teorema recuar
  :classe guerreiro :prioridade 100
  :premissas ((vida-baixa) (inimigo-proximo))
  :conclusao (fugir (ameaca-mais-proxima)))

(teorema combater
  :classe guerreiro :prioridade 30
  :premissas ((inimigo-em-alcance :corpo-a-corpo))
  :conclusao (atacar :basico))

(teorema recolher
  :classe guerreiro :prioridade 20
  :premissas ((existe (r recurso) (e (tipo-recurso r :madeira) (dentro-do-alcance r 1.8))))
  :conclusao (interagir :cortar))

(teorema explorar
  :classe guerreiro :prioridade 10
  :premissas ((recurso-proximo))
  :conclusao (mover-para (mais-proximo recurso :madeira)))
