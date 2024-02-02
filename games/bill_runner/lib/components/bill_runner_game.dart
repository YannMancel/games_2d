import 'package:bill_runner/components/_components.dart';
import 'package:bill_runner/core/_core.dart';
import 'package:flame/components.dart';
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
    final player = PlayerComponent(position: canvasSize / 2.0);
    final buttonCross = ButtonCrossComponent(
      position: canvasSize,
      onPressedTop: () => player.direction = PlayerDirection.top,
      onPressedBottom: () => player.direction = PlayerDirection.bottom,
      onPressedLeft: () => player.direction = PlayerDirection.left,
      onPressedRight: () => player.direction = PlayerDirection.right,
    );

    world.addAll(
      <Component>[
        background,
        player,
        buttonCross,
      ],
    );

    camera = CameraComponent.withFixedResolution(
      width: canvasSize.x,
      height: canvasSize.y,
      hudComponents: [buttonCross],
    )..follow(player);
  }
}
