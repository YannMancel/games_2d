import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

enum ButtonCrossDirection { idle, top, bottom, left, right }

class ButtonCrossComponent extends Component with HasGameReference {
  ButtonCrossComponent({
    super.key,
    double squareSizeButton = 100.0,
  }) : _squareSizeButton = squareSizeButton;

  final double _squareSizeButton;

  late ButtonCrossDirection _direction;
  ButtonCrossDirection get direction => _direction;
  void resetDirection() => _direction = ButtonCrossDirection.idle;

  @override
  FutureOr<void> onLoad() async {
    resetDirection();

    final image = await game.images.load('joystick_sheet.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 6,
      rows: 1,
    );
    final inactiveButton = sheet.getSpriteById(4);
    final activeButton = sheet.getSpriteById(2);
    final sizeButton = Vector2.all(_squareSizeButton);
    final buttonConfigurations = <({
      Vector2 position,
      VoidCallback onPressed,
    })>[
      (
        position: Vector2(
          game.size.x - (3.0 / 2.0) * _squareSizeButton - 16.0,
          game.size.y - (5.0 / 2.0) * _squareSizeButton - 16.0,
        ),
        onPressed: () => _direction = ButtonCrossDirection.top,
      ),
      (
        position: Vector2(
          game.size.x - (3.0 / 2.0) * _squareSizeButton - 16.0,
          game.size.y - _squareSizeButton / 2.0 - 16.0,
        ),
        onPressed: () => _direction = ButtonCrossDirection.bottom,
      ),
      (
        position: Vector2(
          game.size.x - (5.0 / 2.0) * _squareSizeButton - 16.0,
          game.size.y - (3.0 / 2.0) * _squareSizeButton - 16.0,
        ),
        onPressed: () => _direction = ButtonCrossDirection.left,
      ),
      (
        position: Vector2(
          game.size.x - _squareSizeButton / 2.0 - 16.0,
          game.size.y - (3.0 / 2.0) * _squareSizeButton - 16.0,
        ),
        onPressed: () => _direction = ButtonCrossDirection.right,
      ),
    ];

    for (final configuration in buttonConfigurations) {
      final component = SpriteButtonComponent(
        button: inactiveButton,
        buttonDown: activeButton,
        position: configuration.position,
        size: sizeButton,
        anchor: Anchor.center,
        onPressed: configuration.onPressed,
      );
      add(component);
    }
  }
}
