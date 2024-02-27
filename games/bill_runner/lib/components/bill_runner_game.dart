import 'dart:async';

import 'package:bill_runner/components/_components.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BillRunnerGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  late PlayerComponent _player;

  @override
  Future<void> onLoad() async {
    await images.loadAll(
      <String>[
        'player_sprite_sheet.png',
        'joystick_sprite_sheet.png',
      ],
    );

    final map = await TiledComponent.load('map.tmx', Vector2.all(32.0));
    // We need map.size to set bounds
    await world.add(map);

    final collisionLayer = map.tileMap.getLayer<ObjectGroup>('collision_layer');
    for (final object in collisionLayer!.objects) {
      final collision = CollisionRectangleComponent(
        position: Vector2(object.x, object.y),
        size: Vector2(object.width, object.height),
      );
      world.add(collision);
    }

    final halfCanvasSize = canvasSize / 2.0;
    _player = PlayerComponent(
      position: halfCanvasSize,
      bounds: map.size,
    );
    final buttonCross = ButtonCrossComponent(
      position: canvasSize,
      onIdle: () => _player.direction = PlayerDirection.idle,
      onPressedTop: () => _player.direction = PlayerDirection.top,
      onPressedBottom: () => _player.direction = PlayerDirection.bottom,
      onPressedLeft: () => _player.direction = PlayerDirection.left,
      onPressedRight: () => _player.direction = PlayerDirection.right,
    );

    world.addAll(
      <Component>[
        _player,
        buttonCross,
      ],
    );

    camera = CameraComponent(
      world: world,
      hudComponents: <Component>[buttonCross],
    )
      ..viewfinder.anchor = Anchor.center
      ..follow(_player)
      ..setBounds(
        Rectangle.fromPoints(
          halfCanvasSize,
          map.size - halfCanvasSize,
        ),
        considerViewport: true,
      );

    debugMode = kDebugMode;
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent) {
      _player.direction = switch (event.physicalKey) {
        PhysicalKeyboardKey.arrowUp => PlayerDirection.top,
        PhysicalKeyboardKey.arrowDown => PlayerDirection.bottom,
        PhysicalKeyboardKey.arrowLeft => PlayerDirection.left,
        PhysicalKeyboardKey.arrowRight => PlayerDirection.right,
        _ => PlayerDirection.idle,
      };
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
