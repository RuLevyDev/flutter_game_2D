# **Technical Documentation for Game 2D Demo**

This document provides a detailed explanation of the classes, methods, and functions in the project.

---

## **Classes and Components**

### **1. BackgroundTile**
- **Location:** `components/background_tile.dart`
- **Description:** Represents a background tile that continuously scrolls vertically to create a seamless scrolling effect.

#### Properties:
- `color`: The color of the tile, default is `'Gray'`.
- `speed`: The vertical scrolling speed, default is `0.4`.

#### Methods:
- `onLoad()`: Loads the sprite associated with the tile and sets its size.
- `update(double dt)`: Updates the tile's position on each frame. Resets the tile to the top when it scrolls out of view.

---

### **2. CustomHitbox**
- **Location:** `components/custom_hitbox.dart`
- **Description:** Defines a custom hitbox for interactive game components.

#### Properties:
- `offsetX`: Horizontal offset of the hitbox.
- `offsetY`: Vertical offset of the hitbox.
- `width`: Width of the hitbox.
- `height`: Height of the hitbox.

---

### **3. DemoGame**
- **Location:** `game_demo.dart`
- **Description:** The main class representing the game. Manages the player, levels, camera, and controls.
