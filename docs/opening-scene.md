# Opening scene: "Hikayat Sungai Seri"

A narrated opening of about 2 minutes, staged as a **Malay wayang kulit shadow play**: flat puppet
cut-outs in front of a glowing screen (kelir), moved in layers (parallax, slow pans, puppets
sliding on and off), particles done in Godot (fog, embers, fireflies, dust), a narrator in the
manner of a storyteller, and subtitles. Everyone is a shadow, so no face is ever shown.

Version 2 (2026-11-21), matching `docs/lore.md` v2 and the approved structure in
`docs/game-design-proposed.md`:
- The cinematic tells the **world's history**: two worlds, the Batu Sempadan, the Four Guardians,
  the balance, the Ordo's arrival and the first nailed stone at the Kuala.
- It **does not** reveal Kelana, Si Raya, Tok Senik's secret or the Ordo's secrets.
- The player's kampung is **still at peace** when it ends. The burning kampung and Awang's capture
  happen at the end of the prologue, in game (see section 6).
- Batu Sempadan instead of keramat offerings; bound beings are victims; the Guardians are creatures
  of God, not gods; Islam is part of village life (azan subuh, surau) and is never shown as magic.

**Art style: wayang kulit** (chosen by leoxent, 2026-11-21, from five Gemini tests). The cinematic
is drawn in a different style from the pixel-art gameplay, on purpose. Images are made with
**Gemini**. We take only the **look** of wayang kulit: no deity or epic puppets (Seri Rama,
Hanuman and so on), no opening ritual (buka panggung), no dalang shown.

---

## 1. How to use the prompts

**Tool and size.** Generate with Gemini at 16:9 (or wider for pans), then scale to **1920x1080**.
Layers that pan are **2304 px wide** (1.2x the screen). Shadows are soft by nature, so upscaling a
little does not hurt.

**How a shot is built.** Every shot has the same three kinds of layer:
1. **The kelir**: one glowing screen image, made **once** and reused in every shot. Godot tints it
   per shot (gold at dawn, red for fire, cold blue at the Kuala).
2. **Cut-out strips**: landscape shapes (hills, river bank, forest) as wide shadow cut-outs.
3. **Puppets**: figures, creatures and objects as separate cut-outs, so Godot can move them.

