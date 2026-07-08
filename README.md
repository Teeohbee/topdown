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

### 3 - Tile Collision

- **Collision is opt-in per tile, not global on the TileSet** - each atlas cell gets its own
  `physics_layer_0/polygon_0/points`; tiles with no polygon (e.g. floor) simply have no collision.
- **Collision layer is set once, on the TileSet resource** - `physics_layer_0/collision_layer`
  controls which physics bitmask the shape broadcasts on; it's separate from the per-tile polygon,
  which only defines whether/what shape exists.
- **Polygon points are centre-relative** - for a 16x16 tile, corners are at ±8, not 0-16, because
  shapes are positioned relative to the tile's centre origin, not its top-left corner.
- **Animated tiles share one collision shape across all frames** - collision is tied to the tile's
  logical identity, not the currently-rendered animation frame, since physics and visuals are
  independent properties on the same tile.

### 4 - Particle Effects

- **GPUParticles2D as a child node** - attached directly to the player scene so the effect follows
  movement for free, no extra positioning code.
- **Ring emission shape** - `emission_shape = 6` with inner/outer radius produces a ring rather
  than a filled disc, useful for glow/aura effects around a point.
- **Additive blend mode** - `CanvasItemMaterial.blend_mode = 1` makes overlapping particles brighten
  rather than occlude, which reads as light/glow instead of solid sprites.
- **Alpha curve over a flat fade** - a `Curve`/`CurveTexture` driving `alpha_curve` gives a
  fade-in-then-out shape instead of linear fade, so particles appear then dissipate more naturally.
