import 'package:bill_runner/components/_components.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class MyGame extends FlameGame {
  late final SpriteComponent _player;
  late final ButtonCrossComponent _crossButtons;

  @override
  Future<void> onLoad() async {
    _crossButtons = ButtonCrossComponent();
    _player = PlayerComponent(buttonCross: _crossButtons);
    add(_player);
    add(_crossButtons);
  }
}
