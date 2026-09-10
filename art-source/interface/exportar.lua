-- Recorta e prepara os assets gerados sem desenhar elementos substitutos.
local raiz=assert(app.params.raiz)
local destino=raiz..'/assets/interface/'
app.fs.makeAllDirectories(destino)
local registros={}
local function extrair(imagem,x0,y0,largura,altura)
  local recorte=Image(largura,altura,ColorMode.RGB)
  recorte:drawImage(imagem,Point(-x0,-y0))
  local fila,vistos={},{}
  local function adicionar(x,y)
    if x<0 or y<0 or x>=largura or y>=altura then return end
    local chave=y*largura+x
    if vistos[chave] then return end
    vistos[chave]=true
    local p=recorte:getPixel(x,y)
    local r,g,b=app.pixelColor.rgbaR(p),app.pixelColor.rgbaG(p),app.pixelColor.rgbaB(p)
    if app.pixelColor.rgbaA(p)==0 or (math.min(r,g,b)>140 and math.max(r,g,b)-math.min(r,g,b)<32) then
      recorte:drawPixel(x,y,0);fila[#fila+1]=chave
    end
  end
  -- As duas folhas vieram com quadriculado pintado. Só removemos o fundo
  -- conectado às bordas, preservando os detalhes claros fechados dos selos.
  for x=0,largura-1 do adicionar(x,0);adicionar(x,altura-1) end
  for y=0,altura-1 do adicionar(0,y);adicionar(largura-1,y) end
  local inicio=1
  while inicio<=#fila do
    local chave=fila[inicio];inicio=inicio+1
    local x,y=chave%largura,math.floor(chave/largura)
    adicionar(x-1,y);adicionar(x+1,y);adicionar(x,y-1);adicionar(x,y+1)
  end
  local componentes={};vistos={}
  for y=0,altura-1 do for x=0,largura-1 do
    local chave=y*largura+x
    if not vistos[chave] and app.pixelColor.rgbaA(recorte:getPixel(x,y))>0 then
      local componente={chave};vistos[chave]=true;inicio=1
      while inicio<=#componente do
        local p=componente[inicio];inicio=inicio+1
        local px,py=p%largura,math.floor(p/largura)
        for dy=-1,1 do for dx=-1,1 do
          local nx,ny=px+dx,py+dy;local vizinho=ny*largura+nx
          if nx>=0 and nx<largura and ny>=0 and ny<altura and not vistos[vizinho]
            and app.pixelColor.rgbaA(recorte:getPixel(nx,ny))>0 then
            vistos[vizinho]=true;componente[#componente+1]=vizinho
          end
        end end
      end
      componentes[#componentes+1]=componente
    end
  end end
  table.sort(componentes,function(a,b) return #a>#b end)
  local principal=assert(componentes[1],'Recorte vazio')
  local limpo=Image(largura,altura,ColorMode.RGB)
  local xa,ya,xb,yb=largura,altura,0,0
  for _,chave in ipairs(principal) do
    local x,y=chave%largura,math.floor(chave/largura)
    limpo:drawPixel(x,y,recorte:getPixel(x,y))
    xa=math.min(xa,x);ya=math.min(ya,y);xb=math.max(xb,x);yb=math.max(yb,y)
  end
  return limpo,{xa,ya,xb-xa+1,yb-ya+1}
end
local function exportar(nome,imagem,retangulo,largura,altura,margem)
  local x,y,w,h=table.unpack(retangulo)
  local saida=Image(largura,altura,ColorMode.RGB)
  margem=margem or 0
  for dy=margem,altura-margem-1 do for dx=margem,largura-margem-1 do
    local sx=x+math.min(w-1,math.floor((dx-margem+.5)*w/(largura-2*margem)))
    local sy=y+math.min(h-1,math.floor((dy-margem+.5)*h/(altura-2*margem)))
    saida:drawPixel(dx,dy,imagem:getPixel(sx,sy))
  end end
  local projeto=Sprite(largura,altura,ColorMode.RGB)
  projeto:newCel(projeto.layers[1],1,saida,Point(0,0))
  projeto.layers[1].name='Asset gerado — recorte e escala'
  projeto:saveAs(raiz..'/art-source/interface/'..nome..'.aseprite')
  projeto:saveCopyAs(destino..nome..'.png');projeto:close()
  registros[#registros+1]=string.format('  (:arquivo "%s.png" :quadro (%d %d) :margem %d)',nome,largura,altura,margem)
  print(nome..': '..largura..' × '..altura)
end
local function folha(arquivo,colunas,linhas,nomes,lado,margem)
  local projeto=app.open(raiz..'/art-source/interface/'..arquivo)
  local imagem=Image(projeto.spec);imagem:drawSprite(projeto,1)
  local w,h=imagem.width/colunas,imagem.height/linhas
  for indice,nome in ipairs(nomes) do
    local recorte,retangulo=extrair(imagem,math.floor((indice-1)%colunas*w),math.floor(math.floor((indice-1)/colunas)*h),math.floor(w),math.floor(h))
    exportar(nome,recorte,retangulo,lado,lado,margem)
  end
  projeto:close()
end
folha('paineis-gerados.png',3,2,{'painel','grimorio','bloqueado','liberado','selecionado','botao'},256,0)
folha('selos-gerados.png',4,3,{'existencia','espaco','materia','conflito','estados','impacto','afinidade','conducao','tempestade','composicao','cadeado','conhecimento'},96,2)
local projeto=app.open(raiz..'/art-source/interface/fundo-gerado.png')
local imagem=Image(projeto.spec);imagem:drawSprite(projeto,1)
exportar('fundo',imagem,{0,0,imagem.width,imagem.height},960,540)
projeto:close()

local manifesto=assert(io.open(destino..'manifesto.sexp','w'))
manifesto:write('; Interface RGBA. Painéis: nove recortes com bordas de 32 pixels na fonte.\n')
manifesto:write('(:versao 1 :recorte-painel 32 :assets (\n'..table.concat(registros,'\n')..'))\n')
manifesto:close()
