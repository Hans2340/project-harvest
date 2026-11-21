# Game design: proposed and tuned by leoxent

> **Status:** 💡 working document (started 2026-11-21). The original `docs/game-design.md` stays
> as it was. Nothing here overrides it until leoxent moves a part across.
>
> - **Part A** holds what leoxent has decided (from the design update of 2026-11-21 and later
>   answers).
> - **Part B** lists the edits `game-design.md` would need when Part A moves in.
> - **Part C** holds Claude's review and extra suggestions (S25–S30), not decided.
>
> Story details: `docs/lore.md`. Opening script: `docs/opening-scene.md`.

---

## Part A. Decided by leoxent

### Story & structure
- Full lore: `docs/lore.md` (v2). Kept as is: Awang, Kelana, Si Raya, Tok Senik, Tok Imam,
  Severin, the Four Guardians and their key pieces, the five acts and the three endings.
- **Timeline:**
  1. Opening cinematic: a narrator tells the world's history.
  2. Prologue gameplay: peaceful life with Awang (tutorial + emotional setup).
  3. Ordo Sigillum arrive: cutscene of the raid and Awang's capture.
  4. Main story: the player sets out to find Awang.
  5. Act 1: Paya Bakau. 6. Act 2: Tasik Chini. 7. Act 3: Rimba Bunian.
  8. Act 4: Gunung Ledang. 9. Act 5: Kuala.
  10. Epilogue: **Sungai Masih Mengalir**.
- **Priority:** every gameplay system supports the story. Life with Awang before the tragedy
  must matter, so losing him drives the player for the whole game.
- **Religion rules** (full text in `docs/lore.md`): unseen beings are creations of God, never
  protectors and never asked for help; no offerings, jampi or azimat shown as good; Islam is part
  of daily life, shown with respect and never used as magic; no Quran verses or Arabic writing in
  art. Player powers come from within (Bakat) and grow through good deeds.

### Opening cinematic
- Plays before the player takes control. A narrator (calm, dignified older male voice, old
  Malay hikayat style) over layered pixel-art pictures with slow camera moves and a mysterious mood.
- It introduces: the history of the world, the two worlds (human and unseen), the border and the
  Batu Sempadan, the Four Guardians, the balance between people and nature, the arrival of Ordo
  Sigillum and the first breaking of the balance.
- It **does not** reveal Kelana's past, Si Raya, Tok Senik's secret or the Ordo's secrets: those
  come out bit by bit during the game.
- It ends by linking the world's history to a small kampung upriver on the Seri, where the player's
  life begins. Script and image prompts: `docs/opening-scene.md`.

### Prologue: life with Awang
After the cinematic the player controls the main character in kampung life. The prologue is the
main tutorial **and** the emotional setup. Target length: **30–45 minutes** (see S25 for a
pacing review).

**Awang** is the player's older brother, who raised and looked after them after their father died.
He is the first mentor and companion, not just a tutorial NPC:
- he walks with the player (usually a little ahead), gives advice during work, chats while
  working, teases and jokes like a brother, and helps when the player makes a mistake;
- the goal: the player gets comfortable with kampung life and comes to love this bond.

**Tutorial missions**
| # | Mission | Teaches |
|---|---|---|
| 1 | **Turun ke Sawah** | Ploughing the soil, choosing and planting padi seed, watering, the farming tools. |
| 2 | **Rezeki dari Tanah** | A **time skip** until the padi is ripe (or near-ripe crops); harvesting with a **sabit**, collecting the harvest, storing it in the **jelapang**. Never make the player wait real time. |
| 3 | **Nilai Setiap Butir** | Taking padi to the market, selling, earning **pitis**, buying basic goods. |
| 4 | **Belajar Mempertahankan Diri** | Movement and attacks, dodge, stamina, combos and heavy attacks, weapon practice. |
| 5 | **Rezeki dari Hutan** | Hunting with Awang at the forest edge: tracking animals, a ranged weapon or traps, meat and animal materials. |
| 6 | **Apa yang Diberikan Alam** | Gathering wood, stone and herbs; felling trees, mining stone; basic crafting with the materials. |

