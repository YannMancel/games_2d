import 'package:bill_runner/components/_components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: BillRunnerGame(),
    );
  }
}
