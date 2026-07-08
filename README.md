# Topdown

A true top-down 2D game built in Godot 4.7, following the
[Catlike Coding tutorial series](https://catlikecoding.com/godot/true-top-down-2d/).

Open `project.godot` in Godot 4.7+ to run.

---

## Concepts & Learnings

### 1 - Tile Map

- **Texture atlas over individual images** - one sprite sheet reduces draw calls and simplifies
  tile management; requires planning for animation frames upfront.
- **TileMapLayer over TileMap** - Godot's move toward single-responsibility nodes; each layer is
  independently manageable.
- **Random tile variants** - breaks visual repetition without extra assets; uniform tiles create
  obvious pattern recognition.
- **Random animation start time** - prevents all water tiles animating in sync, which looks
  artificial.
- **Nearest-neighbour filtering** - linear interpolation blurs pixel art at any non-integer scale;
  Nearest preserves crisp edges.
- **Integer scaling only** - fractional pixel mapping introduces anti-aliasing incompatible with
  pixel art; logical resolution (400×240) is kept separate from display size via viewport
  stretching.

### 2 - Player Character (scene + movement)

- **CharacterBody2D** needs Motion Mode set to **Floating** - the default is designed for
  platformers (gravity-aware); Floating treats all axes equally, as required for top-down.
- **Circular collision shape** - smaller than the tile (6px radius vs 16px tile) to leave room to
  manoeuvre through gaps.
- **Texture filter on the sprite node, not the project** - Nearest set per-node keeps the gradient
  sprite pixel-crisp without a global setting.
- **`Input.get_vector()` argument order** - `(negative_x, positive_x, negative_y, positive_y)`,
  i.e. `("ui_left", "ui_right", "ui_up", "ui_down")`. Easy to get backwards.
- **Analog input comes for free** - multiplying the input vector by speed means controller sticks
  produce variable speed naturally; no extra code needed.
- **Diagonal sub-pixel movement is fine** - low resolution + nearest filtering means the character
  looks pixel-aligned even when moving fractional distances diagonally.
