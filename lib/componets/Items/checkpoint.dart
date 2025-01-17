import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_2d_demo/componets/player/custom_hitbox.dart';
import 'package:game_2d_demo/componets/player/player.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  final String checkpointType;
  Checkpoint({
    this.checkpointType = 'Checkpoint (No Flag)',
    position,
    size,
  }) : super(
          position: position,
          size: size,
          priority: 1,
        );
  // final double speed = 0.039;
  bool checkpointReach = false;

  CustomHitbox hitbox = CustomHitbox(
    offsetX: 16,
    offsetY: 12,
    width: 12,
    height: 48,
  );
  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Checkpoint/$checkpointType.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(65),
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !checkpointReach) _reachedCheckpoint();
    super.onCollision(intersectionPoints, other);
  }

  void _reachedCheckpoint() {
    checkpointReach = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 26,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );

    Future.delayed(const Duration(milliseconds: 1300), () {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
        SpriteAnimationData.sequenced(
          amount: 10,
          stepTime: 0.05,
          textureSize: Vector2.all(64),
        ),
      );
      removeOnFinish = true;
    });
    removeOnFinish = true;
  }
}
