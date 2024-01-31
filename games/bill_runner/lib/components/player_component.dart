import 'dart:async';

import 'package:bill_runner/core/_core.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class PlayerComponent extends SpriteComponent with HasGameReference {
  PlayerComponent({
    super.key,
    double squareSize = 50.0,
    double step = 50.0,
  })  : _step = step,
        super(
          size: Vector2.all(squareSize),
        );

  final double _step;
  late SpriteSheet _sheet;
  late PlayerDirection _direction;
  set direction(PlayerDirection direction) => _direction = direction;

  @override
  FutureOr<void> onLoad() async {
    final image = await game.images.load('player_sprite_sheet.png');
    _sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 4,
      rows: 4,
    );
    sprite = _sheet.getSprite(0, 0);
    position = game.size / 2.0;
    _direction = PlayerDirection.idle;
  }

  @override
  void update(double dt) {
    final zeroPosition = Vector2.zero();
    switch (_direction) {
      case PlayerDirection.idle:
        /* Do nothing here */
        break;
      case PlayerDirection.top:
        position.add(zeroPosition..y = -_step);
        sprite = _sheet.getSprite(2, 0);
      case PlayerDirection.bottom:
        position.add(zeroPosition..y = _step);
        sprite = _sheet.getSprite(0, 0);
      case PlayerDirection.left:
        position.add(zeroPosition..x = -_step);
        sprite = _sheet.getSprite(1, 0);
      case PlayerDirection.right:
        position.add(zeroPosition..x = _step);
        sprite = _sheet.getSprite(3, 0);
    }

    _direction = PlayerDirection.idle;
  }
}
