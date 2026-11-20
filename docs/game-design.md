# Game design notes

> **Status key:** ✅ Approved · 💡 Suggestion (pending approval)
>
> To approve a suggestion, move it into the **Approved** section and note who
> approved it. Reject by moving it to "Rejected ideas".

---

## ✅ Approved

### Theme & era
- **Setting:** Old Malaysia / Nusantara, **around the 15th century**: the era
  of the Melaka Sultanate, Hang Tuah and the Puteri Gunung Ledang legend.
- **Fantasy layer:** Malay folklore and legends: Naga Tasik Chini, Bujang
  Senang, Orang Bunian, Puteri Gunung Ledang.
- **Art style:** Similar to / inspired by **Stoneshard**.
- Keep things era-appropriate: no rifles, rubber, cassava or other later items.

### Tone
- **Dark but hopeful.** The cruelty is real, but the story is about the village
  rising back up. Cozy farm moments give relief between the dark parts.

### Team roles
- **leoxent**: sprites / character art.

### Multiplayer
- **Solo, with an optional co-op mode.**
- Tech note: build with co-op in mind from the start (Godot multiplayer), even
  if it ships later. Adding it at the end is very painful.

### Main villain: the Penjajah = **Ordo Sigillum** ("Order of the Seal")
- A **fictional empire**, inspired by real colonisers but invented.
- Locals may call them *Orang Putih Tulang* or just "si Penjajah".
- **Look:**
  - **Colours:** bone-white and iron-grey with a **black seal sigil**.
  - **Soldiers:** white tabards over brigandine, open-faced helmets, pikes and
    crossbows. Elite troops carry hand cannons.
  - **Binders (occult officers):** grey robes, wax-sealed scrolls, iron
    **spirit-lanterns** with trapped spirits glowing inside, chained books.
  - **Bound spirits:** marked with the black seal and wrapped in iron chains or
    nails, so the player can tell them from free spirits.
  - **Buildings:** square stone forts with bone-white banners; carracks with pale sails.
- **Emblem & ranks** *(was S16)*: an **eye in the centre of a round seal,
  pinned by radiating iron nails, with wings**. The emblem's metal and detail
  show rank:

  | Rank | Emblem |
  |---|---|
  | **Acolyte** | Grey iron seal, dark grey wings, plain. |
  | **Warden** | Bronze/copper seal, pale gold wings. |
  | **Grandmaster** | Gold and red seal set with jewels, large ornate red-gold wings. |

  Concept art: `docs/references/concept/emblems-ordo-sigillum-ranks.jpg`.
- **Occult empire with 15th-century military equipment.** They came here *for*
  the spirits. Spirit-binding is their real source of power, backed by an army
  of the period:
  - pikes, halberds, swords, crossbows
  - early gunpowder: hand cannons, early matchlock arquebuses, bombards
  - brigandine and plate armour, helmets
  - stone forts and warships (carrack-style)
- They **capture or bind local spirits** and use them as underlings:
  *pelesit / polong*, *toyol*, *hantu raya*, *pontianak*, *penanggal*,
  *harimau jadian*.
- **Freeing bound spirits** is a core goal; freed spirits can become allies.

### Legends as major characters
- **Naga Tasik Chini**: guardian of the lake; the Penjajah want to drain it for mining.
- **Bujang Senang**: giant river crocodile; a neutral force, dangerous but not evil.
- **Orang Bunian**: hidden forest village; trade, side quests, a "hidden world" area.
- **Puteri Gunung Ledang**: her impossible demands become a late-game quest chain.

### Farming
- **Crops (era-appropriate):** padi (sawah), kelapa, pisang, keladi (taro),
  ubi (yam), sagu, sireh, lada, tebu, durian, rambutan, manggis.
- **Monsoon seasons** instead of 4 seasons: Musim Tengkujuh (floods),
  Musim Kemarau (dry), Musim Buah (fruit).
- **Livestock:** ayam kampung, itik, kambing, kerbau (ploughing the sawah).
- **Buildings:** rumah kampung on stilts, jelapang padi, perahu for river travel.

### Core conflict loop: a cruel Penjajah
The Penjajah are **openly cruel**, not just strict:
- Heavy **harvest taxes**. Failing to pay means punishment: burned crops,
  confiscated livestock, villagers taken away.
- **Land seizure** and **forced labour** in their tin mines, pepper estates and forts.
- **Public punishments** and raids on the kampung to spread fear.
- Using bound spirits to **terrorise** villages at night.
- The player decides: comply, resist quietly, or fight openly, **with real
  consequences** for the village (villagers can be hurt, leave, or join the
  resistance).

### Player character: the old pawang's questions
- At the start, an **old pawang asks the player questions**, **7 at most**
  (exact number TBD).
