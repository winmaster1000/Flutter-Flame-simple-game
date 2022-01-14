import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'player.dart';

class SpaceGame extends FlameGame with PanDetector {
  Offset? _pointerStartPosition;
  Offset? _pointerCurrentPosition;
  final double _joystickRadius = 60;
  final double _deadZoneRadius = 10;

  late Player player;

  @override
  Future<void> onLoad() async {
    await images.load(('simpleSpace_tilesheet@2.png'));

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('simpleSpace_tilesheet@2.png'),
      columns: 8,
      rows: 6,
    );

    player = Player(
      sprite: spriteSheet.getSpriteById(4),
      size: Vector2(64, 64),
      position: size / 2,
    );

    player.anchor = Anchor.center;
    add(player);

    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_pointerStartPosition != null) {
      canvas.drawCircle(
        _pointerStartPosition!,
        _joystickRadius,
        Paint()..color = Colors.grey.withAlpha(100),
      );
    }

    var delta = _pointerCurrentPosition! - _pointerStartPosition!;
    if (delta.distance > _joystickRadius) {
      delta = _pointerStartPosition! +
          (Vector2(delta.dx, delta.dy).normalized() * _joystickRadius).toOffset();
    } else {
      delta = _pointerCurrentPosition!;
    }

    if (_pointerCurrentPosition != null) {
      canvas.drawCircle(
        delta,
        20,
        Paint()..color = Colors.white.withAlpha(100),
      );
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    _pointerStartPosition = info.raw.globalPosition;
    _pointerCurrentPosition = info.raw.globalPosition;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _pointerCurrentPosition = info.raw.globalPosition;
    var delta = _pointerCurrentPosition! - _pointerStartPosition!;

    if (delta.distance > _deadZoneRadius) {
      player.setMoveDirection(
        Vector2(delta.dx, delta.dy),
      );
    } else {
      player.setMoveDirection(Vector2.zero());
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void onPanCancel() {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
  }
}
