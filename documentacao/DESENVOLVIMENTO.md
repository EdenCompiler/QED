# Desenvolvimento

## Ambiente Linux

Instale SBCL e Quicklisp. O launcher procura `~/quicklisp/setup.lisp`; para outra
instalação, defina `QED_QUICKLISP` com o caminho completo desse arquivo.

Disponibilize [LWLGL](https://github.com/EdenCompiler/LWLGL) 2.2 na busca do ASDF
(por exemplo, em `~/quicklisp/local-projects/LWLGL/`) e prepare suas dependências
nativas seguindo o README desse projeto. QED usa os sistemas `lwlgl/glfw`,
`lwlgl/opengl` e `lwlgl/stb`; o último requer a biblioteca em `native/build/`.
Esse diretório é resolvido a partir da instalação ASDF, sem caminho pessoal
fixo no launcher.

O Quicklisp carrega `cl-freetype2` e FiveAM. O ambiente precisa de GLFW,
FreeType, um driver OpenGL 3.3 e da fonte DejaVu Sans Mono. Para outra fonte
monoespaçada com acentos, defina `QED_FONTE` com o caminho de um TTF.

```sh
make executar
make compilar
./build/qed --sem-salvar
```

`build/qed` contém o runtime SBCL e os sistemas compilados. É um executável
local, ligado à instalação do projeto e às bibliotecas nativas presentes.
A compilação recria o handle FreeType ao iniciar, pois memória C não pode
ser preservada na imagem Lisp.

## Verificação

| Comando | Verifica |
|---|---|
| `make testar` | Núcleo e avaliadores em FiveAM, sem janela |
| `make simular` | Trinta minutos simulados por personagem |
| `make verificar-interface` | Unicode, clipboard, desfazer/refazer, navegação, pausa, alternância e redimensionamento em janela oculta |
| `make ensaio-30-minutos` | Sessão de trinta minutos reais, sem salvar progresso pessoal |
| `make verificar-arte` | Sprites, paleta, metadados, projetos e GIFs |
| `make verificar-arte-interface` | Os 19 assets de interface e seus projetos |

As verificações de imagens exigem Python e Pillow. O ensaio gráfico curto
gera `build/interface.ppm`. Resultados e ressalvas estão no
[registro de validação](VALIDACAO.md).

## Arte

`make arte` importa os originais gerados dos sprites; `make exportar-arte`
exporta os projetos existentes e os GIFs. `make arte-interface` prepara os
painéis e selos. Esses comandos usam Aseprite em Xvfb e não abrem janelas no
desktop. Não chamam serviços de geração de imagem.

Leia o [guia de arte](ARTE.md), o [processo dos sprites](../art-source/README.md)
e as [decisões da interface](UI.md) antes de alterar o pipeline.

## Código

Os sistemas ASDF separam `qed/core` (mundo e progressão), `qed/logic`
(linguagem e provas), `qed/app` (editor e renderer) e `qed/tests` (testes).
Escreva código e documentação em português brasileiro. Os programas de exemplo
em `exemplos/`, no guia e na ontologia usam inglês, incluindo nomes e comentários. A DSL possui uma forma
canônica em inglês e aliases centralizados; preserve os nomes escritos pelo
jogador.

Mudanças no vocabulário devem atualizar validação, tradução, exemplos e
ontologia. Alterações gráficas devem ser inspecionadas no aplicativo em
1440×900 e 1280×800. Capturas do manual podem ser refeitas com
`sbcl --script ferramentas/capturar-interface.lisp`.
