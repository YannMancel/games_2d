import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CollisionRectangleComponent extends PositionComponent {
  CollisionRectangleComponent({
    super.position,
    super.size,
  });

  @override
  FutureOr<void> onLoad() {
    final hitbox = RectangleHitbox(collisionType: CollisionType.passive);
    add(hitbox);
  }
}
