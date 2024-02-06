import 'dart:async';

import 'package:bill_runner/components/_components.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

class BillRunnerGame extends FlameGame with HasCollisionDetection {
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
    final player = PlayerComponent(
      position: halfCanvasSize,
      bounds: map.size,
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
          map.size - halfCanvasSize,
        ),
        considerViewport: true,
      );

    debugMode = true;
  }
}
