import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

enum BillRunnerButtonState { up, down }

class BillRunnerButton extends SpriteGroupComponent<BillRunnerButtonState>
    with TapCallbacks {
  BillRunnerButton({
    required Sprite defaultButton,
    Sprite? downButton,
    super.position,
    super.size,
    super.anchor,
    ValueSetter<BillRunnerButtonState>? onChanged,
  })  : _defaultButton = defaultButton,
        _downButton = downButton,
        _onChanged = onChanged;

  final Sprite _defaultButton;
  final Sprite? _downButton;
  final ValueSetter<BillRunnerButtonState>? _onChanged;

  set state(BillRunnerButtonState state) {
    if (current != state) {
      current = state;
      _onChanged?.call(state);
    }
  }

  @override
  Future<void> onLoad() async {
    sprites = <BillRunnerButtonState, Sprite>{
      BillRunnerButtonState.up: _defaultButton,
      BillRunnerButtonState.down: _downButton ?? _defaultButton,
    };
    current = BillRunnerButtonState.up;
  }

  @override
  void onTapDown(TapDownEvent event) => state = BillRunnerButtonState.down;

  @override
  void onTapUp(TapUpEvent event) => state = BillRunnerButtonState.up;

  @override
  void onTapCancel(TapCancelEvent event) => state = BillRunnerButtonState.up;
}
