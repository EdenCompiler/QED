-- Redução de cores por corte mediano ponderado, sobre os pixels das fontes.
-- Conserva os materiais gerados sem acrescentar desenho ou textura.
return function(fontes)
  local histograma={}
  for _,imagem in pairs(fontes) do
    for y=0,imagem.height-1,2 do for x=0,imagem.width-1,2 do
      local pixel=imagem:getPixel(x,y)
      if app.pixelColor.rgbaA(pixel)>=128 then
        local r,g,b=app.pixelColor.rgbaR(pixel),app.pixelColor.rgbaG(pixel),app.pixelColor.rgbaB(pixel)
        local chave=(r>>3)*1024+(g>>3)*32+(b>>3)
        local cor=histograma[chave]
        if not cor then cor={0,0,0,0};histograma[chave]=cor end
        cor[1]=cor[1]+r;cor[2]=cor[2]+g;cor[3]=cor[3]+b;cor[4]=cor[4]+1
      end
    end end
  end
  local amostras={}
  for chave=0,32767 do
    local cor=histograma[chave]
    if cor then
      for canal=1,3 do cor[canal]=cor[canal]/cor[4] end
      amostras[#amostras+1]=cor
    end
  end
  local function caracterizar(caixa)
    local minimo,maximo={255,255,255},{0,0,0};local peso=0
    for _,cor in ipairs(caixa.cores) do
      peso=peso+cor[4]
      for canal=1,3 do minimo[canal]=math.min(minimo[canal],cor[canal]);maximo[canal]=math.max(maximo[canal],cor[canal]) end
    end
    caixa.eixo=1;caixa.amplitude=0;caixa.peso=peso
    for canal=1,3 do
      local amplitude=(maximo[canal]-minimo[canal])*({1,1.15,1})[canal]
      if amplitude>caixa.amplitude then caixa.amplitude=amplitude;caixa.eixo=canal end
    end
    caixa.prioridade=#caixa.cores>1 and caixa.amplitude*math.sqrt(peso) or 0
  end
  local caixas={{cores=amostras}};caracterizar(caixas[1])
  while #caixas<255 do
    local indice=1
    for i=2,#caixas do if caixas[i].prioridade>caixas[indice].prioridade then indice=i end end
    local caixa=caixas[indice]
    if caixa.prioridade==0 then break end
    table.sort(caixa.cores,function(a,b)
      for deslocamento=0,2 do
        local canal=(caixa.eixo+deslocamento-1)%3+1
        if a[canal]~=b[canal] then return a[canal]<b[canal] end
      end
      return false
    end)
    local soma,divisao=0,1
    for i=1,#caixa.cores-1 do
      soma=soma+caixa.cores[i][4];divisao=i
      if soma>=caixa.peso/2 then break end
    end
    local esquerda,direita={cores={}},{cores={}}
    for i,cor in ipairs(caixa.cores) do
      local destino=i<=divisao and esquerda or direita
      destino.cores[#destino.cores+1]=cor
    end
    caracterizar(esquerda);caracterizar(direita)
    caixas[indice]=esquerda;caixas[#caixas+1]=direita
  end
  local resultado={};local vistas={}
  for _,caixa in ipairs(caixas) do
    local soma={0,0,0}
    for _,cor in ipairs(caixa.cores) do for canal=1,3 do soma[canal]=soma[canal]+cor[canal]*cor[4] end end
    local rgb=0
    for canal=1,3 do rgb=rgb*256+math.floor(soma[canal]/caixa.peso+.5) end
    if not vistas[rgb] then resultado[#resultado+1]=rgb;vistas[rgb]=true end
  end
  table.sort(resultado)
  return resultado
end
