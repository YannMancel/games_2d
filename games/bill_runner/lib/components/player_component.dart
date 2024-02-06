import 'dart:async';

import 'package:bill_runner/components/_components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

enum PlayerDirection { idle, top, bottom, left, right }

class PlayerComponent extends SpriteAnimationGroupComponent<PlayerDirection>
    with HasGameReference<BillRunnerGame>, CollisionCallbacks {
  PlayerComponent({
    super.key,
    super.position,
    required Vector2 bounds,
    double squareSize = 50.0,
    double animationSpeed = 0.15,
    double playerSpeed = 300.0,
  })  : _bounds = bounds,
        _animationSpeed = animationSpeed,
        _playerSpeed = playerSpeed,
        super(
          size: Vector2.all(squareSize),
          anchor: Anchor.center,
        );

  final Vector2 _bounds;
  final double _animationSpeed;
  final double _playerSpeed;
  late bool _hasCollided;
  late Map<PositionComponent, PlayerDirection?> _collisionDirectionMap;

  void _updatePosition(double dt) {
    final zero = Vector2.zero();
    final step = dt * _playerSpeed;
    final cannotMove =
        _hasCollided && _collisionDirectionMap.values.contains(current);
    final offset = cannotMove
        ? zero
        : switch (current) {
            PlayerDirection.idle || null => zero,
            PlayerDirection.top => zero..y = -step,
            PlayerDirection.bottom => zero..y = step,
            PlayerDirection.left => zero..x = -step,
            PlayerDirection.right => zero..x = step,
          };

    if (offset == Vector2.zero()) return;

    position = (position + offset)
      ..clamp(
        size / 2.0,
        _bounds - (size / 2.0),
      );
  }

  set direction(PlayerDirection direction) => current = direction;

  @override
  FutureOr<void> onLoad() async {
    add(RectangleHitbox());
    _hasCollided = false;
    _collisionDirectionMap = <PositionComponent, PlayerDirection>{};

    final image = game.images.fromCache('player_sprite_sheet.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 4,
      rows: 4,
    );

    final idleAnimation = sheet.createAnimation(
      row: 0,
      stepTime: _animationSpeed,
      to: 1,
    );

    SpriteAnimation.spriteList(
      <Sprite>[
        sheet.getSprite(0, 0),
      ],
      stepTime: _animationSpeed,
    );

    final topAnimation = sheet.createAnimation(
      row: 2,
      stepTime: _animationSpeed,
      to: 4,
    );

    final bottomAnimation = sheet.createAnimation(
      row: 0,
      stepTime: _animationSpeed,
      to: 4,
    );

    final leftAnimation = sheet.createAnimation(
      row: 1,
      stepTime: _animationSpeed,
      to: 4,
    );

    final rightAnimation = sheet.createAnimation(
      row: 3,
      stepTime: _animationSpeed,
      to: 4,
    );

    animations = <PlayerDirection, SpriteAnimation>{
      PlayerDirection.idle: idleAnimation,
      PlayerDirection.top: topAnimation,
      PlayerDirection.bottom: bottomAnimation,
      PlayerDirection.left: leftAnimation,
      PlayerDirection.right: rightAnimation,
    };
    current = PlayerDirection.idle;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updatePosition(dt);
  }

  @override
  void onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollision(intersectionPoints, other);
    if (other is CollisionRectangleComponent) {
      if (!_hasCollided) _hasCollided = true;

      if (!_collisionDirectionMap.keys.contains(other)) {
        _collisionDirectionMap[other] = current;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is CollisionRectangleComponent && _hasCollided) {
      _collisionDirectionMap.remove(other);
      if (_collisionDirectionMap.isEmpty) _hasCollided = false;
    }
  }
}
