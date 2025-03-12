import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart' show debugPrint;
import 'package:flutter_tank_war/data/move_direction.dart';
import 'package:flutter_tank_war/game.dart' show Game;
import 'package:flutter_tank_war/tank/enemy_tank.dart';
import 'package:flutter_tank_war/tank/base_tank.dart' show BaseTank;
import 'package:flutter_tank_war/utils/canvas_utils.dart';

/// 子弹组件
class Bullet extends PositionComponent with HasGameRef<Game> {
  /// Hero的子弹
  static final int typeOfHeroBullet = 0;

  /// 敌人的子弹
  static final int typeOfEnemyBullet = 1;

  /// 构造方法
  Bullet({
    super.size,
    super.position,
    required this.ownerType,
    required this.moveDirection,
    this.speed = 100,
  });

  /// 子弹的拥有者类型
  final int ownerType;

  /// 子弹速度, 默认：100
  double speed;

  /// 子弹移动方向
  final MoveDirection moveDirection;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCell(
      col: 0,
      row: 0,
      cellSize: BaseTank.gridSize,
      renderColor: Colors.black,
    );
  }

  /// 与子弹发生碰撞
  bool isCollideWith(Bullet bullet) {
    return Rect.fromLTWH(
      bullet.position.x,
      bullet.position.y,
      bullet.size.x,
      bullet.size.y,
    ).overlaps(Rect.fromLTWH(position.x, position.y, size.x, size.y));
  }

  /// 与坦克发生碰撞
  bool isCollideWithTank(BaseTank tank) {
    List<Rect> rectList = [];
    for (var i = 0; i < tank.currentTankCells.length; i++) {
      var x = i % BaseTank.gridCount;
      var y = i ~/ BaseTank.gridCount;
      var value = tank.currentTankCells[i];
      if (value != 0) {
        rectList.add(
          Rect.fromLTWH(
            tank.position.x + x * BaseTank.gridSize,
            tank.position.y + y * BaseTank.gridSize,
            BaseTank.gridSize,
            BaseTank.gridSize,
          ),
        );
      }
    }
    var rect = Rect.fromLTWH(position.x, position.y, size.x, size.y);
    debugPrint('rect = ${rect.size}');
    return rectList.any((element) => element.overlaps(rect));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (position.x <= -BaseTank.gridSize ||
        position.x > gameRef.size.x ||
        position.y <= -BaseTank.gridSize ||
        position.y > gameRef.size.y) {
      removeFromParent();
    } else {
      var allBullet = gameRef.children.whereType<Bullet>();
      for (var bullet in allBullet) {
        if (bullet != this &&
            bullet.ownerType != ownerType &&
            bullet.isCollideWith(this)) {
          removeFromParent();
          bullet.removeFromParent();
        }
      }
      if (ownerType == typeOfHeroBullet) {
        var allEnemyTanks = gameRef.children.whereType<EnemyTank>();
        for (var enemyTank in allEnemyTanks) {
          if (isCollideWithTank(enemyTank)) {
            removeFromParent();
            enemyTank.removeFromParent();
          }
        }
      }
      position += moveDirection.vector * dt * speed;
    }
  }
}
