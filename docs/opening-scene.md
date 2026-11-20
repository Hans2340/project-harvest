# Opening scene: "Hikayat Sungai Seri"

A narrated opening of about 2 minutes: layered pictures that move (parallax, slow pans and zooms),
particles done in Godot (fog, embers, rain, fireflies, dust), a narrator, and subtitles.
People are **silhouettes** or are not shown. The player's face is never shown.

Based on the "safe" lore (2026-11-21): Batu Sempadan instead of keramat offerings; bound beings are
victims; Islam is part of village life (azan subuh, surau) and is never shown as magic.

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

The narration is in Malay. English subtitles are optional (`EN`). Timings are approximate.

| # | Shot | Time | Camera |
|---|---|---|---|
| 1 | Subuh on Sungai Seri | 0:00–0:14 | slow pan right, sun rises |
| 2 | Batu Sempadan, two worlds | 0:14–0:28 | slow push-in |
| 3 | Pale sails at the Kuala | 0:28–0:42 | ships slide in, fog drifts |
| 4 | Si Mata Berpaku | 0:42–0:52 | zoom on the emblem, nails strike |
| 5 | The kampung burns | 0:52–1:08 | pan left, embers rise |
| 6 | The nail in the swamp | 1:08–1:22 | push-in, black glow pulses |
| 7 | Withered sawah, the long line | 1:22–1:36 | slow pan, rain begins |
| 8 | Tok Senik's hut | 1:36–1:50 | static, lamp flicker |
| 9 | Dawn on the jetty, title | 1:50–2:05 | pull back, title fades in |

### Narration and subtitles

**1. Subuh on Sungai Seri.** The sound of the azan subuh starts faintly before the first line.
> Di hulu Sungai Seri, hari bermula dengan azan subuh... dan bau tanah sawah yang basah.
> `EN:` Upriver on the Seri, each day began with the dawn call to prayer... and the smell of wet rice fields.

**2. Batu Sempadan.**
> Orang tua-tua berpesan: kita berjiran dengan alam yang tak terlihat.
> Batu Sempadan menjadi tanda had. Mereka tak menceroboh kita, dan kita tak menceroboh mereka.
> `EN:` The elders taught that we live beside an unseen world. The boundary stones marked the line: they stay on their side, and we stay on ours.

**3. Pale sails.**
> Sehinggalah datang kapal-kapal berlayar pucat... dari tanah yang sudah mereka perah hingga kering.
> `EN:` Until ships with pale sails came... from a land they had already squeezed dry.

**4. Si Mata Berpaku.**
> Ordo Sigillum. Bagi mereka, segala yang bernyawa boleh dimiliki. Segala yang bebas boleh dipaku.
> `EN:` The Ordo Sigillum. To them, every living thing could be owned, and anything free could be nailed down.

**5. The kampung burns.**
> Padi kami dicukai. Kerbau kami dirampas. Yang membantah, dibakar rumahnya.
> `EN:` Our rice was taxed, our buffalo taken. Those who spoke up had their houses burned.

**6. The nail in the swamp.**
> Lalu mereka memaku Batu Sempadan... dan menarik makhluk-makhluk dari alam mereka sendiri, untuk dijadikan hamba.
> `EN:` Then they nailed the boundary stones... and dragged the unseen folk out of their own world, to make them slaves.

**7. Withered sawah.**
> Sawah layu dalam semalam. Anak-anak kampung diangkut ke lombong di hulu... dan ramai yang tak pulang.
> `EN:` The fields withered overnight. Our young were taken to the mines upriver... and many never came back.

**8. Tok Senik's hut.**
> Tetapi di hujung kampung, seorang tua masih menyimpan ilmu lama. Dia hanya mahu bertanya beberapa soalan... kepada kau.
> `EN:` But at the edge of the village, an old man still kept the old knowledge. He had a few questions to ask... of you.

**9. Dawn on the jetty.**
> Kezaliman tak pernah kekal. Dan sungai ini... masih ingat siapa tuannya.
> `EN:` Tyranny never lasts. And this river... still remembers who it belongs to.
>
> *(Title fades in. The working title is "Sungai Seri" until a final name is chosen.)*

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

### Shot 3: Pale sails at the Kuala

| Layer | Size | Prompt |
|---|---|---|
| 3a Sky and sea | 1600x720 | grey overcast sky over a river mouth opening to the sea, cold pale light, a flat silver sea |
| 3b Ships | 1200x500 | three 15th-century carracks with tall pale bone-white sails, dark hulls, a black round seal sigil painted on the main sail, seen from the side at a distance |
| 3c Coast | 1800x360 | a mangrove-lined river mouth in dark silhouette, a few fishing boats pulled up on the sand |
| 3d Fog | 1800x360 | soft drifting sea fog bands, white and semi-transparent |

### Shot 4: Si Mata Berpaku

| Layer | Size | Prompt |
|---|---|---|
| 4a Background | 1280x720 | a dark stone wall lit by torchlight, cold grey and iron tones |
| 4b Emblem | 700x700 | a round iron seal with a single open eye in the centre, iron nails driven in all around it pointing inward, two wings at the sides, bone-white and iron-grey with a black seal mark, menacing |
| 4c Nails | 4 images, 160x160 each | a single long black iron nail, slightly rusted, at four angles |

