import 'dart:async';

import 'package:flame/components.dart';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:game_2d_demo/componets/player/player.dart';

import 'package:game_2d_demo/componets/map/level.dart';
// import 'package:flutter/material.dart';

class DemoGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  Player player = Player(character: 'Mask Dude');
  late CameraComponent cam;
  late final JoystickComponent joystick;
  bool showJoystick = false;
  List<String> levelNames = [
    'Level-1',
    'Level-2',
  ];
  int currentLevel = 0;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  FutureOr<void> onLoad() async {
    priority = 10;
    // Load all images into the cache
    await images.loadAllImages();

    _loadLevel();
    if (showJoystick) {
      addJoyStick();
      addJumpButton();
    }
    // addJoyStick();d
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick(dt);
    }

    super.update(dt);
    // joystick.update(dt);
  }

  void addJoyStick() async {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
      priority: 10,
      position: Vector2(0, size.y - 150),
      size: 150,
      knobRadius: 30,
    );
    await add(joystick);
  }

  void updateJoystick(double dt) {
    switch (joystick.direction) {
      case JoystickDirection.downLeft:
      case JoystickDirection.upLeft:
      case JoystickDirection.left:
        player.horizontalInput = -1;
      // player.controller.direction = PlayerDirection.left;
      case JoystickDirection.downRight:
      case JoystickDirection.upRight:
      case JoystickDirection.right:
        player.horizontalInput = 1;
      // player.controller.direction = PlayerDirection.right;
      case JoystickDirection.idle:
        player.horizontalInput = 0;
        // player.controller.direction = PlayerDirection.none;
        break;
      default:
        break;
    }
  }

  void addJumpButton() async {
    final jumpButton = SpriteButtonComponent(
      button: Sprite(
        images.fromCache('HUD/Joystick.png'),
      ),
      onPressed: () {
        player.jump(); // Llama al método jump() cuando se presiona el botón
      },
      position: Vector2(size.x - 120, size.y - 110),
      size: Vector2(80, 80),
    );
    await add(jumpButton);
  }

  void loadNextLevel() {
    if (currentLevel < levelNames.length - 1) {
      currentLevel++;
      _loadLevel();
    } else {
      // print('No more levels');
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {});
    Level world = Level(
      levelName: levelNames[currentLevel],
      player: player,
    );

    cam = CameraComponent.withFixedResolution(
        width: 660, height: 360, world: world)
      ..priority = 0;
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
  }
}
