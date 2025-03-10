import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_tank_war/data/move_direction.dart';
import 'package:flutter_tank_war/game.dart' show Game;
import 'package:flutter_tank_war/tank/tank.dart' show Tank;
import 'package:flutter_tank_war/utils/canvas_utils.dart';

class Bullet extends PositionComponent with HasGameRef<Game> {
  Bullet({super.size, super.position, required this.owner});

  /// 子弹的拥有者
  final Tank owner;

  /// 子弹移动方向
  MoveDirection moveDiection = MoveDirection.none;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCell(
      col: 0,
      row: 0,
      cellSize: Tank.gridSize,
      renderColor: Colors.redAccent,
    );
  }

  bool overlaps(Bullet bullet) {
    var otherRect = Rect.fromLTWH(
      bullet.position.x,
      bullet.position.y,
      bullet.size.x,
      bullet.size.y,
    );
    var rect = Rect.fromLTWH(position.x, position.y, size.x, size.y);
    return rect.overlaps(otherRect);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (position.x < 0 ||
        position.x > gameRef.size.x ||
        position.y < 0 ||
        position.y > gameRef.size.y) {
      removeFromParent();
    } else {
      position += moveDiection.vector * dt * 100;
    }
    var allBullet = gameRef.children.whereType<Bullet>();
    for (var bullet in allBullet) {
      if (bullet != this && bullet.overlaps(this)) {
        bullet.removeFromParent();
        removeFromParent();
      }
    }
  }
}