- **Class questions** decide the player's **class**.
- **Personality questions** decide the player's **blessing**: **one permanent,
  upgradeable skill** (active or passive).

### Classes *(tentative, was S13)*

| Class | Local name | Style |
|---|---|---|
| Warrior | **Hulubalang** | Heavy armour, tombak & shield. Tanky frontline. |
| Fighter | **Pendekar** | Silat master, keris or bare hands. Fast combos, counters. |
| Assassin | **Bayang** ("shadow") | Stealth, poisoned keris, sumpit (blowpipe), backstabs. |
| Mage | **Pawang** | Spirit magic, charms, can talk to and command freed spirits. |

Example class questions from the old pawang:
1. *"Soldiers are burning your neighbour's house. What do you do?"*
   → Stand in front of them (Hulubalang) / Fight them head-on (Pendekar) /
   Wait and strike at night (Bayang) / Call on the spirits (Pawang)
2. *"What do you trust most?"* → Strength / Skill / Silence / The unseen world
3. *"Which weapon did your father leave you?"* → Tombak / Keris / Sumpit / Azimat

### Blessings *(approved as a starting list, details TBD, was S14)*
One blessing per playthrough. It is **permanent** and **upgraded** through
offerings at shrines and spirit quests (e.g. levels 1–5). Any class can get any blessing.

| Personality | Blessing | Type | Effect | Upgrade path |
|---|---|---|---|---|
| Brave | **Sisik Naga** (Dragon Scale), from Naga Tasik Chini | Passive | Once per day, survive a killing blow with 1 HP. | More uses per day → heal on trigger → shockwave that knocks enemies back. |
| Nurturing | **Semangat Padi** (Rice Spirit) | Passive | Crops grow faster and better; slow healing on your own farmland. | Wider area → chance of double harvest → crops survive floods and drought. |
| Curious / sly | **Langkah Bunian** (Bunian Step) | Active | Briefly step into the hidden world: invisible, pass through enemies. | Longer duration → see hidden paths/items → bonus damage on the first attack out of it. |
| Fierce | **Gigit Bujang Senang** (Crocodile Bite) | Active | Lunge and lock onto one enemy, stunning it. | Longer stun → "death roll" damage → works on large enemies and spirits. |
| Wise | **Mata Batin** (Inner Eye) | Passive | See spirits, bound seals, and enemy weak points. | Bonus damage vs spirits → break seals faster → reveal enemies through walls. |
| Loyal / protective | **Panggilan Tok Belang** (Call of the Tiger Spirit) | Active | Summon a spirit tiger that fights beside you for a short time. | Longer summon → tiger guards the farm at night → tiger can be ridden. |
| Patient / calm | **Bayu Ledang** (Ledang Wind) | Active | Slow time around you for a few seconds. | Longer duration → full speed inside it → enemies inside take damage. |
| Charismatic | **Lidah Bertuah** (Blessed Tongue) | Passive | Better prices, faster villager trust, weak enemies may flee. | Easier recruiting → turn bound spirits without fighting → soldiers may defect. |

Story hook: the Ordo Sigillum want to capture the player *because* of their blessing.

### Magic & weapons
- **Pawang / bomoh** magic: charms (azimat), spirit offerings, protecting crops.
- Era weapons: keris, parang, tombak, golok, sumpit.
- **Combat style: real-time action** *(was S15)*. Move and attack freely, with
  dodges and combos (top-down action RPG). Silat flavours the movement,
  combos and counters.
  - Works well with real-time farming and co-op.
  - Needs more animation frames per class, so plan the art budget around it.

### Player-side emblems *(was S17)*
| Faction | Emblem |
|---|---|
| **Resistance** | A keris crossed over a padi stalk on a riveted iron plate. |
| **Naga Tasik Chini** | A naga coiled inside a round teal-and-copper frame, above lake water. |
| **Orang Bunian** | A pale green leaf with gold veins on a silver frame, faintly glowing. |

Concept art: `docs/references/concept/emblems-player-factions.jpg`.

Polish notes for the final versions:
- The **keris** in the concept has a straight blade and a pistol-grip hilt.
  A real keris has an asymmetric guard (*ganja*) and often a wavy blade
  (*luk*); use museum references.
- The **naga** in the concept looks like a European dragon. A Malay naga is
  more serpent-like, often wears a crown (*mahkota*) and has no legs.

### Art direction
- Top-down ¾ view, muted earthy palette with bright accents (padi gold,
  hibiscus red, spirit glows).
- Visible equipment on the character (layered sprites).
- Strong night/torch lighting to suit the folklore horror side.
- Designs based on real references: museum keris, songket, rumah Melayu, old manuscripts.
- Inspiration only: no copying Stoneshard assets, palette or UI.

