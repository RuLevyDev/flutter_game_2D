import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_2d_demo/componets/player/custom_hitbox.dart';
import 'package:game_2d_demo/componets/player/player.dart';
import 'package:game_2d_demo/game_demo.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<DemoGame>, CollisionCallbacks {
  final String fruitType;
  Fruit({
    this.fruitType = 'Apple',
    position,
    size,
  }) : super(
          position: position,
          size: size,
          priority: 10,
        );
  final double speed = 0.039;
  bool _collected = false;
  final hitbox = CustomHitbox(offsetX: 10, offsetY: 10, width: 12, height: 12);

  @override
  FutureOr<void> onLoad() {
    debugMode = false;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruitType.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: speed,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }

  void collect() {
    if (!_collected) {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: speed,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );
      // print(' collected $fruitType');
      _collected = true;
      // removeFromParent();
      removeOnFinish = true;
    }
  }
}
