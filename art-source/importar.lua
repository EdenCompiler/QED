-- Importa os pixels gerados: recorte, amostragem nearest e paleta indexada.
-- Não desenha personagens nem sintetiza poses. Executar no Aseprite virtual.
local raiz=assert(app.params.raiz,'Informe a raiz do projeto.')
local cores
local paleta
local memoria={}
local function cor_indexada(pixel)
  if app.pixelColor.rgbaA(pixel)<128 then return 0 end
  local rgb=pixel&0xffffff
  if memoria[rgb] then return memoria[rgb] end
  local r,g,b=app.pixelColor.rgbaR(pixel),app.pixelColor.rgbaG(pixel),app.pixelColor.rgbaB(pixel)
  local melhor,menor=1,math.huge
  for indice,cor in ipairs(cores) do
    local dr,dg,db=r-((cor>>16)&255),g-((cor>>8)&255),b-(cor&255)
    local distancia=dr*dr*3+dg*dg*4+db*db*2
    if distancia<menor then melhor,menor=indice,distancia end
  end
  memoria[rgb]=melhor
  return melhor
end
local manifesto=dofile(raiz..'/art-source/manifesto.lua')
local function retirar_quadriculado(imagem,poligonos)
  local largura,altura=imagem.width,imagem.height
  local visitados,fila={},{}
  local protegidos={}
  for _,poligono in ipairs(poligonos or {}) do
    local x0,y0,x1,y1=largura,altura,0,0
    for _,ponto in ipairs(poligono) do
      x0=math.min(x0,ponto[1]);y0=math.min(y0,ponto[2])
      x1=math.max(x1,ponto[1]);y1=math.max(y1,ponto[2])
    end
    for y=y0,y1 do for x=x0,x1 do
      local dentro=false;local anterior=poligono[#poligono]
      for _,atual in ipairs(poligono) do
        if (atual[2]>y)~=(anterior[2]>y)
          and x<(anterior[1]-atual[1])*(y-atual[2])/(anterior[2]-atual[2])+atual[1] then
          dentro=not dentro
        end
        anterior=atual
      end
      if dentro then protegidos[y*largura+x+1]=true end
    end end
  end
  local function adicionar(x,y)
    if x<0 or y<0 or x>=largura or y>=altura then return end
    local indice=y*largura+x+1
    if visitados[indice] or protegidos[indice] then return end
    visitados[indice]=true
    local pixel=imagem:getPixel(x,y)
    local r,g,b=app.pixelColor.rgbaR(pixel),app.pixelColor.rgbaG(pixel),app.pixelColor.rgbaB(pixel)
    if math.min(r,g,b)>140 and math.max(r,g,b)-math.min(r,g,b)<24 then
      fila[#fila+1]=indice
      imagem:drawPixel(x,y,app.pixelColor.rgba(r,g,b,0))
    end
  end
  -- Inundação somente a partir das bordas e dos separadores observados.
  -- As regiões claras fechadas da armadura permanecem opacas.
  for y=0,altura-1 do adicionar(0,y);adicionar(largura-1,y) end
  for x=0,largura-1 do adicionar(x,0);adicionar(x,altura-1) end
  for linha=1,7 do
    local y=math.floor(linha*altura/8)
    for x=0,largura-1 do adicionar(x,y) end
  end
  local inicio=1
  while inicio<=#fila do
    local indice=fila[inicio]-1;inicio=inicio+1
    local x,y=indice%largura,math.floor(indice/largura)
    adicionar(x-1,y);adicionar(x+1,y);adicionar(x,y-1);adicionar(x,y+1)
  end
  print('Fundo quadriculado removido de '..#fila..' pixels.')
end
local fontes={}
local function carregar_fonte(dados)
  if dados.fonte and not fontes[dados.fonte] then
    local fonte=app.open(raiz..'/art-source/gerados/'..dados.fonte)
    assert(fonte.colorMode==ColorMode.RGB,'A fonte deve ser RGBA: '..dados.fonte)
    local imagem=Image(fonte.spec);imagem:drawSprite(fonte,1)
    if dados.retirar_quadriculado then retirar_quadriculado(imagem,dados.preservar_poligonos) end
    if dados.retirar_magenta then
      for y=0,imagem.height-1 do for x=0,imagem.width-1 do
        local pixel=imagem:getPixel(x,y)
        local r,g,b=app.pixelColor.rgbaR(pixel),app.pixelColor.rgbaG(pixel),app.pixelColor.rgbaB(pixel)
        if r>75 and b>80 and r-g>60 and b-g>60 and r>=b*.8 then imagem:drawPixel(x,y,0) end
      end end
    end
    fontes[dados.fonte]=imagem;fonte:close()
  end
end
for _,grupo in ipairs(manifesto) do
  carregar_fonte(grupo)
  for _,animacao in ipairs(grupo.animacoes) do carregar_fonte(animacao) end
end
cores=dofile(raiz..'/art-source/paleta.lua')(fontes)
paleta=Palette(#cores+1);paleta:setColor(0,Color{r=0,g=0,b=0,a=0})
local arquivo_paleta=assert(io.open(raiz..'/dados/paleta-gerada.sexp','w'))
arquivo_paleta:write('(')
for indice,cor in ipairs(cores) do
  paleta:setColor(indice,Color{r=(cor>>16)&255,g=(cor>>8)&255,b=cor&255,a=255})
  arquivo_paleta:write(tostring(cor)..(indice%12==0 and '\n' or ' '))
end
arquivo_paleta:write(')\n');arquivo_paleta:close()
print('Paleta compartilhada: '..#cores..' cores e transparência.')
local function alinhar_personagem(original,animacao,quadro)
  local estado=animacao.nome
  local vistos,componentes={},{}
  for y=0,63 do for x=0,63 do
    local chave=y*64+x+1
    if not vistos[chave] and original:getPixel(x,y)~=0 then
      local fila={chave};vistos[chave]=true
      local inicio=1
      while inicio<=#fila do
        local posicao=fila[inicio]-1;inicio=inicio+1
        local px,py=posicao%64,math.floor(posicao/64)
        for dy=-1,1 do for dx=-1,1 do
          local nx,ny=px+dx,py+dy;local indice=ny*64+nx+1
          if nx>=0 and nx<64 and ny>=0 and ny<64 and not vistos[indice]
            and original:getPixel(nx,ny)~=0 then
            vistos[indice]=true;fila[#fila+1]=indice
          end
        end end
      end
      componentes[#componentes+1]=fila
    end
  end end
  table.sort(componentes,function(a,b) return #a>#b end)
  local principal=assert(componentes[1],'Quadro sem personagem.')
  local base=0
  for _,indice in ipairs(principal) do base=math.max(base,math.floor((indice-1)/64)) end
  -- Fragmentos de vizinhos na borda não pertencem ao quadro selecionado.
  local limpo=Image(64,64,ColorMode.INDEXED)
  for numero,componente in ipairs(componentes) do
    local minimo_x=64
    local arco=false
    for _,indice in ipairs(componente) do
      local x,y=(indice-1)%64,math.floor((indice-1)/64)
      minimo_x=math.min(minimo_x,x)
      local cor=cores[original:getPixel(x,y)]
      local r,g,b=(cor>>16)&255,(cor>>8)&255,cor&255
      if animacao.preservar_arco and (quadro==4 or quadro==5)
        and b>150 and b>r+30 and g>r+15 then arco=true end
    end
    local efeito_frontal=not animacao.preservar_arco
      and (estado=='attack' or estado=='cast') and minimo_x>=32
    -- A lâmina erguida é fina e pode ficar separada da mão na amostragem.
    local espada_erguida=animacao.preservar_arco and quadro==3
    if numero==1 or arco or espada_erguida or (#componente>=12 and efeito_frontal) then
      for _,indice in ipairs(componente) do
        local x,y=(indice-1)%64,math.floor((indice-1)/64)
        limpo:drawPixel(x,y,original:getPixel(x,y))
      end
    end
  end
  local destino=Image(64,64,ColorMode.INDEXED)
  local escala=animacao.escala_alinhamento or .9
  for y=0,63 do for x=0,63 do
    local sx=math.floor(32+(x-32)/escala+.5)
    local sy=math.floor(base+(y-59)/escala+.5)
    if sx>=0 and sx<64 and sy>=0 and sy<64 then destino:drawPixel(x,y,limpo:getPixel(sx,sy)) end
  end end
  return destino
end
local registro=assert(io.open(raiz..'/art-source/exportacoes.tsv','w'))
app.fs.makeAllDirectories(raiz..'/art-source/previas')
for _,grupo in ipairs(manifesto) do
  local projeto=Sprite(grupo.largura,grupo.altura,ColorMode.INDEXED)
  projeto:setPalette(paleta);projeto.transparentColor=0
  projeto.gridBounds=Rectangle(0,0,16,16)
  projeto.layers[1].name='Pixels gerados — recorte e paleta'
  projeto.data='QED: fonte gerada por image_gen. Origem: '..grupo.fonte
  local indice=0;local etiquetas={}
  for _,animacao in ipairs(grupo.animacoes) do
    local imagem=fontes[animacao.fonte or grupo.fonte]
    local inicio=indice+1
    local faixa=Sprite(grupo.largura*#animacao.celulas,grupo.altura,ColorMode.INDEXED)
    faixa:setPalette(paleta);faixa.transparentColor=0
    local horizontal=Image(faixa.spec)
    for numero,celula in ipairs(animacao.celulas) do
      local recorte=Image(grupo.largura,grupo.altura,ColorMode.INDEXED)
      local x,y,w,h=table.unpack(celula)
      local presentes=0
      for dy=0,grupo.altura-1 do for dx=0,grupo.largura-1 do
        local sx,sy
        if grupo.alinhar then
          local fator=animacao.fator_amostragem or math.max(w/grupo.largura,h/grupo.altura)
          sx=math.floor(x+w/2+(dx+.5-grupo.largura/2)*fator)
          sy=math.floor(y+h/2+(dy+.5-grupo.altura/2)*fator)
        else
          sx=math.floor(x+(dx+.5)*w/grupo.largura)
          sy=math.floor(y+(dy+.5)*h/grupo.altura)
        end
        local cor=0
        local excluido=false
        for _,area in ipairs((animacao.exclusoes or {})[numero] or {}) do
          if sx>=area[1] and sy>=area[2] and sx<area[1]+area[3] and sy<area[2]+area[4] then excluido=true end
        end
        if not excluido and sx>=x and sy>=y and sx<x+w and sy<y+h then
          assert(sx>=0 and sy>=0 and sx<imagem.width and sy<imagem.height,'Recorte fora da fonte.')
          cor=cor_indexada(imagem:getPixel(sx,sy))
        end
        recorte:drawPixel(dx,dy,cor)
        if cor~=0 then presentes=presentes+1 end
      end end
      assert(presentes>0,'Quadro vazio: '..grupo.nome..'/'..animacao.nome)
      if grupo.alinhar then recorte=alinhar_personagem(recorte,animacao,numero) end
      indice=indice+1
      if indice>1 then projeto:newEmptyFrame(indice) end
      projeto:newCel(projeto.layers[1],indice,recorte,Point(0,0))
      projeto.frames[indice].duration=animacao.duracao/1000
      horizontal:drawImage(recorte,Point((numero-1)*grupo.largura,0))
    end
    etiquetas[#etiquetas+1]={animacao.nome,inicio,indice}
    local pasta=raiz..'/assets/'..grupo.nome..'/'
    app.fs.makeAllDirectories(pasta)
    faixa:newCel(faixa.layers[1],1,horizontal,Point(0,0))
    faixa:saveCopyAs(pasta..animacao.nome..'.png');faixa:close()
    local dados=assert(io.open(pasta..animacao.nome..'.sexp','w'))
    dados:write(string.format('(:versao 1 :arquivo "%s.png" :quadro (%d %d) :quadros %d :duracao-ms %d :repetir %d :pivo (%d %d))\n',
      animacao.nome,grupo.largura,grupo.altura,#animacao.celulas,animacao.duracao,
      animacao.repetir and 1 or 0,grupo.pivo[1],grupo.pivo[2]))
    dados:close()
    registro:write(grupo.nome..'\t'..animacao.nome..'\t'..(inicio-1)..','..(indice-1)..'\n')
  end
  for _,dados in ipairs(etiquetas) do
    local etiqueta=projeto:newTag(dados[2],dados[3]);etiqueta.name=dados[1]
  end
  projeto:saveAs(raiz..'/art-source/'..grupo.nome..'.aseprite')
  projeto:close()
  print(grupo.nome..': '..indice..' quadros importados de '..grupo.fonte)
end
registro:close()
