import 'dart:async';

import 'package:bill_runner/components/_components.dart';
import 'package:bill_runner/core/_core.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

class BillRunnerGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await images.loadAll(
      <String>[
        'background.png',
        'player_sprite_sheet.png',
        'joystick_sprite_sheet.png',
      ],
    );

    final halfCanvasSize = canvasSize / 2.0;
    final background = BackgroundComponent();
    final player = PlayerComponent(position: halfCanvasSize);
    final buttonCross = ButtonCrossComponent(
      position: canvasSize,
      onPressedTop: () => player.direction = PlayerDirection.top,
      onPressedBottom: () => player.direction = PlayerDirection.bottom,
      onPressedLeft: () => player.direction = PlayerDirection.left,
      onPressedRight: () => player.direction = PlayerDirection.right,
    );

    // We need background.size to set camera bounds
    await world.add(background);
    world.addAll(
      <Component>[
        player,
        buttonCross,
      ],
    );

    camera = CameraComponent(
      world: world,
      hudComponents: <Component>[buttonCross],
    )
      ..viewfinder.anchor = Anchor.center
      ..follow(player)
      ..setBounds(
        Rectangle.fromPoints(
          halfCanvasSize,
          background.size - halfCanvasSize,
        ),
        considerViewport: true,
      );

    debugMode = true;
  }
}
