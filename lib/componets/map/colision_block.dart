import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform = false;
  CollisionBlock({super.position, super.size, this.isPlatform = false}) {
    debugMode = false;
  }
}
  // : super(
  //         position: position,
  //         size: size,
  //       );
  


  