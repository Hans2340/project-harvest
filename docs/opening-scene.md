# Opening scene: "Hikayat Sungai Seri"

A narrated opening of about 2 minutes: layered pictures that move (parallax, slow pans and zooms),
particles done in Godot (fog, embers, rain, fireflies, dust), a narrator, and subtitles.
People are **silhouettes** or are not shown. The player's face is never shown.

Version 2 (2026-11-21), matching `docs/lore.md` v2 and the approved structure in
`docs/game-design-proposed.md`:
- The cinematic tells the **world's history**: two worlds, the Batu Sempadan, the Four Guardians,
  the balance, the Ordo's arrival and the first nailed stone at the Kuala.
- It **does not** reveal Kelana, Si Raya, Tok Senik's secret or the Ordo's secrets.
- The player's kampung is **still at peace** when it ends. The burning kampung and Awang's capture
  happen at the end of the prologue, in game (see section 6).
- Batu Sempadan instead of keramat offerings; bound beings are victims; the Guardians are creatures
  of God, not gods; Islam is part of village life (azan subuh, surau) and is never shown as magic.

---

## 1. How to use the prompts

**Size.** The game is 640x360. Draw each layer at **2x (1280x720)** so it stays sharp when
scaled. Draw layers that pan **wider than the screen** (the width is given per layer).

**Layers.** Every layer except the sky is **one separate image with a transparent background**,
so Godot can move it at its own speed (far = slow, near = fast).

**Style prefix.** Put this at the start of **every** image prompt:

> pixel art, dark muted painterly palette, inspired by Stoneshard, 15th-century Malay Nusantara,
> soft dithering, limited colour palette, cinematic, no text, no letters, no watermark

**Silhouette rule.** Put this in every prompt that has a person in it:

> people shown only as solid near-black silhouettes with a thin warm rim light, no faces visible

**Transparent layers.** Add this to every layer except the sky:

> isolated on a transparent background, nothing behind it

**Not allowed in any image:** Quran verses or any Arabic writing, real logos, modern objects
(rifles, rubber trees, cassava, zinc roofs), and gore.

---

## 2. Shot list, narration and subtitles

The narration is in Malay, in the style of an old hikayat. English subtitles are optional (`EN`).
Timings are approximate.

| # | Shot | Time | Camera |
|---|---|---|---|
| 1 | Subuh on Sungai Seri | 0:00–0:14 | slow pan right, sun rises |
| 2 | Batu Sempadan, two worlds | 0:14–0:28 | slow push-in |
| 3 | The Four Guardians | 0:28–0:48 | four slow cross-fades |
| 4 | Pale sails at the Kuala | 0:48–1:00 | ships slide in, fog drifts |
| 5 | Si Mata Berpaku | 1:00–1:10 | zoom on the emblem, nails strike |
| 6 | The first nail, at the Kuala | 1:10–1:26 | push-in, black glow pulses |
| 7 | Upriver, the two of them | 1:26–1:42 | slow pan along the bund |
| 8 | Tok Senik's hut | 1:42–1:54 | static, lamp flicker |
| 9 | The jetty, title | 1:54–2:08 | pull back, title fades in |

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

After the title: fade to Tok Senik's questions (his voice, the hut from shot 8 behind the menu).

---

## 3. Image prompts, per shot

Each prompt below comes **after** the style prefix (and the silhouette and transparent rules
where they apply). Sizes are at 2x.

### Shot 1: Subuh on Sungai Seri

| Layer | Size | Prompt |
|---|---|---|
| 1a Sky | 1600x720 | pre-dawn sky over a tropical river valley, deep indigo at the top fading to soft orange and pink at the horizon, a few thin clouds lit from below, last faint stars |
| 1b Far hills | 1800x400 | distant layered jungle hills in misty blue-grey silhouette, one taller mountain far away, soft haze, transparent above the ridgeline |
| 1c River and sawah | 1800x360 | a calm wide brown river reflecting the dawn sky, flooded rice paddies with low earth bunds along the near bank, thin morning mist on the water |
| 1d Kampung | 1600x420 | a small Malay kampung in silhouette: stilted wooden houses with steep thatched attap roofs, coconut palms, a small wooden surau with a tiered roof, one warm oil-lamp glow in a window |
| 1e Foreground | 1800x300 | dark foreground reeds and tall grass, a few drooping coconut fronds at the edges, nearly black with a faint warm rim light |

### Shot 2: Batu Sempadan, two worlds

| Layer | Size | Prompt |
|---|---|---|
| 2a Background forest | 1400x720 | deep tropical rainforest at dusk, huge buttress-root trees, hanging vines, layered green-blue mist, shafts of soft light |
| 2b Batu Sempadan | 600x600 | an old weathered standing stone in a forest clearing, carved with simple worn spiral and leaf patterns (no letters), moss and roots around its base, calm and ancient |
| 2c Hidden world | 1400x720 | a faint ghostly overlay of a hidden village among the trees: delicate pale-green and gold houses, glowing leaf shapes, very translucent and dreamlike, as if half seen |
| 2d Foreground | 1400x320 | dark ferns and big leaves framing the bottom corners, almost black |