Godot: each nail slides in and "strikes", with a shake and a dust puff.

### Shot 5: The kampung burns

| Layer | Size | Prompt |
|---|---|---|
| 5a Sky | 1600x720 | night sky glowing red-orange from fires below, smoke clouds lit from beneath |
| 5b Burning houses | 1800x480 | stilted Malay houses with thatched roofs burning, flames and smoke, the houses in dark silhouette against the fire |
| 5c Soldiers | 1400x420 | a line of soldier silhouettes with pikes and crossbows, open-faced helmets and tabards, one figure in a long robe holding up an iron lantern with a trapped blue-white glow inside |
| 5d Villagers | 1200x380 | kneeling and fleeing villager silhouettes in sarongs, a buffalo being led away by a rope, all solid black with a warm fire rim light |
| 5e Foreground | 1800x300 | dark fence posts and banana leaves in the near foreground, almost black |

Godot: embers rising, flicker on the fire glow, and pulse the lantern's glow.

### Shot 6: The nail in the swamp

| Layer | Size | Prompt |
|---|---|---|
| 6a Swamp background | 1400x720 | a dark mangrove swamp at night, twisted roots, still black water, cold moonlight, fog |
| 6b Defiled stone | 600x600 | the same carved standing stone, now with a large black iron nail driven into it and a black round seal mark burned into the surface, chains around it, cracks spreading |
| 6c Seal glow | 600x600 | a black and deep violet glow in the shape of a round seal, soft edges, for an additive glow |
| 6d Under the water | 1600x400 | the faint shape of an enormous crocodile under dark water, only the long outline and a ridge of back scales visible, with an iron nail glinting near its jaw |
| 6e Bound beings | 800x500 | three or four faint translucent pale shapes being pulled into an iron lantern by thin chains, shapes only, no faces, sad and helpless rather than scary |

### Shot 7: Withered sawah, the long line

| Layer | Size | Prompt |
|---|---|---|
| 7a Sky | 1600x720 | heavy grey monsoon sky, low dark clouds |
| 7b Dead sawah | 1800x400 | rice paddies with withered brown and grey rice stalks, broken bunds, puddles reflecting the grey sky |
| 7c Line of people | 1800x360 | a long line of people walking away along a dirt path toward hills, as silhouettes: men, women and youths carrying bundles, two soldier silhouettes with pikes guarding them |
| 7d Foreground | 1800x300 | dead stalks and a broken wooden plough in the near foreground, almost black |

Godot: rain begins, and a puddle ripple.

### Shot 8: Tok Senik's hut

| Layer | Size | Prompt |
|---|---|---|
| 8a Interior | 1280x720 | the inside of a simple wooden kampung hut at night, woven mat walls, bundles of dried herbs and roots hanging from the beams, clay jars, warm orange light from a small oil lamp |
| 8b Old man | 500x500 | an old man seated cross-legged in silhouette, thin, wearing a simple headcloth, one hand raised as if speaking, warm rim light from the lamp |
| 8c Youth | 400x500 | a young person seen from behind in silhouette, seated facing the old man, face not visible, plain clothes |
| 8d Lamp | 200x200 | a small clay oil lamp (pelita) with a flame, on a wooden floor |

Godot: the lamp flame flickers, and the shadows breathe with it.

### Shot 9: Dawn on the jetty, title

| Layer | Size | Prompt |
|---|---|---|
| 9a Sky | 1600x720 | a clear dawn sky over a wide river, gold and pale blue, hopeful light |
| 9b River | 1800x360 | a wide calm river with gold reflections, a distant forest bank, a small perahu far away |
| 9c Jetty and youth | 1000x500 | a simple wooden jetty on stilts reaching into the river, a lone young person standing at its end in silhouette, seen from behind, looking upriver, a cloth sash moving in the wind |
| 9d Foreground | 1800x300 | dark coconut palm fronds framing the top corners |
| 9e Title frame | 900x260 | an ornate frame in carved wood and gold with Malay woodcarving (ukiran) leaf patterns, empty in the middle for the title text, transparent background |

Write the title text itself in Godot with a font, not in the picture, so it can change later.

---

## 4. Sound

| Kind | What |
|---|---|
| Narrator | One calm, older voice in Malay (the 9 lines above). Speak slowly, with pauses at the "...". |
| Azan subuh | Use a **real, respectful recording** with a licence that allows it. Play it soft and distant. Never cut it off abruptly or put it under action sounds: let it fade out naturally before shot 2. |
| Music | Shots 1–2: soft and traditional (seruling, gambus, rebana). Shots 3–7: darker, with low drums. Shots 8–9: warm and hopeful. |
| Effects | River and birds (1), forest night (2), waves and creaking wood (3), metal nail strikes (4), fire and shouting from a distance (5), deep water and chains (6), rain (7), lamp crackle (8), wind and water (9). |

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
