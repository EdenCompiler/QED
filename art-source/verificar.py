"""Inspeciona os exports e projetos Aseprite sem alterar imagens."""
from pathlib import Path
import re
import struct
from PIL import Image

raiz = Path(__file__).resolve().parents[1]
cores = [int(cor) for cor in re.findall(r'\d+', (raiz / 'dados/paleta-gerada.sexp').read_text())]
assert 1 <= len(cores) <= 255 and all(0 <= cor <= 0xffffff for cor in cores)
paleta = {((cor >> 16) & 255, (cor >> 8) & 255, cor & 255) for cor in cores}
total = 0
registros = (raiz / 'art-source/exportacoes.tsv').read_text().splitlines()
for registro in registros:
    grupo, estado, intervalo = registro.split('\t')
    inicio, fim = map(int, intervalo.split(','))
    texto = (raiz / f'assets/{grupo}/{estado}.sexp').read_text()
    largura, altura = map(int, re.search(r':quadro \((\d+) (\d+)\)', texto).groups())
    quantidade = int(re.search(r':quadros (\d+)', texto).group(1))
    duracao = int(re.search(r':duracao-ms (\d+)', texto).group(1))
    assert quantidade == fim - inicio + 1, registro
    with Image.open(raiz / f'assets/{grupo}/{estado}.png') as imagem:
        assert imagem.size == (largura * quantidade, altura), registro
        pixels = imagem.convert('RGBA')
        assert all(a in (0, 255) and (a == 0 or (r, g, b) in paleta)
                   for r, g, b, a in pixels.getdata()), registro
        for indice in range(quantidade):
            assert pixels.crop((indice * largura, 0, (indice + 1) * largura, altura)).getbbox(), registro
        caminho_gif = raiz / f'art-source/previas/{grupo}-{estado}.gif'
        if caminho_gif.exists():
            with Image.open(caminho_gif) as gif:
                assert gif.n_frames == quantidade, f'GIF desatualizado: {registro}'
                for indice in range(quantidade):
                    gif.seek(indice)
                    atual = gif.convert('RGBA')
                    esperado = pixels.crop((indice * largura, 0, (indice + 1) * largura, altura))
                    esperado = esperado.resize((largura * 4, altura * 4), Image.Resampling.NEAREST)
                    assert atual.size == esperado.size, registro
                    assert all(a[3] == b[3] and (a[3] == 0 or a[:3] == b[:3])
                               for a, b in zip(atual.getdata(), esperado.getdata())), f'Resíduo no GIF: {registro}/{indice}'
    projeto = (raiz / f'art-source/{grupo}.aseprite').read_bytes()
    assinatura, quadros, lx, ly, profundidade = struct.unpack_from('<5H', projeto, 4)
    assert assinatura == 0xA5E0 and (lx, ly) == (largura, altura) and profundidade == 8, grupo
    assert fim < quadros, registro
    deslocamento = 128
    for indice in range(quadros):
        tamanho, marca, _, tempo = struct.unpack_from('<I3H', projeto, deslocamento)
        assert marca == 0xF1FA and tamanho >= 16, registro
        if inicio <= indice <= fim:
            assert tempo == duracao, registro
        deslocamento += tamanho
    assert deslocamento == len(projeto), grupo
    total += quantidade
print(f'{len(registros)} faixas e {total} quadros: PNG, paleta, alfa, duração, projetos e GIFs verificados.')
