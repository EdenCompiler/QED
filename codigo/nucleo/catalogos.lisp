(in-package #:qed.nucleo)

(defun ler-catalogo (arquivo)
  "Lê um único formulário de dados do projeto sem permitir avaliação pelo leitor."
  (let ((*read-eval* nil)
        (caminho (asdf:system-relative-pathname "qed/core"
                                                (merge-pathnames arquivo "dados/"))))
    (with-open-file (fluxo caminho :external-format :utf-8)
      (let ((dados (read fluxo nil :fim)))
        (unless (eq (read fluxo nil :fim) :fim)
          (error "Catálogo contém mais de um formulário: ~A" arquivo))
        dados))))

(defparameter *especies*
  '((:wood :categoria :recurso :nome "Madeira" :hp 1 :xp 2 :retorno 6 :duracao 0.4)
    (:iron-ore :categoria :recurso :nome "Minério de ferro" :hp 1 :xp 4 :retorno 8 :duracao 0.7)
    (:arcane-crystal :categoria :recurso :nome "Cristal arcano" :hp 1 :xp 6 :retorno 10 :duracao 0.9)
    (:slime :categoria :inimigo :nome "Slime" :hp 35 :xp 10 :retorno 8 :dano 7 :alcance 26)
    (:sentinel :categoria :inimigo :nome "Sentinela" :hp 70 :xp 18 :retorno 10
     :dano 14 :alcance 34 :preparacao 4/5 :recuperacao 6/5 :velocidade 36 :deteccao 320)
    (:guardian :categoria :inimigo :nome "Guardião" :hp 300 :xp 80 :retorno 0
     :dano 24 :alcance 46 :preparacao 6/5 :recuperacao 2 :velocidade 28 :deteccao 360)
    (:mine-gate :categoria :marco :nome "Passagem da mina" :hp 1 :xp 0 :retorno 0)
    (:observatory-gate :categoria :marco :nome "Passagem do observatório" :hp 1 :xp 0 :retorno 0)))

(defun especificacao-especie (tipo)
  (or (cdr (assoc tipo *especies*))
      (error "Espécie desconhecida: ~A" tipo)))

(defparameter *campanha*
  '(:versao 1
    :regioes ((:id :clareira :nome "Clareira das Ruínas" :inicio 0 :largura 1440
               :entrada 48 :arquivo "clareira.sexp")
              (:id :mina :nome "Mina Abandonada" :inicio 1440 :largura 960
               :entrada 1472 :arquivo "mina.sexp")
              (:id :observatorio :nome "Ruínas do Observatório" :inicio 2400 :largura 960
               :entrada 2432 :arquivo "ruinas.sexp"))
    :zonas-umidas ((672 240 80 32) (1808 240 112 32))
    :passagens ((:tipo :mine-gate :x 1432 :construcao :workshop)
                (:tipo :observatory-gate :x 2392 :construcao :observatory))
    :entidades ((:id 1 :tipo :wood :x 200) (:id 2 :tipo :slime :x 310)
                (:id 3 :tipo :wood :x 610) (:id 4 :tipo :slime :x 710 :molhada t)
                (:id 5 :tipo :wood :x 1000) (:id 6 :tipo :slime :x 1280)
                (:id 7 :tipo :wood :x 420) (:id 8 :tipo :slime :x 1120)
                (:id 9 :tipo :mine-gate :x 1424)
                (:id 10 :tipo :iron-ore :x 1540) (:id 11 :tipo :iron-ore :x 1760)
                (:id 12 :tipo :sentinel :x 1880) (:id 13 :tipo :iron-ore :x 2120)
                (:id 14 :tipo :sentinel :x 2260) (:id 15 :tipo :arcane-crystal :x 1650)
                (:id 16 :tipo :arcane-crystal :x 2180)
                (:id 17 :tipo :observatory-gate :x 2384)
                (:id 18 :tipo :sentinel :x 2520) (:id 19 :tipo :arcane-crystal :x 2660)
                (:id 20 :tipo :sentinel :x 2820) (:id 21 :tipo :guardian :x 3220))))

(defparameter *construcoes-campanha*
  '((:id :shelter :nome "Abrigo" :custos (:wood 30) :requisitos ()
     :descricao "Reforça a carcaça do autômato: +25 de vida máxima.")
    (:id :workshop :nome "Oficina" :custos (:wood 50) :requisitos (:shelter :eight-slimes)
     :descricao "Libera mineração e abre a Mina Abandonada.")
    (:id :arsenal :nome "Arsenal" :custos (:wood 30 :iron-ore 20) :requisitos (:workshop)
     :descricao "Acrescenta 4 de dano a ataques e manifestações.")
    (:id :observatory :nome "Observatório" :custos (:iron-ore 20 :arcane-crystal 10)
     :requisitos (:arsenal :six-sentinels)
     :descricao "Acrescenta 20 de mana máxima e abre as ruínas.")))

(defun especificacao-construcao (id)
  (or (find id *construcoes-campanha* :key (lambda (item) (getf item :id)))
      (error "Construção desconhecida: ~A" id)))
