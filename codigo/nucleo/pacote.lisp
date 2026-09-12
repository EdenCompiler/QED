(defpackage #:qed.nucleo
  (:use #:cl)
  (:export
   #:+passo+ #:entidade #:criar-entidade #:copiar-entidade
   #:entidade-animacao #:entidade-tempo-animacao #:heroi-ferimento #:heroi-tempo-animacao #:mundo-efeitos
   #:marcos-progressao #:proximo-marco
   #:heroi-conhecimentos #:heroi-pontos-bonus #:areas-ontologia #:buscar-area
   #:area-liberada-p #:situacao-area #:pontos-conhecimento #:desbloquear-area
   #:entidade-id #:entidade-tipo #:entidade-x #:entidade-y #:entidade-vx #:entidade-vy
   #:entidade-hp #:entidade-retorno #:entidade-molhada #:entidade-recarga
   #:entidade-categoria #:entidade-origem-x #:entidade-fase #:entidade-tempo-fase
   #:heroi #:criar-heroi #:copiar-heroi #:heroi-classe #:heroi-x #:heroi-y #:heroi-vx #:heroi-vy
   #:heroi-hp #:heroi-hp-max #:heroi-mana #:heroi-mana-max #:heroi-xp #:heroi-madeira
   #:heroi-inventario #:heroi-construcoes #:heroi-objetivos #:heroi-regioes-descobertas #:heroi-abates
   #:heroi-estado #:heroi-morte #:heroi-acao #:heroi-desbloqueios #:heroi-slots #:heroi-direcao
   #:mundo #:criar-mundo #:mundo-heroi #:mundo-entidades #:mundo-tick #:mundo-eventos
   #:mundo-plataformas #:mundo-largura #:mundo-regioes #:mundo-zonas-umidas
   #:mundo-falhas #:mundo-diagnostico #:mundo-ultimo-resultado
   #:intencao #:criar-intencao #:intencao-acoes #:intencao-nome #:intencao-prioridade
   #:intencao-mana #:intencao-duracao #:intencao-passos #:intencao-prova #:intencao-idioma
   #:execucao #:execucao-intencao #:execucao-tempo #:execucao-restantes
   #:resultado #:criar-resultado #:resultado-intencao #:resultado-motivo #:resultado-detalhes
   #:resultado-falhas #:resultado-passos #:resultado-prova
   #:novo-mundo #:fotografar #:avancar #:simular #:registrar #:cancelar-acao
   #:buscar-entidade #:mais-proxima #:distancia #:alcancavel-p #:linha-livre-p
   #:conceder-xp #:atualizar-desbloqueios #:altura-chao #:rota-para #:estado-resumido
   #:quantidade-material #:inimigo-p #:recurso-p #:corresponde-tipo-p #:coletavel-p
   #:construcao-pronta-p #:situacao-construcao #:construir #:especificacao-construcao
   #:objetivo-pronto-p #:etapa-campanha #:resumo-campanha #:alvo-da-missao #:regiao-atual #:bonus-dano))
