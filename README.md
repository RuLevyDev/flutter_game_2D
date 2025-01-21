
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
=======


#### Properties:
- `player`: Instance of the `Player` class, representing the playable character.
- `cam`: A fixed-resolution camera component.
- `joystick`: A virtual joystick for player movement.
- `showJoystick`: Boolean flag to indicate if the joystick should be displayed.
- `levelNames`: List of available level names.
- `currentLevel`: Index of the current level.

#### Methods:
- `onLoad()`: Loads initial resources and sets up the first level.
- `addJoyStick()`: Adds a virtual joystick to the game interface.
- `addJumpButton()`: Adds a jump button for player control.
- `updateJoystick(double dt)`: Updates the player's direction based on joystick input.
- `loadNextLevel()`: Loads the next level in the sequence.
- `_loadLevel()`: Creates an instance of the current level and assigns it to the camera.

---

### **4. Player**
- **Location:** `components/player/player.dart`
- **Description:** Represents the main character in the game.

#### Properties:
- `character`: The name of the character (e.g., `'Mask Dude'`).
- `horizontalInput`: Horizontal movement input (-1 for left, 1 for right, 0 for none).
- Includes methods like `jump()`, defined in the respective file.

---

### **5. Level**
- **Location:** `components/map/level.dart`
- **Description:** Represents a game level.

#### Properties:
- `levelName`: The name of the level.
- `player`: Reference to the player associated with the level.

---

### **6. Main**
- **Location:** `main.dart`
- **Description:** The entry point of the game. Configures the device for fullscreen and landscape mode.

#### Flow:
1. Creates an instance of `DemoGame`.
2. Sets the screen to fullscreen mode.
3. Runs the game in a `GameWidget`.

```dart
void main() async {
  DemoGame game = DemoGame();
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(GameWidget(
    game: kDebugMode ? DemoGame() : game,
  ));
}
```

---

## **Project Structure**

```plaintext
main.dart
   ├── DemoGame
   │      ├── Level
   │      ├── Player
   │      └── BackgroundTile
   ├── UI (Joystick and buttons)
   └── Camera
```

---

## **Resources**

- **Sprites:** Located in the `assets/` folder.
  - Backgrounds: `assets/Background/`
  - UI (Joystick and buttons): `assets/HUD/`
  - Characters: `assets/Player/`

- **Camera Resolution:**
  - Fixed width: `660`
  - Fixed height: `360`

---
