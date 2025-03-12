import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_tank_war/data/move_direction.dart';
import 'package:flutter_tank_war/game.dart';
import 'package:flutter_tank_war/tank/bullet.dart' show Bullet;
import 'package:flutter_tank_war/utils/canvas_utils.dart';

/// 坦克基类
abstract class Tank extends PositionComponent with HasGameRef<Game> {
  /// 坦克的格子数
  static const int gridCount = 3;

  /// 坦克的格子大小
  static double gridSize = 20;

  /// 坦克的移动方向
  MoveDirection moveDirection = MoveDirection.up;

  /// 坦克的移动速度
  double moveSpeed = 100;

  /// 坦克的核心颜色值
  Color heartColor = Colors.transparent;

  /// 坦克绘制的表述数组
  abstract List<List<int>> tankCells;

  /// 当前的坦克对于的绘制表格数据
  List<int> currentTankCells = [];

  /// 根据移动方向获取对应的绘制表格数据
  List<int> getTankCell(MoveDirection md) {
    currentTankCells = tankCells[md.value];
    return currentTankCells;
  }

  Tank() {
    size = Vector2.all(gridSize * gridCount);
  }

  /// 根据当前方向，返回下一个位置
  MoveDirection generateRandomDirection() {
    return MoveDirection.all[Random(
      DateTime.now().millisecondsSinceEpoch,
    ).nextInt(MoveDirection.all.length)];
  }

  /// 判断是否与另一个坦克碰撞
  bool isCollideWithTank(Tank tank) {
    var otherRect = Rect.fromLTWH(
      tank.position.x,
      tank.position.y,
      tank.size.x,
      tank.size.y,
    );
    return Rect.fromLTWH(
      position.x,
      position.y,
      size.x,
      size.y,
    ).overlaps(otherRect);
  }

  /// 开火、开炮
  /// - [ownerType] 开火者类型, [Bullet.typeOfEnemyBullet], [Bullet.typeOfHeroBullet]
  /// - [speed] 子弹速度, 默认：100
  void fire({required int ownerType, double speed = 100}) {
    Vector2 adjustVector =
        moveDirection == MoveDirection.up ? Vector2(1, -1) : Vector2(1, 1);
    gameRef.add(
      Bullet(
        ownerType: ownerType,
        speed: speed,
        moveDirection: moveDirection,
        size: Vector2.all(Tank.gridSize),
        position: position + adjustVector * Tank.gridSize,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for (int i = 0; i < currentTankCells.length; i++) {
      int x = i % gridCount;
      int y = i ~/ gridCount;
      int value = currentTankCells[i];
      canvas.drawCell(
        col: x,
        row: y,
        cellSize: gridSize,
        renderColor: value != 0 ? Colors.black : Colors.transparent,
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (position.x <= 0) {
      position.x = 0;
    } else if (position.x >= gameRef.size.x - size.x) {
      position.x = gameRef.size.x - size.x;
    } else if (position.y <= 0) {
      position.y = 0;
    } else if (position.y >= gameRef.size.y - size.y) {
      position.y = gameRef.size.y - size.y;
    }
  }
}
