import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart' show debugPrint;
import 'package:flutter_tank_war/data/move_direction.dart';
import 'package:flutter_tank_war/game.dart';
import 'package:flutter_tank_war/tank/bullet.dart' show Bullet;
import 'package:flutter_tank_war/utils/canvas_utils.dart';

/// 坦克基类
abstract class BaseTank extends PositionComponent with HasGameRef<Game> {
  /// 坦克的格子数
  static const int gridCount = 3;

  /// 坦克的格子大小
  static double gridSize = 20;

  /// 构造函数
  BaseTank({
    this.life = 1,
    super.position,
    super.priority,
    super.anchor,
    this.moveDirection = MoveDirection.up,
  }) {
    size = Vector2.all(gridSize * gridCount);
  }

  /// 坦克的生命值
  int life;

  /// 坦克的移动速度
  double moveSpeed = 100;

  /// 坦克绘制的表述数组
  abstract List<List<int>> tankCells;

  /// 当前的坦克对于的绘制表格数据
  List<int> currentTankCells = [];

  /// 坦克的移动方向
  MoveDirection moveDirection;

  /// 坦克的核心颜色值
  Color heartColor = Colors.transparent;

  /// 根据移动方向获取对应的绘制表格数据
  List<int> getTankCell(MoveDirection md) {
    currentTankCells = tankCells[md.value];
    return currentTankCells;
  }

  /// 判断是否与另一个坦克碰撞
  /// - [tank] 另一个坦克
  /// - [intentOffset] 意向偏移量
  bool isCollideWithTank(BaseTank tank, {Vector2? intentOffset}) {
    Vector2 targetMoveOffset = intentOffset ?? Vector2.zero();
    Set<Rect> allOtherTankRects = {};
    for (int i = 0; i < tank.currentTankCells.length; i++) {
      int x = i % gridCount;
      int y = i ~/ gridCount;
      if (tank.currentTankCells[i] != 0) {
        allOtherTankRects.add(
          (tank.position + Vector2(x * gridSize, y * gridSize))
              .toPositionedRect(Vector2.all(gridSize)),
        );
      }
    }
    for (int i = 0; i < currentTankCells.length; i++) {
      int x = i % gridCount;
      int y = i ~/ gridCount;
      if (currentTankCells[i] != 0) {
        var rect = (targetMoveOffset +
                position +
                Vector2(x * gridSize, y * gridSize))
            .toPositionedRect(Vector2.all(gridSize));
        if (allOtherTankRects.any((r) => r.intersect(rect).isEmpty == false)) {
          return true;
        }
      }
    }
    return false;
  }

  /// 开火、开炮
  /// - [ownerType] 开火者类型, [Bullet.typeOfEnemyBullet], [Bullet.typeOfHeroBullet]
  /// - [speed] 子弹速度, 默认：100
  void fire({required int ownerType, double speed = 100}) {
    gameRef.add(
      Bullet(
        ownerType: ownerType,
        speed: speed,
        moveDirection: moveDirection,
        size: Vector2.all(BaseTank.gridSize),
        position: position + Vector2(1, 1) * BaseTank.gridSize,
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
    // 防止越界的判断处理
    if (position.x < 0) {
      position.x = 0;
    } else if (position.y < 0) {
      position.y = 0;
      debugPrint('y: $position.y');
    } else if (position.x > gameRef.size.x - size.x) {
      position.x = gameRef.size.x - size.x;
    } else if (position.y > gameRef.size.y - size.y) {
      position.y = gameRef.size.y - size.y;
    }
  }
}