Godot: fireflies, and fade layer 2c in and out slowly.

### Shot 3: The Four Guardians

Four panels, about 5 seconds each, cross-faded. Each panel is 1280x720 with two layers (back and
front) so it can drift slightly. Keep the creatures **half hidden**: they are shown as old and
calm, not as monsters and not as something to bow to.

| Layer | Size | Prompt |
|---|---|---|
| 3a Lake, back | 1400x720 | a still dark jungle lake at dawn, lotus pads and pink lotus flowers, mist over the water, forested hills behind |
| 3a Naga, front | 1200x400 | a long serpent-like Malay naga with no legs and a small ornate crown (mahkota), mostly under the water, only a curve of scaled back and the crown above the surface, teal and copper scales |
| 3b River mouth, back | 1400x720 | a mangrove river mouth at dusk, wide brown water meeting the sea, orange sky |
| 3b Crocodile, front | 1200x300 | an enormous old crocodile almost fully under the water, only its eyes, snout tip and a long ridge of back scales above the surface, calm |
| 3c Forest, back | 1400x720 | deep rainforest at night, huge buttress roots, a gap in the trees with soft light |
| 3c Bunian lights, front | 1400x720 | many small floating pale-green and gold leaf-shaped lights among the roots, and the faint outline of a delicate hidden doorway between two trees, very translucent |
| 3d Mountain, back | 1400x720 | the misty peak of a tall jungle mountain above a sea of clouds, early morning, pale gold light |
| 3d Puteri, front | 500x500 | a small, far-off female silhouette standing on a rock ledge near the peak, a long selendang moving in the wind, seen from behind, no face |

Godot: slow drift per panel; ripples on 3a and 3b; floating leaf lights on 3c; moving cloud sea on 3d.
Art budget: 3c can reuse the light shapes from 2c.

### Shot 4: Pale sails at the Kuala

| Layer | Size | Prompt |
|---|---|---|
| 4a Sky and sea | 1600x720 | grey overcast sky over a river mouth opening to the sea, cold pale light, a flat silver sea |
| 4b Ships | 1200x500 | three 15th-century carracks with tall pale bone-white sails, dark hulls, a black round seal sigil painted on the main sail, seen from the side at a distance |
| 4c Coast | 1800x360 | a mangrove-lined river mouth in dark silhouette, a few fishing boats pulled up on the sand |
| 4d Fog | 1800x360 | soft drifting sea fog bands, white and semi-transparent |

### Shot 5: Si Mata Berpaku

| Layer | Size | Prompt |
|---|---|---|
| 5a Background | 1280x720 | a dark stone wall lit by torchlight, cold grey and iron tones |
| 5b Emblem | 700x700 | a round iron seal with a single open eye in the centre, iron nails driven in all around it pointing inward, two wings at the sides, bone-white and iron-grey with a black seal mark, menacing |
| 5c Nails | 4 images, 160x160 each | a single long black iron nail, slightly rusted, at four angles |

Godot: each nail slides in and "strikes", with a shake and a dust puff.

### Shot 6: The first nail, at the Kuala

| Layer | Size | Prompt |
|---|---|---|
| 6a Background | 1400x720 | a river mouth at night, a new square stone fort with bone-white banners on the shore, cold moonlight, fog on the water, a faint red glow of a distant burning village far upriver on the horizon |
| 6b Nailed stone | 600x600 | the same carved standing stone as shot 2, now with a large black iron nail driven into it and a black round seal mark burned into the surface, chains around it, cracks spreading |
| 6c Seal glow | 600x600 | a black and deep violet glow in the shape of a round seal, soft edges, for an additive glow |
| 6d Bound beings | 800x500 | three or four faint translucent pale shapes being pulled into an iron lantern by thin chains, shapes only, no faces, sad and helpless rather than scary |
| 6e Soldiers (optional) | 1000x400 | a few small soldier silhouettes with pikes beside the stone, and one tall figure in a long robe holding an iron lantern, far away and tiny, no face |

The robed figure is only a hint and is never named here. Leave it out if it draws too much
attention.

### Shot 7: Upriver, the two of them

| Layer | Size | Prompt |
|---|---|---|
| 7a Sky | 1600x720 | a warm late-afternoon sky over a river valley, soft gold and peach, a few slow clouds |
| 7b Sawah | 1800x400 | green and gold rice paddies with earth bunds, a small kampung with stilted thatched houses and coconut palms behind, peaceful |
| 7c Siblings | 1000x420 | two silhouettes walking home along a narrow earth bund between rice paddies: a taller young man in front with a sabit (curved rice sickle) on his shoulder, turning his head back as if joking, and a smaller younger person a few steps behind carrying a bundle of rice stalks |
| 7d Foreground | 1800x300 | rice stalks and a wooden fence post in the near foreground, almost black |

