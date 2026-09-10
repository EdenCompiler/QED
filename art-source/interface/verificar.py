"""Valida os assets da interface sem alterar imagens."""
from pathlib import Path
import re
import struct
from PIL import Image

raiz = Path(__file__).resolve().parents[2]
pasta = raiz / 'assets/interface'
manifesto = (pasta / 'manifesto.sexp').read_text()
assert ':versao 1' in manifesto and ':recorte-painel 32' in manifesto
registros = re.findall(r':arquivo "([a-z-]+\.png)" :quadro \((\d+) (\d+)\) :margem (\d+)', manifesto)
assert len(registros) == 19
assert len({registro[0] for registro in registros}) == 19
for arquivo, largura, altura, margem in registros:
    largura, altura, margem = map(int, (largura, altura, margem))
    with Image.open(pasta / arquivo) as imagem:
        assert imagem.size == (largura, altura), arquivo
        alfa = imagem.convert('RGBA').getchannel('A')
        assert alfa.getbbox(), arquivo
        assert set(alfa.getdata()) <= {0, 255}, arquivo
        if margem:
            assert margem == 2 and (largura, altura) == (96, 96), arquivo
            x0, y0, x1, y1 = alfa.getbbox()
            assert x0 >= margem and y0 >= margem and x1 <= largura-margem and y1 <= altura-margem, arquivo
        elif arquivo == 'fundo.png':
            assert alfa.getextrema() == (255, 255), arquivo
        else:
            assert (largura, altura) == (256, 256), arquivo
    projeto = (raiz / 'art-source/interface' / arquivo.replace('.png', '.aseprite')).read_bytes()
    marca, quadros, w, h, profundidade = struct.unpack_from('<5H', projeto, 4)
    assert (marca, quadros, w, h, profundidade) == (0xA5E0, 1, largura, altura, 32), arquivo
print('19 assets de interface: dimensões, transparência, margens e projetos Aseprite verificados.')
