import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_2d_demo/componets/Items/checkpoint.dart';
import 'package:game_2d_demo/componets/Items/fruit.dart';
import 'package:game_2d_demo/componets/Items/saw.dart';
import 'package:game_2d_demo/componets/map/background_tile.dart';
import 'package:game_2d_demo/componets/map/colision_block.dart';
import 'package:game_2d_demo/componets/player/player.dart';
import 'package:game_2d_demo/game_demo.dart';

class Level extends World with HasGameRef<DemoGame> {
  final String levelName;
  final Player player;

  Level({
    required this.levelName,
    required this.player,
  });

  late TiledComponent level;
  List<CollisionBlock> collisionComponent = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level..priority = 10);

    _scrolingBackground();
    _spawnObjects();
    _addCollisions();

    return super.onLoad();
  }

//Vertical scrolling background
  void _scrolingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');

    const tileSize = 64;
    final numTilesY = (gameRef.size.y / tileSize).floor();
    final numTilesX =
        (gameRef.size.x / tileSize).floor() - 3; // -3tiles to avoid overflow

    if (backgroundLayer != null) {
      final bg = backgroundLayer.properties.getValue('BackgroundColor');

      for (double y = 0; y < game.size.y / numTilesY; y++) {
        for (double x = 0; x < numTilesX; x++) {
          final bgTile = BackgroundTile(
            color: bg ?? 'Gray',
            position: Vector2(x * tileSize, y * tileSize - tileSize),
          );
          add(bgTile);
        }
      }
      final bgTile =
          BackgroundTile(color: bg ?? 'Gray', position: Vector2(0, 0));
      add(bgTile);
    }
  }

//Spawn objects
  void _spawnObjects() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');
    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = spawnPoint.position;
            add(player);
            break;
          case 'Fruit':
            final fruit = Fruit(
                fruitType: spawnPoint.name,
                position: spawnPoint.position,
                size: spawnPoint.size);
            add(fruit);
            break;
          case 'Saw':
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final saw = Saw(
                isVertical: isVertical,
                offNeg: offNeg,
                offPos: offPos,
                position: spawnPoint.position,
                size: spawnPoint.size);
            add(saw);
            break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: spawnPoint.position,
              size: spawnPoint.size,
            );
            add(checkpoint);
          default:
        }
      }
    }
  }

//Add map collisions
  void _addCollisions() {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: collision.position,
              size: collision.size,
              isPlatform: true,
            );
            collisionComponent.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: collision.position,
              size: collision.size,
            );
            collisionComponent.add(block);
            add(block);
        }

        // add(collisionComponent);
      }
    }
    player.collisionBlocks = collisionComponent;
  }
}
