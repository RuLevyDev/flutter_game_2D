// bool checkCollision(player, block) {
//   final hitbox = player.hitbox;
//   final playerX = player.position.x + hitbox.offsetX;
//   final playerY = player.position.y + hitbox.offsetY;
//   final playerWidth = hitbox.width;
//   final playerHeight = hitbox.height;

//   final blockX = block.position.x;
//   final blockY = block.position.y;
//   final blockWidth = block.width;
//   final blockHeight = block.height;

//   final fixedX = player.scale.x < 0
//       ? playerX - (hitbox.offsetX * 2) - playerWidth
//       : playerX;
//   final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

//   return fixedY < blockY + blockHeight &&
//       playerY + playerHeight > blockY &&
//       fixedX < blockX + blockWidth &&
//       fixedX + playerWidth > blockX;
// }
