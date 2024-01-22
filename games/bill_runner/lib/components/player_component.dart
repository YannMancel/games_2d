import 'dart:async';

import 'package:bill_runner/components/_components.dart';
import 'package:flame/components.dart';

class PlayerComponent extends SpriteComponent with HasGameReference {
  PlayerComponent({
    super.key,
    required ButtonCrossComponent buttonCross,
    double squareSize = 50.0,
    double step = 50.0,
  })  : _buttonCross = buttonCross,
        _step = step,
        super(
          size: Vector2.all(squareSize),
        );

  final ButtonCrossComponent _buttonCross;
  final double _step;

  @override
  FutureOr<void> onLoad() async {
    sprite = await game.loadSprite('player.png');
    position = game.size / 2.0;
  }

  @override
  void update(double dt) {
    final zeroPosition = Vector2.zero();
    final value = switch (_buttonCross.direction) {
      ButtonCrossDirection.idle => zeroPosition,
      ButtonCrossDirection.top => zeroPosition..y = -_step,
      ButtonCrossDirection.bottom => zeroPosition..y = _step,
      ButtonCrossDirection.left => zeroPosition..x = -_step,
      ButtonCrossDirection.right => zeroPosition..x = _step,
    };
    position.add(value);
    _buttonCross.resetDirection();
  }
}