Godot: a slow pan that keeps pace with the two, birds crossing, a soft breeze in the padi.
This is the first and only time Awang is shown in the cinematic: always a little **ahead** of
the player (see `game-design-proposed.md`, Awang's absence).

### Shot 8: Tok Senik's hut

| Layer | Size | Prompt |
|---|---|---|
| 8a Interior | 1280x720 | the inside of a simple wooden kampung hut at night, woven mat walls, bundles of dried herbs and roots hanging from the beams, clay jars, warm orange light from a small oil lamp |
| 8b Old man | 500x500 | an old man seated cross-legged in silhouette, thin, wearing a simple headcloth, one hand raised as if speaking, warm rim light from the lamp |
| 8c Youth | 400x500 | a young person seen from behind in silhouette, seated facing the old man, face not visible, plain clothes |
| 8d Lamp | 200x200 | a small clay oil lamp (pelita) with a flame, on a wooden floor |

Godot: the lamp flame flickers, and the shadows breathe with it.

### Shot 9: The jetty, title

| Layer | Size | Prompt |
|---|---|---|
| 9a Sky | 1600x720 | a clear dawn sky over a wide river, gold and pale blue, hopeful light |
| 9b River | 1800x360 | a wide calm river with gold reflections, a distant forest bank, a small perahu far away |
| 9c Jetty and siblings | 1000x500 | a simple wooden jetty on stilts reaching into the river, two young people sitting side by side at its end in silhouette, seen from behind, legs over the edge, looking upriver, a cloth sash moving in the wind |
| 9d Foreground | 1800x300 | dark coconut palm fronds framing the top corners |
| 9e Title frame | 900x260 | an ornate frame in carved wood and gold with Malay woodcarving (ukiran) leaf patterns, empty in the middle for the title text, transparent background |

Write the title text itself in Godot with a font, not in the picture, so it can change later.
Also draw **9c-alone**: the same jetty with **one** silhouette. It is used later, after Awang is
taken (the mirror shot).

---

## 4. Sound

| Kind | What |
|---|---|
| Narrator | One calm, dignified older male voice in Malay, old hikayat style (the 9 lines above). Speak slowly, with pauses at the "...". |
| Azan subuh | Use a **real, respectful recording** with a licence that allows it. Play it soft and distant. Never cut it off abruptly or put it under action sounds: let it fade out naturally before shot 2. |
| Music | Shots 1–3: soft and traditional (seruling, gambus, rebana). Shots 4–6: darker, with low drums. Shots 7–9: warm and hopeful. |
| Effects | River and birds (1), forest night (2), lake, water and wind per guardian panel (3), waves and creaking wood (4), metal nail strikes (5), deep water and chains (6), padi in the breeze and a laugh far off (7), lamp crackle (8), wind and water (9). |

---

## 5. Building it in Godot

- One scene per shot, or one scene with an `AnimationPlayer` track per shot.
- **Parallax:** a `Parallax2D` per layer, with the scroll scale rising from far (0.1) to near (1.2).
  Move the camera along a path, or tween each layer's offset.
- **Particles:** fireflies, embers, rain, fog and dust in Godot with `CPUParticles2D`. They need
  no drawn assets beyond a small dot or soft-blob texture.
- **Subtitles:** a `Label` at the bottom with a dark half-transparent band, fading in and out with
  each narration line. Keep the Malay and English text in a CSV so they can be translated.
- **Skip:** any key skips to the title. Show "Tekan sebarang kekunci untuk langkau" after 3 seconds.
- The whole scene plays once on a new game. It can be replayed from the main menu.

---

## 6. Moved out of the cinematic: the prologue climax (day 3)

The v1 shots "The kampung burns", "The nail in the swamp" and "Withered sawah, the long line" now
belong to the **end of the prologue**, where the player is present. Do most of it in-engine with
the game sprites (the player is there, so it should feel like the same world), plus a few painted
stills for the strongest moments. Prompts kept for those stills:

| Still | Size | Prompt |
|---|---|---|
| Burning kampung, sky | 1600x720 | night sky glowing red-orange from fires below, smoke clouds lit from beneath |
| Burning houses | 1800x480 | stilted Malay houses with thatched roofs burning, flames and smoke, the houses in dark silhouette against the fire |
| Soldiers and Kelana | 1400x420 | a line of soldier silhouettes with pikes and crossbows, open-faced helmets and tabards, one figure in a long grey robe holding up an iron lantern with a trapped blue-white glow inside, his face in shadow |
| Awang taken | 1000x420 | a young man in silhouette with his hands bound, held by two soldiers with pikes, his head still raised, looking back toward the viewer |
| The nail in the swamp | 600x600 | reuse 6b and 6c from shot 6, with a dark mangrove swamp behind |
| Under the water | 1600x400 | the faint shape of an enormous crocodile under dark water, only the long outline and a ridge of back scales visible, with an iron nail glinting near its jaw |
| Withered sawah | 1800x400 | rice paddies with withered brown and grey rice stalks, broken bunds, puddles reflecting a grey sky |

Kelana is shown only as a robed silhouette with his face in shadow. He speaks one line (from
`lore.md`); Tok Senik names him afterwards.
