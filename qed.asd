(asdf:defsystem "qed/core"
  :description "QED: mundo determinístico sem dependências gráficas."
  :version "0.1.0" :depends-on ("uiop") :serial t
  :components ((:file "codigo/nucleo/pacote") (:file "codigo/nucleo/mundo")
               (:file "codigo/nucleo/ontologia")))

(asdf:defsystem "qed/logic"
  :description "QED: linguagem restrita, regras e resolução de objetivos."
  :depends-on ("qed/core") :serial t
  :components ((:file "codigo/logica/pacote") (:file "codigo/logica/leitor")
               (:file "codigo/logica/linguagem") (:file "codigo/logica/avaliadores")
               (:file "codigo/logica/persistencia")))

(asdf:defsystem "qed/app"
  :description "QED: editor e janela LWLGL."
  :depends-on ("qed/logic" "lwlgl/glfw" "lwlgl/opengl" "lwlgl/stb" "cl-freetype2")
  :serial t
  :components ((:file "codigo/aplicativo/pacote") (:file "codigo/aplicativo/editor")
               (:file "codigo/aplicativo/guia")
               (:file "codigo/aplicativo/arte") (:file "codigo/aplicativo/grafica")
               (:file "codigo/aplicativo/tema")
               (:file "codigo/aplicativo/ontologia")
               (:file "codigo/aplicativo/janela") (:file "codigo/aplicativo/entrada")))

(asdf:defsystem "qed/tests"
  :depends-on ("qed/logic" "fiveam") :serial t
  :components ((:file "testes/nucleo"))
  :perform (asdf:test-op (operacao componente)
             (declare (ignore operacao componente))
             (unless (uiop:symbol-call :qed.testes :executar)
               (error "A suíte de QED falhou."))))

(asdf:defsystem "qed" :depends-on ("qed/app"))
