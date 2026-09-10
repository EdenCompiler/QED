# Referências profissionais e revisão dos sprites

Pesquisa realizada em 9 de setembro de 2026. Os exemplos são referências de
análise; nenhum sprite de terceiros foi incorporado aos assets de QED.

| Fonte original | O que observar | Aplicação em QED |
|---|---|---|
| [Oscar Mardones Ruiz — animações de Blasphemous](https://daeron.artstation.com/projects/nQloP1) | Ciclo de caminhada de Golden Corpse; repouso e queda de Spear of the Cathedra; arremesso de Carthos. Silhuetas, apoio dos pés, dobras grandes e contraste dos materiais. | Transferir peso entre pernas; dobrar joelhos antes da queda; mover torso e equipamento como partes articuladas. |
| [Gwenaël Massé, Motion Twin — direção de arte de Dead Cells](https://www.gamedeveloper.com/production/art-design-deep-dive-giving-back-colors-to-cryptic-worlds-in-i-dead-cells-i-) | Relação entre paleta, volumes, cenário e leitura da ação. O autor descreve separação dos elementos importantes e profundidade por cor e paralaxe. | Destacar personagens do fundo; reservar os valores mais claros para metal e magia; usar sombras frias e planos intermediários. |
| [Pedro Medeiros — AttackSheet](https://github.com/saint11/Saint11Tutorials/blob/master/AttackSheet.gif) | Estudo de ataque em pixel art. | Planejar antecipação, aceleração, contato e recuperação; usar um arco de corte somente nos quadros rápidos. |
| [Pedro Medeiros — Fabric](https://github.com/saint11/Saint11Tutorials/blob/master/Fabric.gif) e [Easings](https://github.com/saint11/Saint11Tutorials/blob/master/Easings.gif) | Estudos de tecido e variação do movimento. | A capa acompanha o corpo com atraso; a distância entre poses varia ao longo do gesto. |

## Diagnóstico da primeira exportação

O tronco permanecia quase idêntico durante ataques e coleta. A arma trocava de
ângulo, mas quadril, ombros e apoio das pernas não justificavam a força do
golpe. A morte transformava o mesmo desenho por rotação e compressão. No
slime, sombras triangulares produziam uma massa sem volume convincente.

## Critérios desta revisão

- Cada golpe precisa mudar a silhueta inteira e mostrar preparação e recuperação.
- Caminhada precisa alternar contato, compressão e passagem da perna, com
  movimento oposto dos braços e da capa.
- O torso deve ter planos iluminados e sombra projetada sob elmo e ombreiras.
- Metal usa reflexos pequenos e intensos; tecido usa faixas maiores de luz;
  o slime usa brilho deslocado e massa deformável.
- Conferir os ciclos em velocidade normal, pausados por quadro e no renderer.
- Comparar cada nova versão com os defeitos registrados antes de substituir os exports.

Estas são decisões de aplicação ao projeto, não uma afirmação de equivalência
de qualidade com as produções de referência.

## Mudança de produção

Após revisar as versões desenhadas por código, o usuário solicitou geração
de imagem para os assets finais. O pipeline atual está em `ARTE.md`.
O estudo acima permanece como histórico dos critérios de análise.
