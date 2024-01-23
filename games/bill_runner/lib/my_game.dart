import 'package:bill_runner/components/_components.dart';
import 'package:flame/game.dart';

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    final buttonCross = ButtonCrossComponent();
    final player = PlayerComponent(buttonCross);
    add(player);
    add(buttonCross);
  }
}
