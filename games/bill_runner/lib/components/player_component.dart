import 'dart:async';

import 'package:bill_runner/components/_components.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class PlayerComponent extends SpriteComponent with HasGameReference {
  PlayerComponent(
    ButtonCrossInterface buttonCross, {
    super.key,
    double squareSize = 50.0,
    double step = 50.0,
  })  : _buttonCross = buttonCross,
        _step = step,
        super(
          size: Vector2.all(squareSize),
        );

  final ButtonCrossInterface _buttonCross;
  final double _step;
  late SpriteSheet _sheet;

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
  }

  @override
  void update(double dt) {
    final zeroPosition = Vector2.zero();
    switch (_buttonCross.direction) {
      case ButtonCrossDirection.idle:
        /* Do nothing here */
        break;
      case ButtonCrossDirection.top:
        position.add(zeroPosition..y = -_step);
        sprite = _sheet.getSprite(2, 0);
      case ButtonCrossDirection.bottom:
        position.add(zeroPosition..y = _step);
        sprite = _sheet.getSprite(0, 0);
      case ButtonCrossDirection.left:
        position.add(zeroPosition..x = -_step);
        sprite = _sheet.getSprite(1, 0);
      case ButtonCrossDirection.right:
        position.add(zeroPosition..x = _step);
        sprite = _sheet.getSprite(3, 0);
    }

    _buttonCross.resetDirection();
  }
}
