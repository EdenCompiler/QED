.PHONY: executar compilar testar simular verificar-interface ensaio-30-minutos arte exportar-arte verificar-arte
compilar:
	sbcl --script compilar.lisp
executar:
	sbcl --script iniciar.lisp
testar:
	sbcl --script iniciar.lisp --testes
simular:
	sbcl --script iniciar.lisp --simular 1800
verificar-interface:
	sbcl --script iniciar.lisp --sem-salvar --oculta --ensaio --quadros 65 --captura build/interface.ppm
ensaio-30-minutos:
	sbcl --script iniciar.lisp --sem-salvar --oculta --ensaio-real --duracao 1800 --captura build/ensaio-30min.ppm
arte:
	bash art-source/importar.sh
exportar-arte:
	bash art-source/exportar.sh
verificar-arte:
	python3 art-source/verificar.py

.PHONY: arte-interface verificar-arte-interface
arte-interface:
	bash art-source/interface/exportar.sh
verificar-arte-interface:
	python3 art-source/interface/verificar.py