**Transparent layers.** Gemini cannot make true transparency. Generate every cut-out on **flat
pure green (#00FF00)** and key the green out (or use a remove-background tool). Dark shadows on
green key cleanly.

**The look** (leoxent's chosen test prompt, kept word for word as the target):

> A scene inspired by Malay wayang kulit shadow puppetry: the figures, houses and palms are flat
> cut-out silhouettes with delicate punched lace-like patterns, in front of a glowing warm screen of
> orange and amber light, like a shadow play lit from behind by an oil lamp, with soft light falloff
> toward the edges.

Use test image C as a **style reference** in Gemini for every layer, so all shots match it.
No bamboo rods and no "photo of a real screen": the look is the clean one from test C.

**Style prefix for cut-outs and puppets.** Put this at the start of every cut-out prompt:

> Inspired by Malay wayang kulit shadow puppetry: a flat cut-out silhouette with delicate punched
> lace-like patterns, dark shadow colour, crisp edges, in the same style as the reference image.
> On a plain flat pure green (#00FF00) background, nothing else: no screen, no light, no ground.

**Ordo Sigillum look.** Malay shapes are curling and organic (vines, leaves, waves). Ordo shapes
are **stiff and geometric**: straight lines, square holes in a grid, iron rivets, no lace. Add to
every Ordo prompt:

> drawn in a stiff, angular cut-out style with straight lines, square grid holes and rivets, cold
> and mechanical, unlike the curling Malay shapes

**Coloured "light-through" pieces.** Some things are not shadows but light shining through thin
painted material (the hidden Bunian world, the bound beings). For these, replace "dark shadow
colour" in the prefix with:

> thin translucent painted cut-out with light shining through it, soft glowing colours

**Surau.** Every prompt that shows the surau adds:

> The surau has a two- or three-tiered pyramid roof (atap tumpang) with a small rounded finial on
> top, no spire, not a pagoda or temple.

**Rules for every prompt (put at the end):**

> No text, letters, writing or symbols anywhere in the image, no Arabic script. No modern objects:
> no zinc roofs, no rubber trees, no power lines. No visible faces.

**After generating:** check every image for fake writing or letter-like marks (Gemini adds them)
and remove them; check the surau is not a pagoda; give all images the same colour grade and a
little grain so they read as one set.

---

## 2. Shot list, narration and subtitles

The narration is in Malay, in the style of an old hikayat. English subtitles are optional (`EN`).
Timings are approximate.

| # | Shot | Time | Camera | Kelir tint |
|---|---|---|---|---|
| 1 | Subuh on Sungai Seri | 0:00–0:14 | slow pan right, light rises | pale gold to soft pink |
| 2 | Batu Sempadan, two worlds | 0:14–0:28 | slow push-in | green-gold |
| 3 | The Four Guardians | 0:28–0:48 | four puppet changes | teal, orange, deep green, pale gold |
| 4 | Pale sails at the Kuala | 0:48–1:00 | ships slide in | cold grey-blue |
| 5 | Si Mata Berpaku | 1:00–1:10 | emblem rises, nails strike | iron white |
| 6 | The first nail, at the Kuala | 1:10–1:26 | push-in, glow pulses | deep violet, red at the bottom edge |
| 7 | Upriver, the two of them | 1:26–1:42 | puppets walk along the bund | warm amber |
| 8 | Tok Senik's hut | 1:42–1:54 | static, lamp flicker | deep orange |
| 9 | The jetty, title | 1:54–2:08 | pull back, title fades in | dawn gold |

The player's look is chosen after the cinematic, so the shot 7 narration ("seorang abang ...
adiknya") and the silhouettes work for a younger brother or a younger sister.

### Narration and subtitles

**1. Subuh on Sungai Seri.** The sound of the azan subuh starts faintly before the first line.
> Alkisah, di hulu Sungai Seri, hari bermula dengan azan subuh... dan bau tanah sawah yang basah.
> `EN:` Long ago, upriver on the Seri, each day began with the dawn call to prayer... and the smell of wet rice fields.

**2. Batu Sempadan.**
> Orang tua-tua berpesan: kita berjiran dengan alam yang tak terlihat.
> Batu Sempadan menjadi tanda had. Mereka tak menceroboh kita, dan kita tak menceroboh mereka.
> `EN:` The elders taught that we live beside an unseen world. The boundary stones marked the line: they stay on their side, and we stay on ours.

**3. The Four Guardians.**
> Empat makhluk tua menjaga janji itu. Naga di Tasik Chini. Bujang Senang di kuala. Orang Bunian
> di rimba. Dan Puteri di puncak Ledang.
> Mereka juga makhluk ciptaan Tuhan, cuma lebih tua daripada ingatan kita. Selagi batu tak
> diusik, sungai mengalir jernih... dan padi menguning setiap musim.
> `EN:` Four old creatures kept that promise: the Naga of Tasik Chini, Bujang Senang at the river mouth, the Bunian in the forest, and the Puteri on Ledang's peak. They too were created by God, only older than our memory. While the stones stood untouched, the river ran clear... and the rice turned gold each season.

**4. Pale sails.**
> Sehinggalah datang kapal-kapal berlayar pucat... dari tanah yang sudah mereka perah hingga kering.
> `EN:` Until ships with pale sails came... from a land they had already squeezed dry.

**5. Si Mata Berpaku.**
> Ordo Sigillum. Bagi mereka, segala yang bernyawa boleh dimiliki. Segala yang bebas boleh dipaku.
> `EN:` The Ordo Sigillum. To them, every living thing could be owned, and anything free could be nailed down.

**6. The first nail.**
> Di kuala, Batu Sempadan yang pertama dipaku. Makhluk ditarik keluar dari alamnya sendiri...
> dan dikurung dalam tanglung besi. Kampung-kampung di hilir mula sunyi.
> `EN:` At the river mouth, the first boundary stone was nailed. Beings were dragged out of their own world... and caged in iron lanterns. The villages downriver began to fall silent.

**7. Upriver.**
> Tetapi di hulu, khabar itu belum sampai. Di sebuah kampung kecil, seorang abang masih membawa
> adiknya turun ke sawah... seperti ayah mereka dahulu.
> `EN:` But upriver, the news had not yet arrived. In a small village, an elder brother still took his younger sibling down to the rice fields... as their father once did.

**8. Tok Senik's hut.**
> Dan di hujung kampung, seorang tua masih menyimpan ilmu lama. Dia hanya mahu bertanya beberapa
> soalan... kepada kau.
> `EN:` And at the edge of the village, an old man still kept the old knowledge. He had a few questions to ask... of you.

**9. The jetty, title.**
> Kezaliman tak pernah kekal. Dan sungai ini... masih ingat siapa tuannya.
> `EN:` Tyranny never lasts. And this river... still remembers who it belongs to.
>
> *(Title fades in. The working title is "Sungai Seri" until a final name is chosen. The same
> line closes the epilogue, so the game begins and ends with it.)*

After the title: the lamp behind the kelir goes out (the screen fades to black), then Tok Senik's
questions begin in the game's own pixel style.

---

## 3. Image prompts, per shot

Each cut-out prompt comes **after** the style prefix (plus the Ordo, light-through and surau lines
where they apply) and **before** the rules. Sizes are final sizes after scaling.

### The kelir (made once, used in every shot)

| Layer | Size | Prompt (no style prefix, no green background) |
|---|---|---|
| K Kelir | 2304x1080 | An empty glowing warm screen of orange and amber light, like a shadow-play screen lit from behind by an oil lamp, brightest in the centre with soft light falloff toward the edges, a faint cloth texture. Nothing on the screen. |

Godot tints this per shot (see the shot list). Keep the amber version as the default (shots 1, 7,
8, 9); for the cold or dark shots, tint it, or generate a second, paler version that tints better.

### Shot 1: Subuh on Sungai Seri

| Layer | Size | Prompt |
|---|---|---|
| 1a Far hills | 2304x500 | a long strip of distant layered jungle hills with one taller mountain, the top edge cut in soft rounded tree shapes, few holes, as a far-away shadow |
| 1b Kampung bank | 2304x600 | a long strip of river bank: stilted wooden houses with steep thatched attap roofs, coconut palms and banana plants, a small wooden surau, the river shown as a few cut wavy lines along the bottom, punched patterns in the roofs and leaves |
| 1c Foreground | 2304x400 | a strip of tall reeds and grass with two drooping coconut fronds at the ends, large and close |

Godot: blur 1a slightly (further from the screen), fireflies fading out as the light rises.

### Shot 2: Batu Sempadan, two worlds

| Layer | Size | Prompt |
|---|---|---|
| 2a Forest | 2304x1080 | a deep rainforest strip: huge buttress-root trees and hanging vines framing an empty clearing in the middle |
| 2b Batu Sempadan (puppet) | 700x900 | an old standing stone, carved through with simple spiral and leaf patterns (no letters), roots and moss around its base, calm and ancient |
| 2c Hidden world (light-through) | 2304x900 | a delicate hidden village among trees: slender houses and glowing leaf shapes in pale green and gold, very light and dreamlike |
| 2d Foreground | 2304x400 | large fern and leaf shapes framing the bottom corners |

Godot: fade 2c in and out slowly behind 2a; fireflies.

### Shot 3: The Four Guardians

Four quick scene changes, about 5 seconds each, the way a dalang swaps puppets. The creatures are
shown as old and calm: not monsters, and nothing in them looks like an object of worship.

| Layer | Size | Prompt |
|---|---|---|
| 3w Water strip (shared) | 2304x400 | a strip of stylised water: rows of curling wave shapes, for the bottom of the screen |
| 3a Naga (puppet) | 1600x700 | a long serpent-like Malay naga with no legs and a small ornate crown (mahkota), its body in loose coils as if rising from a lake, lace-patterned scales, lotus shapes beside it |
| 3b Bujang Senang (puppet) | 1600x500 | an enormous old crocodile seen from the side, low and long, half sunk as if in water, ridged back scales cut as a pattern, calm |
| 3c Bunian (light-through) | 2304x1080 | many floating leaf-shaped lights in pale green and gold among two giant buttress trees, with the faint outline of a slender doorway between them |
| 3c Forest frame | 2304x1080 | two giant buttress-root trees at the left and right edges, an open gap between them |
| 3d Mountain (strip) | 2304x700 | a tall jungle mountain peak rising above rolling cloud shapes |
| 3d Puteri (puppet) | 400x700 | a slender woman standing, seen from behind, a long selendang flowing from her shoulders, simple and dignified, not a goddess or a court puppet |

Godot: waves rock gently in 3a and 3b; leaf lights drift in 3c; clouds slide in 3d.

### Shot 4: Pale sails at the Kuala

| Layer | Size | Prompt |
|---|---|---|
| 4a Sea strip | 2304x400 | a strip of flat sea with low regular wave shapes, cut in straight even lines |
| 4b Carracks (puppet, Ordo) | 1600x800 | three 15th-century carracks with tall square sails, high castles at bow and stern, the main sails cut through with a round seal shape that has an eye in the middle |
| 4c Coast | 2304x500 | a strip of mangrove coast at a river mouth, tangled roots, a few small fishing boats pulled up on the sand |

Godot: ships slide in from the right, sea fog particles drift across.

### Shot 5: Si Mata Berpaku

| Layer | Size | Prompt |
|---|---|---|
| 5a Emblem (puppet, Ordo) | 1000x1000 | a round seal with a single open eye cut through its centre, long iron nails driven in all around it pointing inward, two stiff wings at the sides, menacing |
| 5b Nail (puppet, Ordo) | 300x300 | a single long iron nail, square-headed, slightly bent |

Godot: the emblem rises from below; copies of the nail fly in and "strike" one by one, each with a
screen shake and a dust puff.

### Shot 6: The first nail, at the Kuala

| Layer | Size | Prompt |
|---|---|---|
| 6a Shore and fort (Ordo) | 2304x700 | a river-mouth shore with a new square stone fort, flat walls, square towers and stiff banners, on the left; mangrove roots on the right; a low row of distant hills |
| 6b Nailed stone (puppet) | 700x900 | the same carved standing stone as shot 2, now with a large square-headed iron nail driven into it, chains around it, cracks cut across its patterns |
| 6c Bound beings (light-through) | 1000x700 | three or four pale, faint, shapeless beings being pulled by thin chains into an iron lantern, shapes only, no faces, sad and helpless rather than scary |
| 6d Soldiers (optional, Ordo) | 1200x500 | a few small soldiers with pikes, and one tall figure in a long robe holding up a lantern, far away and tiny |

The robed figure is only a hint and is never named. Leave it out if it draws too much attention.
Godot: a dark violet glow pulses from the nail (additive light); the red at the bottom edge of the
kelir is a burning village far upriver.

### Shot 7: Upriver, the two of them

| Layer | Size | Prompt |
|---|---|---|
| 7a Kampung strip | 2304x600 | a kampung behind rice fields: stilted thatched houses, coconut palms and a small surau, peaceful |
| 7b Sawah strip | 2304x400 | rice paddies with a long raised earth bund running across, young rice plants cut as small upright shapes |
| 7c Siblings (puppets) | 900x700 | two puppets walking, side view: a taller young man in front with a sabit (curved rice sickle) on his shoulder, his head turned back as if joking, and a smaller younger person a few steps behind carrying a bundle of rice stalks, both in sarong and simple baju |

Godot: the two puppets move along the bund with a slight bob, the way a dalang walks puppets; birds
cross. This is the first and only time Awang is shown in the cinematic, always a little **ahead**
of the player (see `game-design-proposed.md`, Awang's absence).

### Shot 8: Tok Senik's hut

| Layer | Size | Prompt |
|---|---|---|
| 8a Hut interior | 2304x1080 | the inside of a simple wooden hut: roof beams, bundles of dried herbs and roots hanging, clay jars along the floor, a woven mat wall pattern |
| 8b Old man (puppet) | 600x800 | a thin old man seated cross-legged, simple headcloth, one arm raised as if speaking (cut the raised arm as a separate piece so it can move) |
| 8c Youth (puppet) | 500x700 | a young person seated, seen from behind, facing left, plain clothes |
| 8d Pelita (puppet) | 250x250 | a small clay oil lamp (pelita) with an empty space where the flame would be |

Godot: the flame is a light, not part of the image; the kelir brightness flickers with it; Tok
Senik's arm moves slightly as he speaks.

### Shot 9: The jetty, title

| Layer | Size | Prompt |
|---|---|---|
| 9a River strip | 2304x500 | a wide calm river shown as long gentle wave lines, a distant forest bank, a small perahu far away |
| 9b Jetty and siblings | 1400x700 | a simple wooden jetty on stilts reaching into the river, two young people sitting side by side at its end, seen from behind, legs over the edge, looking upriver, a cloth sash lifting in the wind |
| 9b-alone | 1400x700 | the same jetty with **one** young person sitting alone at its end (used later in game, after Awang is taken: the mirror shot) |
| 9c Foreground | 2304x400 | coconut palm fronds hanging into the top corners |
| 9d Title frame (puppet) | 1300x400 | an ornate frame of carved leaf and vine patterns (ukiran), cut like a puppet, empty in the middle for the title text |

Write the title text in Godot with a font, not in the picture, so it can change later.

---

## 4. Sound

| Kind | What |
|---|---|
| Narrator | One calm, dignified older male voice in Malay, telling it like an old storyteller (the 9 lines above). Speak slowly, with pauses at the "...". |
| Azan subuh | Use a **real, respectful recording** with a licence that allows it. Play it soft and distant. Never cut it off abruptly or put it under action sounds: let it fade out naturally before shot 2. |
| Music | Traditional Malay instruments that fit a shadow play: serunai, gendang, geduk, gong, kesi. Shots 1–3 soft and slow; shots 4–6 darker, low gong and drums; shots 7–9 warm and hopeful. |
| Effects | River and birds (1), forest night (2), water and wind per guardian (3), waves and creaking wood (4), metal nail strikes (5), deep water and chains (6), padi in the breeze and a laugh far off (7), lamp crackle (8), wind and water (9), the soft rustle of hide each time a puppet enters. |

---

## 5. Building it in Godot

- **Resolution.** The game renders at 640x360. The cinematic is not pixel art, so it must render at
  the **window's own resolution** (e.g. its own `CanvasLayer` or `SubViewport` at 1920x1080),
  otherwise the images get squeezed to 640x360 and look blurry and pixelated. (Code work for later.)
- **The kelir:** one sprite behind everything; tint it per shot with `modulate`, and flicker its
  brightness a little like an oil lamp.
- **Depth:** a `Parallax2D` per layer, scroll scale from far (0.1) to near (1.2). Layers further
  from the screen are **slightly blurred and larger**, as real shadows are; near layers are sharp.
- **Puppets:** small sways and bobs (tweens), slide on and off from the sides like a shadow play.
- **Particles:** fireflies, embers, fog and dust with `CPUParticles2D`, kept soft so they read as
  light on the screen.
- **Subtitles:** a `Label` at the bottom with a dark half-transparent band, fading in and out with
  each narration line. Keep the Malay and English text in a CSV so they can be translated.
- **Skip:** any key skips to the title. Show "Tekan sebarang kekunci untuk langkau" after 3 seconds.
- **The end:** the lamp goes out, fade to black, then the game's pixel art starts (Tok Senik's
  questions). The black gap makes the style change feel deliberate.
- The whole scene plays once on a new game. It can be replayed from the main menu.

---

## 6. Moved out of the cinematic: the prologue climax (day 3)

The burning kampung, the nail in the swamp and the withered sawah belong to the **end of the
prologue**, where the player is present. Do most of it in-engine with the game's pixel sprites. If
a few strong moments need still pictures, make them in the same wayang style with a **red** kelir,
so they echo the opening:

| Still | Size | Prompt |
|---|---|---|
| Burning kampung | 2304x700 | stilted thatched houses with flame shapes rising from the roofs, curling smoke shapes above |
| Soldiers and Kelana (Ordo) | 1600x600 | a line of soldiers with pikes and crossbows, and one figure in a long robe holding up a lantern |
| Awang taken (puppet) | 900x700 | a young man with his hands bound, held by two soldiers with pikes (Ordo style), his head still raised, looking back |
| The nail in the swamp | 700x900 | reuse 6b, with a mangrove strip behind |
| Under the water (puppet) | 1600x500 | an enormous crocodile low in the water, with an iron nail through its jaw |
| Withered sawah | 2304x400 | rice paddies with broken bunds and drooping, dead rice plants |

Kelana is only a robed shadow; he speaks one line (from `lore.md`), and Tok Senik names him
afterwards.
