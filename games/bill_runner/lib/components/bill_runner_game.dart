import 'dart:async';

import 'package:bill_runner/components/_components.dart';
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

    final background = BackgroundComponent();
    // We need background.size to set bounds
    await world.add(background);

    final halfCanvasSize = canvasSize / 2.0;
    final player = PlayerComponent(
      position: halfCanvasSize,
      bounds: background.size,
    );
    final buttonCross = ButtonCrossComponent(
      position: canvasSize,
      onIdle: () => player.direction = PlayerDirection.idle,
      onPressedTop: () => player.direction = PlayerDirection.top,
      onPressedBottom: () => player.direction = PlayerDirection.bottom,
      onPressedLeft: () => player.direction = PlayerDirection.left,
      onPressedRight: () => player.direction = PlayerDirection.right,
    );

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