### ⭐ Official sprite format
**Reference sheet:** `docs/references/concept/official-sprite-format-ordo-sigillum.jpg`
(Ordo Sigillum soldiers, Binders and bound spirits). All new character and
creature sprites must match it.

| Rule | Value |
|---|---|
| Tile size | **32×32 px** |
| Base resolution | **640×360**, integer scaling (project already set) |
| Character size | about **24×36–40 px** (≈ 1 tile wide, ≈ 1¼ tiles tall); bigger creatures and bosses can be larger |
| View | top-down ¾ |
| Directions | **4 directions**: front (down), back (up), side (right). **Left = side flipped**, so draw 3 views |
| Colours | limited palette, roughly 16–24 colours per sprite, simple shading |
| Outline | dark outline (not pure black) |
| Shadow | soft dark oval drop shadow under every character; can be a separate sprite |
| Glow / light | lanterns, spirits and magic glow via Godot `PointLight2D` / additive effects, **not baked into the sprite** |
| File format | **PNG** with transparency, exact pixel grid. No JPG for game assets |
| Anchor | sprite origin at the feet (bottom centre) |

Notes:
- The reference sheet is a JPG concept and not pixel-perfect. Use it for size,
  proportions, style and colours; final sprites must be clean PNGs.
- Minimum animation set per character (to confirm later): idle, walk, attack,
  hurt, death, plus farming actions for the player (hoe, water, harvest).

---

## 💡 Suggestions (pending approval)

### S18. World structure
| Option | How it works | Notes |
|---|---|---|
| **A. Connected zones** *(recommended)* | The world is split into zones (farm, kampung, forest, river…). Walking off an edge loads the next zone, as in Stardew Valley. | Easiest to build and split between friends; each zone is its own Godot scene. Works well with co-op. |
| B. One seamless open map | One big continuous map, no loading between areas. | Feels great, but much harder (streaming chunks, co-op syncing). |
| C. Hub + missions | Farm/kampung hub; travel to separate mission maps. | Simple, but feels less like a living world. |

### S19. The region: a fictional river valley
The legends come from different real places (Tasik Chini in Pahang, Gunung
Ledang in Johor/Melaka, Bujang Senang in Sarawak), so the game is set in **one
invented negeri** that brings them together around a single river system:

```
            [Gunung Ledang]  (late game, mountain)
                  |
          [Highland forest / Orang Bunian]
                  |
 [Tasik Chini] ---+--- [Upper river villages]
                  |
   [YOUR FARM] - [KAMPUNG] - [Sawah fields]
                  |
           [Mangrove & river]  <- Bujang Senang
                  |
     [Kuala: river mouth port]  <- Ordo Sigillum fort & ships
```

- The **river is the backbone**: the main travel route (by perahu) and the story path.
- The **Ordo Sigillum hold the river mouth** and push upriver as the game goes on.
- Placeholder name for the region, e.g. **Negeri Sungai Seri** (to be decided).

### S20. Starting zones for the first playable version
Keep it small at first:
1. **Player farm**: overgrown land to clear, a small rumah kampung, padi plots, a well.
2. **Kampung**: about 6–8 houses, a surau, a market area, the old pawang's house, a jetty.
3. **Forest edge**: foraging, the first spirits, the first Ordo patrol.

Later zones: sawah, river and mangrove, Tasik Chini, highland forest (Bunian),
Ordo fort at the river mouth, Gunung Ledang.

### S21. Zone size (to keep the art workload sane)
- One screen = 640×360 = **20×11 tiles** (32 px tiles).
- Suggested sizes: farm **60×40 tiles** (about 3×4 screens), kampung **80×50**,
  forest zones **60×60**.
- Build with Godot **TileMapLayer** layers: ground, paths/water, objects, overhead
  (tree tops and roofs drawn above the player).

### S22. Map features that support the design
- **The Ordo spreads**: zones they control change look (banners, burnt fields,
  checkpoints, patrols). Freeing a zone brings colour back.
- **Monsoon changes the map**: in Musim Tengkujuh low areas flood, some paths
  close, and river paths open for the perahu.
- **Hidden Bunian layer**: a few forest zones have a hidden version, seen with
  Mata Batin, Langkah Bunian or at certain times (dusk).
- **Night changes everything**: more spirits, Ordo raids, lit lanterns at the kampung.
- **Shrines (keramat)**: in each zone, for blessing upgrades and fast travel.

### S23. Co-op on the map
- Co-op players can be in **different zones** at the same time (like Stardew),
  or must **stay together** (simpler to build). Suggest: start with *stay in the
  same zone*, allow splitting later.

## Open questions
- Final game name?
- Exact number of pawang questions (max 7)?
- Final blessing list and balancing?

## Rejected ideas
- Real-history Penjajah (Portuguese / British / Japanese) → replaced by a fictional empire.
- Modern weapons (rifles, modern army) → replaced by 15th-century equipment.
