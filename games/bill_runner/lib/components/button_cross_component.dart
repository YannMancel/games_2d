import 'dart:async';
import 'dart:ui';

import 'package:bill_runner/components/_components.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';

class ButtonCrossComponent extends RectangleComponent
    with HasGameReference<BillRunnerGame> {
  ButtonCrossComponent({
    super.key,
    super.position,
    double ratio = 2.5,
    double squareSizeButton = 80.0,
    required VoidCallback onIdle,
    required VoidCallback onPressedTop,
    required VoidCallback onPressedBottom,
    required VoidCallback onPressedLeft,
    required VoidCallback onPressedRight,
  })  : assert(ratio > 2.0, 'The buttons overlap each other.'),
        _squareSizeButton = squareSizeButton,
        _onIdle = onIdle,
        _onPressedTop = onPressedTop,
        _onPressedBottom = onPressedBottom,
        _onPressedLeft = onPressedLeft,
        _onPressedRight = onPressedRight,
        super(
          size: Vector2.all(ratio * squareSizeButton),
          anchor: Anchor.bottomRight,
          paint: BasicPalette.transparent.paint(),
        );

  final double _squareSizeButton;
  final VoidCallback _onIdle;
  final VoidCallback _onPressedTop;
  final VoidCallback _onPressedBottom;
  final VoidCallback _onPressedLeft;
  final VoidCallback _onPressedRight;

  @override
  FutureOr<void> onLoad() async {
    final image = game.images.fromCache('joystick_sprite_sheet.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 6,
      rows: 1,
    );
    final upButtonSprite = sheet.getSpriteById(4);
    final downButtonSprite = sheet.getSpriteById(2);
    final sizeButton = Vector2.all(_squareSizeButton);
    final configurations = <({
      Vector2 position,
      Anchor anchor,
      VoidCallback onPressed,
    })>[
      (
        position: Vector2(size.x / 2.0, 0),
        anchor: Anchor.topCenter,
        onPressed: _onPressedTop,
      ),
      (
        position: Vector2(size.x / 2.0, size.y),
        anchor: Anchor.bottomCenter,
        onPressed: _onPressedBottom,
      ),
      (
        position: Vector2(0.0, size.y / 2.0),
        anchor: Anchor.centerLeft,
        onPressed: _onPressedLeft,
      ),
      (
        position: Vector2(size.x, size.y / 2.0),
        anchor: Anchor.centerRight,
        onPressed: _onPressedRight,
      ),
    ];

    for (final configuration in configurations) {
      final component = BillRunnerButton(
        defaultButton: upButtonSprite,
        downButton: downButtonSprite,
        position: configuration.position,
        size: sizeButton,
        anchor: configuration.anchor,
        onChanged: (state) {
          final callback = switch (state) {
            BillRunnerButtonState.up => _onIdle,
            BillRunnerButtonState.down => configuration.onPressed,
          };
          callback();
        },
      );

      add(component);
    }
  }
}
