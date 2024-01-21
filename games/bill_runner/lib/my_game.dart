import 'package:bill_runner/components/_components.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class MyGame extends FlameGame {
  late final SpriteComponent player;

  @override
  Future<void> onLoad() async {
    player = PlayerComponent();
    add(player);
  }
}
