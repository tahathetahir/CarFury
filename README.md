# 🚗 CarFury — x86 Assembly DOS Racing Game

A real-mode 16-bit DOS racing game written entirely in **NASM x86 Assembly**, featuring a scrolling road, enemy cars, collectibles, collision detection, and a full menu system — all rendered directly to video memory.

> Built as a Semester 2025 project by **24L-0943 & 24L-0677**

---

## 🎮 Gameplay

Dodge enemy cars coming down a three-lane road while collecting bonus items to boost your score. The game speeds up over laps, making survival progressively harder.

- **Move Left** — `A`
- **Move Right** — `D`
- **Pause / Exit** — `ESC` → then `Y` to quit or `N` to resume

---

## ✨ Features

- **Scrolling road** — the screen scrolls downward each timer tick, simulating forward motion
- **3-lane system** — player and enemy cars operate across lanes 1, 2, and 3
- **Enemy cars** — randomly spawned in any lane using a seeded LCG random number generator
- **Bonus collectibles** — heart-shaped bonus objects that increase your score when collected
- **Clock power-up** — a clock collectible that affects game speed/delay
- **Collision detection** — pixel-accurate detection via direct video memory attribute comparison
- **Score & laps tracking** — live score display with lap counter
- **Pause screen** — mid-game pause with confirmation prompt
- **Main menu** — ASCII art title screen with Start / Exit options and decorative trees
- **Hardware interrupt hooking** — keyboard (IRQ 1) and timer (IRQ 0) interrupts are hooked for real-time input and screen scrolling

---

## 🛠️ Technical Details

| Detail | Value |
|---|---|
| Architecture | x86 16-bit Real Mode |
| Assembler | NASM |
| Video Mode | Direct VGA text buffer (`0xB800`) |
| Screen Resolution | 43 rows × 132 columns (Mode `0x54`) |
| Input | IRQ 1 keyboard ISR hook |
| Timing | IRQ 0 timer ISR hook |
| Random Number Gen | LCG seeded from BIOS clock + PIT port `0x40` |
| Target Platform | DOS / DOSBox |

---

## 🏗️ Code Structure

```
c__2_.asm
│
├── Data Segment
│   ├── Game state variables (score, laps, lane, seed, etc.)
│   ├── ASCII art strings (title, menu, pause screen)
│   └── Screen buffer (scrollrow, buffer)
│
├── Utility Functions
│   ├── getTimeSeed / randomNum     — RNG seeding & generation
│   ├── getLaneNumber               — Maps RNG output to lane 1–3
│   ├── offsetCalculator            — Converts (row, col) to video memory offset
│   ├── strlen / strlen2            — String length helpers
│   └── delay                       — Software delay using clock variable
│
├── Rendering Functions
│   ├── clrscr                      — Clears the screen
│   ├── printgreen / printroad      — Draws grass and road
│   ├── printwhite / printyellow    — Draws lane dividers
│   ├── printtrees / drawtree       — Draws decorative trees
│   ├── printCar                    — Renders a car sprite at given position
│   ├── EnemyCars                   — Spawns enemy car in a random lane
│   ├── RenderBonus                 — Draws heart bonus object
│   ├── RenderScoreBlock            — Draws HUD (score, laps, bonus)
│   ├── RenderMenu                  — Draws the main menu
│   └── RenderGame                  — Full game screen render
│
├── Game Logic
│   ├── scrollscreen                — Scrolls video memory downward one row
│   ├── checkCollision              — Checks if player overlaps a given attribute
│   ├── checkScore                  — Increments score when enemy exits screen
│   ├── BonusEncountered            — Handles heart collectible pickup
│   ├── ClockEncountered            — Handles clock collectible pickup
│   └── reset                       — Resets all game state variables
│
├── Interrupt Service Routines
│   ├── ourVeryOwnKbisr             — Custom keyboard ISR (move, pause, exit)
│   └── MoveScreen                  — Custom timer ISR (scroll, spawn enemies)
│
└── Entry Point
    └── start                       — Hooks ISRs, sets video mode, runs game loop
```

---

## 🚀 How to Run

### Using DOSBox

1. Install [DOSBox](https://www.dosbox.com/)
2. Assemble the source:
   ```bash
   nasm c__2_.asm -o carfury.com
   ```
3. Mount and run in DOSBox:
   ```
   mount c /path/to/game
   c:
   carfury.com
   ```

### Requirements

- NASM assembler
- DOSBox (or any real-mode DOS environment)

---

## 📸 Screenshots

> *(Add screenshots of the menu, gameplay, and game-over screen here)*

---

## 👥 Authors

| Roll Number |
|---|
| 24L-0943 |
| 24L-0677 |

*Semester 2025*