**Transition to the main story.** After the tutorials, Ordo Sigillum arrive at the kampung and show
their power: they take control, force a harvest tax, seize crops and village goods, and oppress the
villagers. Awang refuses to bow and tries to protect people; it turns to chaos and Awang is captured.
The player has lost the person who taught and protected them, and must now use everything they
learned to keep living and to find him.

**Awang's absence in gameplay**
| Before | After |
|---|---|
| Awang helps plant | The player runs the sawah alone |
| Awang teaches harvesting | The player harvests alone |
| Awang comes along to sell padi | The player earns their own living |
| Awang teaches fighting | The player faces real enemies |
| Awang takes the player hunting | The player hunts without a companion |
| Awang gathers resources too | The player gathers alone |

- In the prologue Awang often walks a little ahead. After he is taken, the player walks the same
  places and he is not there. Show the loss through changes in mood, dialogue and environmental
  storytelling.
- Foreshadowing line (Awang): *"Kalau abang tak ada nanti, kau dah tahu apa nak buat."*
- Few cutscenes: build the bond through gameplay and daily interaction.


### Classes: Pawang becomes a mage
| Class | Local name | Style |
|---|---|---|
| Warrior | **Hulubalang** | Heavy armour, tombak & shield. Tanky frontline. |
| Fighter | **Pendekar** | Silat master, keris or bare hands. Fast combos, counters. |
| Assassin | **Bayang** ("shadow") | Stealth, poisoned keris, sumpit (blowpipe), backstabs. |
| Mage | **Pawang** *(name KIV)* | **Ranged magic DPS**: elemental projectiles, area attacks and crowd control (Bara, Bayu, Bumi, Halilintar) through a medium (tongkat, keris or an artefact). |

- The class decides the player's combat identity. Do not add classes without a strong reason.
- Pawang's power is **Anugerah** (below). It is not worship, calling or asking jin or spirits for
  help. Commanding or talking to beings is no longer a class power.
- Pawang look: traditional traveller's clothes, keris / tongkat / artefact as the medium, Malay
  carving motifs, unique casting animations.
- The name "Pawang" is **KIV**: leoxent wants a safer name (candidates in S27).

### Sistem Anugerah (the magic system)
- In this world some people are born with an **Anugerah**: a gift from God that lets them use the
  power of nature, such as the elements (air, api, angin, bumi...). It is a gift, like a strong arm
  or a good voice, not something bought, learned from beings or bargained for.
- **Anugerah is only for the Pawang class.** The player has one only if they are Pawang.
- **Awang and Kelana both have an Anugerah.**
- No spells (jampi), offerings or amulets (azimat); casting is a gesture, with no chanting.
- Crops are protected with ramuan (remedies) and farming skill, not Anugerah.

### Bakat is a separate system
- Every class has a **Bakat**: a unique passive or active skill (the old "Blessings" list).
  Anugerah (elemental power) belongs to the Pawang class only.
- Upgraded through **good deeds** and quests, not offerings.
- **One shared list** (decided by leoxent, 2026-11-21): every class can get any Bakat; Tok
  Senik's personality questions decide which one. One Bakat per playthrough. Renames: S30
  (all renames approved by leoxent, 2026-11-21).

### Awang's hidden Anugerah (story hook)
- **Awang hides his Anugerah** from the village, because people with one get taken. In the
  prologue there are small signs only a careful player notices.
- **The raid reveals it.** On day 3 Awang uses it to protect the villagers. That is why Kelana
  takes **Awang** and not just anyone: *"Kau pun sama macam aku."* It also explains why Awang
  becomes Kelana's lantern bearer in Act 4.
