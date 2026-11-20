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

### Main villain: the Penjajah
- A **fictional empire**, inspired by real colonisers but invented. Name and
  look: see S11.
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
- At the start, an **old pawang asks the player questions**.
- **Class questions** decide the player's **class** (e.g. warrior / assassin /
  mage / fighter). See S13.
- **Personality questions** decide the player's **blessing**: **one permanent,
  upgradeable skill** (active or passive). See S14.

### Combat & magic
- **Silat** combat; weapons: keris, parang, tombak, golok.
- **Pawang / bomoh** magic: charms (azimat), spirit offerings, protecting crops.

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

### S11. Empire name & look

**Name options** (invented, sound foreign to the setting, not a real country):

| Name | Meaning / feel |
|---|---|
| **The Pale Covenant** *(recommended)* | A holy-sounding pact. They believe binding spirits is a sacred duty. |
| **Ordo Sigillum** ("Order of the Seal") | Latin-style military order; the seal they stamp on bound spirits is their symbol. |
| **The Ashen Crown** | A distant kingdom whose land was burned dry; they come to steal the spirit-rich East. |

Locals could have their own name for them, e.g. **Orang Putih Tulang**
("bone-white people") or simply **"si Penjajah"**.

**Look:**
- **Colours:** bone-white and iron-grey with a **black seal sigil**. Cold and
  pale against the warm greens and golds of the kampung.
- **Soldiers:** white tabards over brigandine, open-faced helmets, pikes and
  crossbows. Elite troops carry hand cannons.
- **Binders (occult officers):** long grey robes, wax-sealed scrolls hanging
  from their belts, iron **spirit-lanterns** that glow with trapped spirits,
  chained books.
- **Bound spirits:** marked with the black seal and wrapped in iron chains or
  nails, so the player can tell bound spirits from free ones.
- **Buildings:** square stone forts with bone-white banners, and carracks with
  pale sails anchored at the river mouth.

### S13. Classes (from the class questions)
Local names for the four classes:

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

### S14. Blessings (from the personality questions)
One blessing per playthrough. It is **permanent** and **upgraded** through
offerings at shrines and spirit quests (e.g. levels 1–5). Each is given by a
spirit or legend from the setting.

| Personality | Blessing | Type | Effect | Upgrade path |
|---|---|---|---|---|
| Brave | **Sisik Naga** (Dragon Scale), from Naga Tasik Chini | Passive | Once per day, survive a killing blow with 1 HP. | More uses per day → heal on trigger → shockwave that knocks enemies back. |
| Nurturing | **Semangat Padi** (Rice Spirit) | Passive | Crops grow faster and better; you heal slowly while standing on your own farmland. | Wider area → chance of double harvest → crops survive floods and drought. |
| Curious / sly | **Langkah Bunian** (Bunian Step) | Active | Briefly step into the hidden world: invisible, and you pass through enemies. | Longer duration → see hidden paths and items → first attack out of it deals bonus damage. |
| Fierce | **Gigit Bujang Senang** (Crocodile Bite) | Active | Lunge and lock onto one enemy, stunning it. | Longer stun → "death roll" damage → works on large enemies and spirits. |
| Wise | **Mata Batin** (Inner Eye) | Passive | See spirits, bound seals, and enemy weak points. | Bonus damage against spirits → break seals faster → reveal enemies through walls. |
| Loyal / protective | **Panggilan Tok Belang** (Call of the Tiger Spirit) | Active | Summon a spirit tiger that fights beside you for a short time. | Longer summon → tiger protects the farm at night → tiger can be ridden. |
| Patient / calm | **Bayu Ledang** (Ledang Wind) | Active | Slow time around you for a few seconds. | Longer duration → you move at full speed inside it → enemies inside take damage. |
| Charismatic | **Lidah Bertuah** (Blessed Tongue) | Passive | Better prices, villagers trust you faster, weak enemies may hesitate or flee. | Recruit resistance members more easily → turn bound spirits without fighting → Penjajah soldiers may defect. |

**Rule ideas:**
- Any class can get any blessing, so combos like a **Bayang with Panggilan Tok
  Belang** make each playthrough feel different.
- Blessings make good **story hooks**: the Penjajah want to capture the player
  *because* of their blessing.

---

## Open questions
- Final game name?
- Solo or co-op?
- How many pawang questions in total? (Suggest 5–7: about 3 for class and 3–4 for personality.)

## Rejected ideas
- Real-history Penjajah (Portuguese / British / Japanese) → replaced by a fictional empire.
- Modern weapons (rifles, modern army) → replaced by 15th-century equipment.
