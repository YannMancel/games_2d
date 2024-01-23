import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';

enum ButtonCrossDirection { idle, top, bottom, left, right }

class ButtonCrossComponent extends RectangleComponent with HasGameReference {
  ButtonCrossComponent({
    super.key,
    double ratio = 2.5,
    double squareSizeButton = 80.0,
  })  : assert(ratio > 2.0, 'The buttons overlap each other.'),
        _squareSizeButton = squareSizeButton,
        super(
          size: Vector2.all(ratio * squareSizeButton),
          anchor: Anchor.bottomRight,
          paint: BasicPalette.transparent.paint(),
        );

  final double _squareSizeButton;

  ButtonCrossDirection _direction = ButtonCrossDirection.idle;
  ButtonCrossDirection get direction => _direction;
  void resetDirection() => _direction = ButtonCrossDirection.idle;

  @override
  FutureOr<void> onLoad() async {
    position = game.size;

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
      Anchor anchor,
      VoidCallback onPressed,
    })>[
      (
        position: Vector2(size.x / 2.0, 0),
        anchor: Anchor.topCenter,
        onPressed: () => _direction = ButtonCrossDirection.top,
      ),
      (
        position: Vector2(size.x / 2.0, size.y),
        anchor: Anchor.bottomCenter,
        onPressed: () => _direction = ButtonCrossDirection.bottom,
      ),
      (
        position: Vector2(0.0, size.y / 2.0),
        anchor: Anchor.centerLeft,
        onPressed: () => _direction = ButtonCrossDirection.left,
      ),
      (
        position: Vector2(size.x, size.y / 2.0),
        anchor: Anchor.centerRight,
        onPressed: () => _direction = ButtonCrossDirection.right,
      ),
    ];

    for (final configuration in buttonConfigurations) {
      final component = SpriteButtonComponent(
        button: inactiveButton,
        buttonDown: activeButton,
        position: configuration.position,
        size: sizeButton,
        anchor: configuration.anchor,
        onPressed: configuration.onPressed,
      );
      add(component);
    }
  }
}