- **If the player is Pawang**, Awang teaches the first cast in secret in mission 4 (*"Jangan
  beritahu sesiapa, faham?"*). If the player is another class, they learn Awang's secret only at
  the raid.

### Companion system *(decided by leoxent, 2026-11-21)*
Every class can have an **animal companion** that fights or helps beside the player. Only the
**Siulan Belang** Bakat unlocks the **great tiger** (see S30), the strongest companion in combat.
- **Companions are real creatures** of this fantasy world, created by God, bonded through
  kindness. No pact, offering, summoning from another world or inheritance (no saka/belaan).
- **Roster:**
  | Companion | Role |
  |---|---|
  | **Beruk** | Picks kelapa (a real tradition), steals items from enemies, distracts them. |
  | **Helang** | Scouts the area and marks enemies. **Dive attack** *(added by leoxent)*: swoops at one enemy and stuns it briefly (about 1 s), on a cooldown. Does not stun large enemies or bosses; they only flinch. |
  | **Kucing** | Finds hidden items, warns of danger. |
  | **Beruang madu** *(replaces memerang; chosen over serigala, which is not native)* | Tough: draws enemy attacks and takes hits; digs up and finds honey, fruit and roots (helps gathering). Slow. |
  | **Great tiger** (Siulan Belang only) | The strongest in combat. |
- **Balance.** The tiger is the strongest **in combat**; the others are strong in their own lane
  (finding, scouting, gathering), so Siulan Belang is the "warrior" pick, not the best pick for
  everything.
- **One active companion** at a time; the others rest at the kampung.
- **The tiger follows like any companion.** The Bakat adds an active skill, **Siulan**: a command
  for a power move (pounce, or a roar that stuns), on a cooldown.
- **Keep the loneliness.** The first companion comes only after Act 1 starts, through a good
  deed. The tiger cub from the prologue hunt is too small to fight; it grows and starts fighting
  mid Act 1.
- **Companions never die.** Badly hurt, they retreat and rest.
- **Co-op:** at most one companion per player.
- **No dogs** (anjing): a pet dog is sensitive in a Muslim kampung setting.
- **Tech and art.** Reuse Awang's follow and combat AI from the prologue. Each companion is about
  5 animations × 3 directions. The tiger has **2 growth stages** (young, adult), not 3.

**Notes (Claude):**
- **Stuns stack up.** The helang dive, the tiger's roar (Siulan), Pawang's Bumi and the Gigitan
  Buaya Bakat all stun. Together they could lock an enemy down for good, so stuns need
  **diminishing returns**: each new stun on the same enemy within a few seconds is shorter, then
  it is immune for a moment. The helang's stun is the shortest of them all.
- **Beruang madu vs tiger:** the bear is the defensive companion (soaks hits, slow), the tiger
  the attacking one (fast, high damage). The bear stays below the tiger in damage.
- Serigala was dropped: wolves are not native to Nusantara, and the native ajak (anjing hutan)
  brings back the dog sensitivity.
- With the memerang gone, fishing and river help have no companion. That is fine; fishing stays a
  player skill.

### On hold (KIV)
- **Solat and wuduk** (S26): do not build yet. The azan, the surau and Tok Imam stay in the game as
  village life.

---

## Part B. Edits `game-design.md` would need

When Part A moves into `game-design.md`:
| Where | Now | Change to |
|---|---|---|
| World & zones, Paya Bakau | "defiled keramat" | nailed **Batu Sempadan** |
| Classes table, Pawang row | Spirit magic, charms, can talk to and command freed spirits | Ranged magic DPS with Anugerah (Part A) |
| Class question 1, Pawang answer | Call on the spirits | Strike them from afar |
| Class question 2, Pawang answer | The unseen world | Knowledge of nature |
| Class question 3, Pawang answer | Azimat | Tongkat |
| Blessings intro | upgraded through offerings at shrines and spirit quests | upgraded through good deeds and quests; in-game name Bakat |
| Blessings, Wise | Mata Batin | Firasat |
| Magic & weapons | Pawang / bomoh magic: charms (azimat), spirit offerings | Sistem Anugerah (Part A) |
| S22, hidden Bunian layer | seen with Mata Batin | seen with Firasat |
| S22, shrines | Shrines (keramat) for blessing upgrades and fast travel | Batu Sempadan: freeing one weakens the Ordo in that zone; can be fast travel; no worship or offerings |
| New sections | none | Story & structure, Opening cinematic, Prologue: life with Awang (Part A) |

---

## Part C. Claude's review and suggestions (not decided)

### S25. Prologue pacing and flow (review of the approved prologue)
**Problems with six missions in 30–45 minutes**
- **The clock.** One in-game day is ~25 real minutes. If the prologue runs on the normal clock it
  takes well over an hour. The prologue needs **scripted time**: each mission ends with a skip
  (to evening, to the next morning, or to ripe padi).
- **Too many verbs before the hook.** Six missions teach about 20 actions before anything bad
  happens. Players remember 2–3 new things per mission. Mining, crafting and hunting are not needed
  to survive the first act, so they slow down the part that matters (loving Awang, then losing him).
- **No threat for 40 minutes.** The cinematic gives dread, but the prologue itself has none. It
  needs small signs that something is coming.
- **Who teaches each class?** Awang is a pesilat, hunter and farmer. He can teach Pendekar
  (silat), Hulubalang (his tombak) and Bayang (moving quietly while hunting), but not Pawang magic.

**Suggested flow: 3 in-game days, 4 missions, ~30 minutes**
| Day | Mission | Content | Foreshadowing |
|---|---|---|---|
| — | Tok Senik's questions | Right after the cinematic: look, class, Bakat. Framed as an adat: Tok Senik asks every youth who comes of age. | Tok Senik looks at the player a little too long. |
| 1 morning | **Turun ke Sawah** (missions 1+2) | Plough, plant, water; skip to near-ripe padi in a second plot Awang planted earlier; harvest with the sabit, store in the jelapang. | A perahu of people from downriver passes the jetty, silent. |
| 1 afternoon | **Nilai Setiap Butir** (3) | Kampung tamu day: sell, buy. Keep the market inside the kampung (no new pekan zone yet). | A trader: "Harga garam naik. Kuala dah tutup." |
| 1 evening | Surau | Maghrib at the surau, Tok Imam, evening news (the existing daily loop). | Talk of pale sails at the Kuala. |
| 2 morning | **Belajar Mempertahankan Diri** (4) | Awang spars in the yard (patung latihan already exists): move, dodge, stamina, light combo, heavy attack. Class skill: Awang teaches all four; for Pawang he teaches the first cast in secret (S27). | Awang: *"Kalau abang tak ada nanti, kau dah tahu apa nak buat."* |
| 2 afternoon | **Rezeki dari Hutan** (missions 5+6) | Track and hunt, gather wood and herbs, craft one item (a trap or a ramuan). The hunt ends with the **first Binatang Berpaku**: a sick, raging boar with a black mark, poisoned by the stone already nailed at the Kuala. Real combat with Awang beside you. | Awang has never seen an animal like it. |
| 3 | **Ordo arrive** | First tax day and the existing first choice (pay / hide / fight). Awang refuses, the raid, Awang is taken, the swamp stone is nailed, the sawah withers overnight. | — |

- Mining moves to Act 1 (it fits there: the Ordo run tin mines).
- The day-3 choice cannot save Awang (he is taken in every branch), so it must change something
  else: what is lost (buffalo, jelapang, a neighbour's house), the first Fear ↔ Spirit value,
  and who trusts the player.
- Awang companion tech: follow behaviour can reuse the A* from click-to-move; he needs simple
  sparring and hunting AI, plus one "helps when you make a mistake" hint per mission
  (e.g. he waters the tile you missed and says so).
- Each mission ends at a natural rest, so a player can stop and come back.

### S26. Solat and wuduk *(proposed by leoxent; ⏸ KIV, on hold since 2026-11-21)*
On hold: do not build it yet. The azan, the surau and Tok Imam stay in the game as village life.
**Proposed design:** five waktu (Subuh, Zuhur, Asar, Maghrib, Isyak) on the day cycle; a ~5 second
animation with fade in and out; restores **100% HP**; once per waktu; not in combat; wuduk needed
(river, telaga, perigi, or a carried kendi); no penalty for missing it; no damage buff, no pahala or
dosa system; normal food, medicine and healing items still work. Get a religious adviser's view
before finalising.

**Review**
- **Gameplay: full HP every few minutes breaks healing.** With 25 real minutes per day, the gap
  from Zuhur to Asar is about 3 real minutes. A free full heal that often makes food, ramuan and
  rest pointless, and the safe tactic becomes "walk out of combat, wuduk, heal".
- **Sensitivity: it turns ibadah into a health potion.** The design's own rule says solat is not a
  power. A full heal on a timer is exactly a gameplay power, and players will treat it that way
  ("solat for HP" in boss fights, memes, speedruns that skip it). This also breaks the lore rule
  "Islam is never used as magic". "No penalty" is not quite true either: missing it costs a
  free heal, so the reward system is there, just hidden.
- **What works well:** the five waktu as the rhythm of the day, the azan, wuduk at the river,
  showing it with fades and respect, and no pahala or dosa counter.

**Options**
| Option | How it works | Note |
|---|---|---|
| **A. Rhythm of life, no stats** *(recommended)* | The azan marks each waktu. The player can pray at the surau or any clean place (wuduk at water, short respectful animation with a fade). The benefit is the world, not HP: Maghrib and Isyak at the surau is where you hear news, meet Tok Imam and get quests (already in the daily loop). Healing comes from food, ramuan, rest and sleep. | Safest and fits the story (the surau empties in Act 1, fills again in the ending). |
| B. Rest is the heal | Any **rest** in a safe place (sitting at home, the surau, a jetty) heals over time. Prayer is one of the ways to rest, not a special power. | A compromise: solat is not singled out as magic. |
| C. Proposed design, tuned | Partial heal (e.g. 30%), only in safe places, never in danger zones. | Still solat-for-stats; least recommended. |

If solat is shown: the figure is small and seen from the side or behind, the movements are correct
(have the adviser check them), women pray in a telekung, and there is no recited audio or Arabic
text on screen. The prayer is shown with a fade rather than played in full.

### S27. Pawang as a mage: open points
- **The name** *(KIV, leoxent wants a safer one)*. In Malay culture a *pawang* deals with spirits
  (pawang hujan, pawang buaya), so a "Pawang" who throws fire reads as bomoh magic. Candidates:
  | Name | Meaning | Note |
  |---|---|---|
  | **Waris Alam** | heir of nature | Short, fits "a gift you are born with"; also hints at family (Awang). |
  | **Juru Alam** | expert of nature | Neutral and clear, but sounds learned rather than gifted. |
  | **Ahli Unsur** | master of the elements | Says exactly what the class does; a bit plain. |
  | **Beranugerah** | the gifted | Ties straight to Sistem Anugerah; long for the UI. |
  Avoid names that mean calling or summoning (*penyeru*), religious titles (*mualim*, *pendeta*)
  or "penjaga" (confused with the Four Guardians). Tok Senik stays a pawang in the old sense
  (healer) whatever the class is called.
- **Skill names.** "Sumpah" (curse/oath) and "Azimat" (amulet) clash with the rules. Suggestions:
  Sumpah Bara → **Lontar Bara**; Lingkaran Azimat → **Lingkaran Bara** or **Gelung Bumi**. Panah
  Bayu, Gegaran Bumi and Ribut Halilintar are fine.
- **Source of power** *(decided)*: Anugerah, a gift from God, used through a crafted medium made
  of natural materials (tongkat of a certain wood, keris, a stone). Elements are **never** gifts
  from the Four Guardians. Casting is a gesture, with no chanting or whispered words.
- **Water (air) element.** leoxent named *air* as an example, and it is not in the four-element list
  (Bara, Bayu, Bumi, Halilintar). Suggestion: add **Air** as the support element (heal over time,
  cleanse poison, slow). That fills the co-op healer gap below. Adding it means five elements, so
  the scope point matters even more.
- **Scope.** Four or five elements × several skills means a lot of VFX. Start with 2 (Bayu basic
  projectile, Bumi crowd control) and unlock the others during the acts through the medium (new
  materials), not through beings.
- **Co-op.** The old Pawang was the support class. As a DPS, co-op has no healer: healing comes
  from ramuan (any class), Hulubalang protects, and revive stays as is. Bumi's stun and slow (and
  Air, if added) give Pawang a support-like role.
- **Awang and Kelana have an Anugerah** *(decided)*. People with Anugerah are rare, so the Ordo
  hunt them; this fits the existing hook "the Ordo want to capture the player".
- **Story hooks** (the first three approved by leoxent, 2026-11-21; elements and family still
  proposed):
  - **Awang hides his Anugerah** from the village, because people with one get taken. In the
    prologue there are small signs only a careful player notices (e.g. water runs to the sawah
    faster when he is near, a cut on the player's hand closes after he holds it).
  - **The raid reveals it.** On day 3 Awang uses it to protect the villagers. That is why Kelana
    takes **Awang** and not just anyone: *"Kau pun sama macam aku."* It also explains why Awang
    becomes Kelana's lantern bearer in Act 4 (his Anugerah is being used).
  - **If the player is Pawang**, Awang teaches the first cast in secret in mission 4 (*"Jangan
    beritahu sesiapa, faham?"*), so Tok Senik is not needed as the Pawang teacher. If the player
    is another class, they learn Awang's secret only at the raid.
  - **Elements:** Awang = **Air** (water: protecting and nurturing, the brother who raised the
    player). Kelana = **Bumi** (earth and stone: a gift for keeping things steady, turned into
    nailing the stones and binding). Si Raya wants Kelana *because* of his Anugerah.
  - **Family:** if the player (Pawang) and Awang both have one, it may run in the family. Did
    the father have one? This links to "how did the father die?", so decide it together.
- **Balance levers.** Ranged is the safest style in top-down action, so Pawang has the lowest HP,
  a short wind-up on casts, a resource (stamina or *tenaga*), and projectiles slow enough to dodge
  (on both sides). Melee classes hit harder per hit and get i-frames on dodge. Bayang needs enemy
  sight and detection, which the night stealth missions need anyway.
- **Controls.** Left click already moves and attacks with auto-target (best target within range),
  so Pawang casts can use the same auto-target. That keeps click-to-move working and avoids a
  separate aim mode at first.

### S28. Awang's absence: extra details
- **A mirror shot.** The title shot of the cinematic shows two silhouettes on the jetty. After the
  capture the same jetty has one, then Mak joins at dusk.
- **Things left behind.** Awang's sabit on the wall, his sleeping mat, his place in the saf at the
  surau.
- **Two-person tasks.** Some prologue jobs were done with Awang (the kerbau and plough, carrying
  the jelapang sacks). Alone they are slower until the player finds help (a villager who joins,
  or a better tool), so the loss is felt in the hands, not only in the dialogue.
- **Dialogue.** Villagers who used to greet "Awang dan adik" now greet only the player, or go
  quiet.

### S29. Bakat list: clashes with the religion rules
- **Panggilan Tok Belang** summons a spirit tiger to fight. That is calling a being for help.
  Change it to a skill from within (e.g. **Langkah Harimau**: a fierce tiger-like silat stance),
  or drop it.
- **Sisik Naga**, **Gigit Bujang Senang** and **Langkah Bunian** are named after the Guardians, so
  they read as gifts from them. Also **Sisik Naga** is the name of key piece 2. Rename to describe
  the talent (e.g. Kulit Besi, Gigitan Buaya, Langkah Halus), or keep the names only as
  comparisons ("tough as a naga's scale"), never as gifts.
- The Act 5 allies (Bujang Senang, the Naga, the Bunian) come on their own because of what the
  player did, never because the player asks them.

### S30. Bakat: one shared list (shared list decided; renames being tuned)
Keep **one list that every class can get** (as in the original design), with fixes:
- **Why:** class decides how you fight, Bakat decides personality, and Tok Senik's questions are
  already split that way. 8 Bakat × 4 classes = 32 combinations (better replay and co-op). It is
  8 skills to build instead of 12 or more for per-class lists. Each player still gets one Bakat
  per playthrough, which is what makes it unique.
- **Weak point:** some pairs are odd (a lunge on a ranged Pawang). Each Bakat must be useful to
  every class (the lunge becomes an escape tool for Pawang), and combat, farming and social Bakat
  are kept in balance.
- **Renames** *(all approved by leoxent, 2026-11-21)*:
  | Now | Problem | Suggestion |
  |---|---|---|
  | Bayu Ledang (slow time) | "Bayu" reads as elemental power, which is Pawang-only | **Hening** |
  | Panggilan Tok Belang | Calls a being for help (and "Tok Belang" evokes harimau saka) | **Siulan Belang**: a real fantasy beast companion, see below *(direction approved by leoxent)* |
  | Sisik Naga | Same name as key piece 2; reads as a gift from the Naga | **Kulit Besi** |
  | Gigit Bujang Senang | Reads as a gift from Bujang Senang | **Gigitan Buaya** |
  | Langkah Bunian | Reads as a gift from the Bunian | **Langkah Halus** (effect kept as is, by leoxent: a brief step into the hidden world; note: this brushes the "we do not trespass" border rule, so frame it as a glimpse at the edge, never entering their village) |
  | Semangat Padi, Firasat, Lidah Bertuah | fine | keep |

**Siulan Belang: the beast companion** *(option A approved by leoxent, 2026-11-21: a real
creature bonded by kindness, with its own fantasy look; details below are proposed)*
- **What it is.** Not a jin, roh, harimau jadian or harimau saka/belaan. It is a **flesh-and-blood
  animal of this fantasy world**: a rare great tiger species of the Sungai Seri forests, created
  by God like any animal. It eats, sleeps, gets hurt, and others of its kind live wild in the
  forest (seen in Rimba Bunian). Like a creature in Monster Hunter, not a summon from another world.
- **No pact.** The bond comes from kindness, not a contract, offering or inheritance. The Bakat is
  the player's talent: animals trust them.
- **Origin.** In prologue mission 5 (the hunt), a player with this Bakat finds a **young** beast
  caught in an Ordo iron snare, or sick from the nailed stone's poison, and frees or treats it.
  Other players never see this scene (or the beast just runs off).
- **It grows with the Bakat.** Level 1: young, quick, small hits. Level 3: adult, guards the farm
  at night. Level 5: full size, rideable *(expensive: riding needs mount animations on 8 player
  bodies, so consider cutting or delaying it)*. The growth is shown in the art, so the upgrade
  path is also the story of the friendship.
- **How the call works.** The player whistles; the beast **runs in from the edge of the screen or
  out of the undergrowth**. It never appears from smoke or light. It cannot come into houses or
  closed caves. When badly hurt it retreats to the forest to rest; it does not die.
- **Fantasy look (proposed).** Bigger than a normal tiger, and its stripes curl like Malay
  woodcarving (ukiran) vines; old folk say "the forest carved its stripes". Keep it clearly
  different from Binatang Berpaku (black seal mark, sick, raging) and bound beings (translucent,
  chained, seal marked). Glows, if any, are small natural ones (eyes at night), never a ghostly
  aura.
- **Species name: Belang Kilat** *(chosen by leoxent, 2026-11-21)*. "Kilat" here means **speed**
  (as in "pantas macam kilat"), not lightning power: the tiger is the fast, hard-hitting companion.
  Lightning (Halilintar) is a Pawang Anugerah element, so the tiger has **no electric effects**: no
  sparks, no glow, no lightning attacks. Its look can still nod to the name: sharp zig-zag stripes
  like a lightning fork, mixed with the ukiran curls. (Other candidates were Belang Kencana, Rimau
  Akar and Harimau Gading.)
- The player names their own beast; the default is **Si Belang**.

## Open questions (new; the older ones stay in `game-design.md`)
- How did the player's father die? (Do not link it to Si Raya or the Ordo without deciding.)
- Solat (S26): on hold (KIV).
- Add an Air (water) element (S27)?
- New name for the Pawang class (KIV, candidates in S27).
- Awang's and Kelana's elements (S27)?

