(defpackage #:qed.logica
  (:use #:cl #:qed.nucleo)
  (:export #:erro-dsl #:mensagem-erro #:posicao-erro #:ler-dados-seguros #:ler-biblioteca
           #:biblioteca #:biblioteca-definicoes #:biblioteca-lemas #:biblioteca-texto #:biblioteca-documento
           #:definicao #:definicao-nome #:definicao-classe #:definicao-prioridade #:definicao-tipo
           #:definicao-arvore #:definicao-texto-original #:definicao-idioma #:definicao-posicao
           #:avaliar-biblioteca #:consultar #:unificar #:substituir #:provar #:axioma
           #:criar-axioma #:axioma-nome #:axioma-cabeca #:axioma-corpo #:axiomas-iniciais
           #:salvar-partida #:carregar-partida #:sessao #:nova-sessao #:sessao-mundos
           #:sessao-rascunhos #:sessao-bibliotecas #:sessao-ativa #:sessao-idioma #:sessao-pausada
           #:mundo-ativo #:biblioteca-ativa #:alternar-personagem #:aplicar-biblioteca
           #:avancar-sessao #:salvo-padrao #:fonte-exemplo #:traduzir-motivo #:traduzir-evento
           #:definir-teorema #:definir-lema #:canonico #:*vocabulario*))
