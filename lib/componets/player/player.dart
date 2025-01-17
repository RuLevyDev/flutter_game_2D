import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flutter/services.dart';
import 'package:game_2d_demo/componets/Items/checkpoint.dart';
import 'package:game_2d_demo/componets/Items/fruit.dart';
import 'package:game_2d_demo/componets/Items/saw.dart';
import 'package:game_2d_demo/componets/map/colision_block.dart';
import 'package:game_2d_demo/componets/player/custom_hitbox.dart';
import 'package:game_2d_demo/game_demo.dart';

// Enums para los diferentes estados y direcciones del jugador
enum PlayerState {
  idle,
  run,
  jump,
  doubleJump,
  fall,
  hit,
  wallJump,
  appearing,
  desappearing,
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<DemoGame>, KeyboardHandler, CollisionCallbacks {
  final String character;
  final double stepTime = 0.06;

  Player({super.position, this.character = 'Mask Dude'});
  double horizontalInput = 0;
  double speed = 100;

  Vector2 velocity = Vector2.zero();
  Vector2 spawnPoint = Vector2.zero();

  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  final double _gravity = 9.8;
  final double _jumpForce = 260;
  final double _terminalVelocity = 500;

  bool hasDoubleJumped = false;
  bool isJumping = false;
  bool gotHit = false;
  bool checkpointReach = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    priority = 10;
    _loadAllAnimations();
    spawnPoint = position.clone();
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.active,
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!gotHit && !checkpointReach) {
      _updatePlayerMovement(dt);
      _updatePlayerState();
      _checkHorizontalCollisions();
      _addGravity(dt);
      _checkVerticalCollisions();
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);
    final isJumpPressed = keysPressed.contains(LogicalKeyboardKey.space);

    horizontalInput = isRightPressed
        ? 1
        : isLeftPressed
            ? -1
            : 0;

    if (isJumpPressed) {
      jump();
    }
    return super.onKeyEvent(event, keysPressed);
  }

  Future<void> _loadAllAnimations() async {
    final idle = _load32Animation(character, 11, 'Idle');
    final run = _load32Animation(character, 12, 'Run');
    final jump = _load32Animation(character, 1, 'Jump');
    final doubleJump = _load32Animation(character, 6, 'Double Jump');
    final fall = _load32Animation(character, 1, 'Fall');
    final hit = _load32Animation(character, 7, 'Hit');
    final wallJump = _load32Animation(character, 5, 'Wall Jump');
    final appearing = _load96Animation(7, 'Appearing');
    final desappearing = _load96Animation(7, 'Desappearing');

    animations = {
      PlayerState.idle: idle,
      PlayerState.run: run,
      PlayerState.jump: jump,
      PlayerState.doubleJump: doubleJump,
      PlayerState.fall: fall,
      PlayerState.hit: hit,
      PlayerState.wallJump: wallJump,
      PlayerState.appearing: appearing,
      PlayerState.desappearing: desappearing,
    };

    // current = PlayerState.idle;
  }

  SpriteAnimation _load32Animation(String character, int amount, String state) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(32, 32),
      ),
    );
  }

  SpriteAnimation _load96Animation(int amount, String state) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(96),
      ),
    );
  }

//PLAYER STATE
  void _updatePlayerState() {
    PlayerState state = PlayerState.idle;

    // Si se está moviendo horizontalmente
    if (velocity.x < 0 || velocity.x > 0) {
      state = PlayerState.run;
    }
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Si está en el aire y no se está moviendo
    if (isJumping) {
      state = velocity.y < 0 ? PlayerState.jump : PlayerState.fall;
    }

    // Si está realizando un doble salto
    if (hasDoubleJumped) {
      state = PlayerState.doubleJump;
    }

    // Actualiza el estado actual del jugador
    current = state;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalInput * speed;
    position.x += velocity.x * dt;
  }

//PLAYER GRAVITY
  void _addGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y
        .clamp(-_jumpForce, _terminalVelocity); // Limita la velocidad de caída
    position.y += velocity.y * dt;

    // Resetea el salto cuando el jugador toca el suelo
    if (position.y >= game.size.y - height) {
      // Asegúrate de usar `height` del jugador
      position.y = game.size.y -
          height; // Ajusta la posición para estar justo en el suelo
      velocity.y = 0;
      isJumping = false;
      hasDoubleJumped = false;
      // current = PlayerState.idle; // Cambia el estado a inactivo
    }
  }

//PLAYER ACTIONS
  void jump() {
    if (velocity.y == 0) {
      // Primer salto
      velocity.y = -_jumpForce;
      isJumping = true;
      hasDoubleJumped = false; // Resetea el doble salto
      current = PlayerState.jump;
    } else if (isJumping && !hasDoubleJumped) {
      // Doble salto (si está en el aire y cerca del punto más alto del primer salto)
      if (velocity.y < -(_jumpForce * 0.5)) {
        velocity.y = -_jumpForce;
        hasDoubleJumped = true;
        current = PlayerState.doubleJump;
      }
    }
  }

  void _respawn() {
    gotHit = true;
    current = PlayerState.hit;
    Future.delayed(const Duration(milliseconds: 150), () {
      current = PlayerState.desappearing;
    });
    Future.delayed(const Duration(milliseconds: 550), () {
      position = spawnPoint - Vector2.all(32);
      current = PlayerState.appearing;
    });
    Future.delayed(const Duration(milliseconds: 950), () {
      scale.x = 1;
      position = spawnPoint;
      gotHit = false;
      _updatePlayerState();
    });
  }

  void _reachedCeckpoint() {
    checkpointReach = true;
    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }
    current = PlayerState.desappearing;
    Future.delayed(const Duration(milliseconds: 350), () {
      checkpointReach = false;
      position = position + Vector2.all(-640);
      current = PlayerState.appearing;
    });

    Future.delayed(const Duration(seconds: 3), () {
      //switch to next level
      game.loadNextLevel();
    });
  }

// COLLISION CONTROLLER
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!checkpointReach) {
      if (other is Fruit) other.collect();
      if (other is Saw) _respawn();
      if (other is Checkpoint && !checkpointReach) _reachedCeckpoint();
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is CollisionBlock) {
      collisionBlocks.add(other);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  bool checkCollision(player, block) {
    final fixedY = block.isPlatform
        ? (player.position.y + hitbox.offsetY) + hitbox.height
        : player.position.y + hitbox.offsetY;
    final fixeX = player.scale.x < 0
        ? (player.position.x + hitbox.offsetX) -
            (hitbox.offsetX * 2) -
            hitbox.width
        : player.position.x + hitbox.offsetX;
    return (fixeX < block.position.x + block.size.x &&
        fixeX + hitbox.width > block.position.x &&
        fixedY < block.position.y + block.size.y &&
        player.position.y + hitbox.offsetY + hitbox.height > block.position.y);
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.offsetX + hitbox.width;
          }
        }
      }
    }
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            // Colisión hacia abajo
            position.y = block.y -
                height; // Ajusta la posición del jugador para estar justo encima del bloque
            velocity.y = 0;
            isJumping = false;
            hasDoubleJumped = false;
            // current = PlayerState.idle;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            // Colisión hacia abajo
            position.y = block.y -
                height; // Ajusta la posición del jugador para estar justo encima del bloque
            velocity.y = 0;
            isJumping = false;
            hasDoubleJumped = false;
            // current = PlayerState.idle;
          } else if (velocity.y < 0) {
            // Colisión hacia arriba
            position.y = block.y + block.height;
            velocity.y = 0;
          }
        }
      }
    }
  }
}
