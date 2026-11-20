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
- **Emblem style:** bold, single-colour, symmetrical silhouette sigils
  (reference: `docs/references/emblem-style-reference.png`, style only). See S16.
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
- **Combat style is undecided** (see S15).

### Art direction
- Characters ~**20×36 px** → **32 px tiles** at **640×360** base resolution
  (project updated).
- Top-down ¾ view, muted earthy palette with bright accents (padi gold,
  hibiscus red, spirit glows).
- Visible equipment on the character (layered sprites).
- Strong night/torch lighting to suit the folklore horror side.
- Designs based on real references: museum keris, songket, rumah Melayu, old manuscripts.
- Inspiration only: no copying Stoneshard assets, palette or UI.

---

## 💡 Suggestions (pending approval)

### S15. Combat style
Note: this choice also affects co-op and how farming and combat fit together.

| Option | How it plays | Pros | Cons |
|---|---|---|---|
| **A. Real-time action** | Move and attack freely, with dodges and combos (like top-down action RPGs). | Feels natural next to real-time farming; easiest to make co-op fun; silat combos and counters shine. | Needs more animation frames per class. |
| **B. Turn-based on tiles** (like Stoneshard) | Each move or attack is a turn; enemies act after you. | Tactical, matches the Stoneshard inspiration, less animation needed. | Awkward with real-time farming and co-op (waiting for your friend's turn). |
| **C. Hybrid** *(recommended)* | Farming and exploring are real-time; combat is real-time but deliberate: stamina, telegraphed enemy attacks, positioning matters. | Keeps the Stoneshard "every fight is dangerous" feel and still works in co-op. | Needs careful tuning. |

Silat can stay as the theme of movement and counters in any option.

### S16. Ordo Sigillum emblem ideas
Bold, single-colour, symmetrical silhouettes (style of the reference image, not its symbols):
1. **The Seal:** a round wax seal with a closed eye in the middle and four nails
   through its edge. "We seal what we see."
2. **The Chained Lantern:** an iron lantern with chains hanging down, a trapped flame inside.
3. **The Nailed Circle:** a circle (the spirit world) pinned by a single iron nail
   with spread wings, mixing military and occult.

Ranks could add small marks (one nail for soldiers, more for officers, a full seal for Binders).

### S17. Emblems for the player's side
To match the style, the resistance and the spirits could also get sigils:
- **Resistance:** a keris crossed over a padi stalk.
- **Naga Tasik Chini:** a coiled naga forming a circle.
- **Orang Bunian:** a leaf with a hidden eye.

## Open questions
- Final game name?
- Combat style? (see S15)
- Exact number of pawang questions (max 7)?
- Final blessing list and balancing?

## Rejected ideas
- Real-history Penjajah (Portuguese / British / Japanese) → replaced by a fictional empire.
- Modern weapons (rifles, modern army) → replaced by 15th-century equipment.
