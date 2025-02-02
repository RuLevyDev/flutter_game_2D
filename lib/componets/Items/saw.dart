import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_2d_demo/componets/player/custom_hitbox.dart';
import 'package:game_2d_demo/game_demo.dart';

class Saw extends SpriteAnimationComponent
    with HasGameRef<DemoGame>, CollisionCallbacks {
  bool isVertical;
  double offNeg;
  double offPos;
  // Saw(
  //     {this.isVertical = false,
  //     this.offNeg = 0,
  //     this.offPos = 0,
  //     position,
  //     size})
  //     : super(
  //         position: position,
  //         size: size,
  //       );
  Saw({
    super.position,
    super.size,
    this.isVertical = false,
    this.offNeg = 0,
    this.offPos = 0,
  });

  static const double sawSpeed = 0.039;
  static const double moveSpeed = 50;
  static const tileSize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;

  final hitbox = CustomHitbox(offsetX: 0, offsetY: 0, width: 10, height: 10);

  @override
  FutureOr<void> onLoad() {
    debugMode = false;

    add(
      CircleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        radius: 15.5,
        collisionType: CollisionType.passive,
      ),
    );
    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Saw/On (38x38).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: sawSpeed,
        textureSize: Vector2.all(38),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      _moveVertical(dt);
    } else {
      _moveHorizontal(dt);
    }
    super.update(dt);
  }

  void _moveVertical(double dt) {
    if (position.y < rangeNeg) {
      moveDirection = 1;
    } else if (position.y > rangePos) {
      moveDirection = -1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontal(double dt) {
    if (position.x < rangeNeg) {
      moveDirection = 1;
    } else if (position.x > rangePos) {
      moveDirection = -1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}
