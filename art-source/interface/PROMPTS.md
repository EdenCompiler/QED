# Prompts dos assets da interface

Modo: ferramenta integrada `image_gen`. Originais preservados em `art-source/interface/`.

## Molduras

```text
Use case: stylized-concept. Asset type: production UI skin atlas for QED, a serious dark fantasy side-scrolling pixel-art RPG about proving theorems.
Use the supplied forest/ruins image as COLOR AND MATERIAL reference only. Generate UI assets, not a screenshot or concept mockup.
Create exactly SIX perfectly front-facing SQUARE interface panels arranged in a regular 3-column by 2-row grid on a genuinely transparent background. Requested canvas 1536x1024. All six panels identical outer dimensions, each centered in its cell with 32px empty margins. None overlap. No labels, no letters, no numbers, no UI text.
Style: exquisite restrained medieval arcane craftsmanship, aged bronze and blackened iron, subtle chiseled angular ornaments at the corners, engraved hairline borders, low-contrast midnight blue leather or stone interiors. Crisp controlled pixel-art-inspired edges and material highlights, serious atmospheric fantasy matching the reference, no cartoon styling, no glossy mobile-game bubbles.
All panels MUST have a large EMPTY opaque dark interior for legible cream text. Ornaments strictly in corners and thin perimeter bands. Straight uninterrupted central edge sections and nearly flat interiors so panels work as nine-slice scalable game widgets. Symmetric rectangular bounds, no protruding decorations, no drop shadows outside the bounds.
Grid order:
row 1 col 1: main window frame, aged bronze edge, deep desaturated navy interior.
row 1 col 2: grimoire/editor frame, antique bronze clasps in corners, blue-black vellum interior, very subtle wear, no writing.
row 1 col 3: dormant ontology node, tarnished iron edge, charcoal-blue interior, understated.
row 2 col 1: unlocked ontology node, oxidized bronze edge with tiny muted jade inlays at corners, dark teal interior.
row 2 col 2: selected ontology node, warm illuminated gold edge with tiny amber inlays, dark navy interior, readable and restrained.
row 2 col 3: button frame, bronze beveled edge and dark indigo leather interior.
Important: six actual usable texture assets, no surrounding scene, no text or emblems in the centers, transparency outside each panel, preserve the exact regular grid.
```

## Selos de ontologia

```text
Use case: stylized-concept. Production game UI ICON ATLAS for QED, serious medieval arcane fantasy. Reference image defines bronze materials and dark colors.
Generate exactly TWELVE individual square medallion icons in a perfectly regular 4-column by 3-row grid, requested canvas 1536x1152. Each icon has same visual size, occupies central 70% of its square cell with wide empty margins, fully isolated from all neighbors. Genuinely transparent background, no checkerboard painted into the image. No words, letters, numbers or labels. Front-facing orthographic icons, no perspective.
Each icon is an ornate but readable bronze circular seal enclosing one powerful central symbol on almost black midnight-blue enamel. Chunky deliberate shapes with fine pixel-art-inspired material shading, readable at 40x40 game pixels. Restrained cyan, amber and jade highlights, serious fantasy, no cute faces, no flat vector art, no neon, no modern technology, no outward particles.
Grid EXACT ORDER from left to right:
row1: 1 eye centered on an angular crystal (Existence); 2 ancient compass rose with a cyan needle (Space); 3 golden oak branch and emerald leaf over a rough stone (Matter); 4 steel sword over dark shield (Conflict).
row2: 5 luminous water droplet split between liquid and ice (States); 6 heavy warhammer striking a cracked metal plate, static amber impact line (Impact); 7 elongated blue crystal in bronze prongs (Affinity); 8 two bronze links joined through a cyan droplet (Conduction).
row3: 9 forked lightning bolt on dark indigo enamel (Storm); 10 open ancient grimoire with a geometric joining symbol but no text (Composition); 11 closed iron padlock (Locked); 12 a bright amber octahedral knowledge crystal (Knowledge point).
Do not connect icons or place elements outside their individual cells. Consistent enclosing bronze medallion silhouette, complete circular frames visible, very clear distinct symbols. These are final game assets, not a sheet of concept sketches.
```

## Fundo

```text
Use case: stylized-concept. Production background texture for QED's full-screen ONTOLOGY TREE and desktop RPG menus. Use the supplied assets as material and palette reference. Make a 16:9 landscape texture, requested 1536x864. Opaque image, not transparent.
A very dark midnight-blue ancient scholar's worktable, weathered charcoal leather and slate with barely visible engraved geometric arcs, subtle interconnected constellation dots and philosophical diagram rings around the periphery. A few restrained worn bronze hairlines close to the outer corners. Serious atmospheric arcane fantasy, intricate hand-painted pixel-art-inspired material texture, controlled crisp edge highlights matching dark forest ruins and bronze armor.
This texture will sit behind readable text, node buttons and lines. Strong usability constraints: central 85% must be extremely low contrast and sparse, luminosity kept around #0B121C to #15222D, corners only slightly brighter; no bright focal object, no large central emblem, no legible text, no alphabet letters, no numbers, no panels or UI mockup elements, no interface controls. Soft light from upper left, subtle depth through material, no vignette that becomes pure black, no glowing neon. This is the actual quiet reusable canvas for a game UI, not an illustration of a room.
```
