-- Retângulos medidos nas folhas geradas de 1254 × 1254 pixels.
local lado=1254/8
local function celula(linha,coluna)
  return {(coluna-1)*lado,(linha-1)*lado,lado,lado}
end
local function sequencia(linha,inicio,fim)
  local celulas={};for coluna=inicio,fim do celulas[#celulas+1]=celula(linha,coluna) end
  return celulas
end
local function animacao(nome,duracao,repetir,celulas)
  return {nome=nome,duracao=duracao,repetir=repetir,celulas=celulas}
end
local grupos={}
for _,nome in ipairs({'guerreiro','mago'}) do
  -- A sexta fileira contém sete poses, inclusive o corpo já deitado.
  local morte={}
  local bordas=nome=='guerreiro' and {0,164,326,472,643,832,1038,1254}
    or {0,159,321,473,635,798,997,1254}
  for coluna=1,7 do morte[#morte+1]={bordas[coluna],5*lado,bordas[coluna+1]-bordas[coluna],lado} end
  grupos[#grupos+1]={nome=nome,fonte=nome..'.png',retirar_quadriculado=true,
    largura=64,altura=64,pivo={32,60},alinhar=true,animacoes={
      animacao('idle',100,true,sequencia(1,1,8)),
      animacao('walk',75,true,sequencia(2,1,8)),
      animacao('attack',75,false,sequencia(3,1,8)),
      animacao('gather',75,false,sequencia(4,1,8)),
      animacao('hurt',50,false,sequencia(5,1,8)),
      animacao('death',125,false,morte),
      animacao('jump',75,false,sequencia(7,1,8))}}
  if nome=='guerreiro' then
    -- A lâmina clara toca o fundo: preservar seus pixels durante a extração.
    grupos[#grupos].preservar_poligonos={
      {{358,334},{403,313},{408,313},{404,318},{362,340}}}
    -- Os dois arcos ultrapassam as colunas regulares da folha original.
    local ataque=animacao('attack',75,false,{
      {0,310,158,164},{158,310,160,164},{318,310,164,164},
      {480,310,184,164},{634,310,198,164},{804,310,177,164},
      {967,310,139,164},{1106,310,148,164}})
    ataque.fator_amostragem=3.15
    ataque.escala_alinhamento=1
    ataque.preservar_arco=true
    -- As poses vizinhas se intercalam no eixo X, mas não no eixo Y.
    ataque.exclusoes={
      [4]={{635,383,29,91}},
      [5]={{634,310,32,70},{807,403,25,71}}}
    grupos[#grupos].animacoes[3]=ataque
  end
  if nome=='mago' then
    local caminhada={}
    for linha=0,1 do for coluna=0,3 do caminhada[#caminhada+1]={coluna*443.5,linha*443.5,443.5,443.5} end end
    local faixa=animacao('walk',75,true,caminhada)
    faixa.fonte='mago-caminhada.png';faixa.retirar_magenta=true
    grupos[#grupos].animacoes[2]=faixa
    table.insert(grupos[#grupos].animacoes,animacao('cast',75,false,sequencia(8,1,8)))
  end
end
grupos[#grupos+1]={nome='slime',fonte='elementos.png',largura=64,altura=64,pivo={32,60},alinhar=true,animacoes={
  animacao('idle',100,true,sequencia(1,1,8)),animacao('attack',75,false,sequencia(2,1,8)),
  animacao('death',100,false,sequencia(3,1,8)),animacao('hurt',50,false,sequencia(4,1,8))}}
grupos[#grupos+1]={nome='magia',fonte='elementos.png',largura=32,altura=32,pivo={16,16},animacoes={
  animacao('spark',100,false,sequencia(5,1,4)),animacao('lightning',100,false,sequencia(5,5,8))}}
grupos[#grupos+1]={nome='agua',fonte='elementos.png',largura=16,altura=16,pivo={0,0},animacoes={animacao('idle',150,true,{{4,798,148,144},{160,798,148,144},{317,798,148,144},{474,798,148,144}})}}
grupos[#grupos+1]={nome='terreno',fonte='elementos.png',largura=16,altura=16,pivo={0,0},animacoes={animacao('idle',1000,false,{{632,798,150,144},{946,798,150,144}})}}
grupos[#grupos+1]={nome='madeira',fonte='elementos.png',largura=16,altura=16,pivo={8,15},animacoes={animacao('idle',150,false,{celula(7,1)})}}
grupos[#grupos+1]={nome='icones',fonte='elementos.png',largura=16,altura=16,pivo={0,0},animacoes={animacao('idle',1000,false,{celula(8,1),celula(8,3),celula(8,5),celula(8,7)})}}
grupos[#grupos+1]={nome='cenario',fonte='cenario.png',largura=480,altura=270,pivo={0,0},animacoes={animacao('idle',1000,false,{{0,0,1672,941}})}}
return grupos
