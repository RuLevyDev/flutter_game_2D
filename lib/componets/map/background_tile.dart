import 'dart:async';

import 'package:flame/components.dart';
import 'package:game_2d_demo/game_demo.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<DemoGame> {
  final String color;
  BackgroundTile({
    this.color = 'Gray',
    super.position,
  });

  final double speed = 0.4;
  @override
  FutureOr<void> onLoad() {
    priority = -1;
    size = Vector2.all(64);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += speed;
    double tileSize = 64;
    int scrollHeight = (gameRef.size.y / tileSize).floor();
    if (position.y > tileSize * scrollHeight) {
      position.y = -tileSize;
    }
    super.update(dt);
  }
}
