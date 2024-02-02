import 'dart:async';

import 'package:bill_runner/components/_components.dart';
import 'package:flame/components.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameReference<BillRunnerGame> {
  BackgroundComponent({super.key});

  @override
  FutureOr<void> onLoad() async {
    sprite = await game.loadSprite('background.png');
    size = sprite!.originalSize;
  }
}
