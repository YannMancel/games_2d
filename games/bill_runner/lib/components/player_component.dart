import 'dart:async';

import 'package:flame/components.dart';

class PlayerComponent extends SpriteComponent with HasGameReference {
  PlayerComponent({
    super.key,
  }) : super(
          size: Vector2.all(squareSize),
        );

  static const squareSize = 50.0;

  @override
  FutureOr<void> onLoad() async {
    sprite = await game.loadSprite('player.png');
    position = game.size / 2.0;
  }
}
