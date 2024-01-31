import 'package:bill_runner/components/_components.dart';
import 'package:bill_runner/core/_core.dart';
import 'package:flame/game.dart';

class BillRunnerGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    final player = PlayerComponent();
    final buttonCross = ButtonCrossComponent(
      onPressedTop: () => player.direction = PlayerDirection.top,
      onPressedBottom: () => player.direction = PlayerDirection.bottom,
      onPressedLeft: () => player.direction = PlayerDirection.left,
      onPressedRight: () => player.direction = PlayerDirection.right,
    );
    add(player);
    add(buttonCross);
  }
}
