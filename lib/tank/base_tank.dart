import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;
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
  BaseTank({this.life = 1, super.position, this.speed = 100})
    : direction = MoveDirection.up {
    size = Vector2.all(gridSize * gridCount);
  }

  late Image cellImage;

  /// 坦克的生命值
  int life;

  /// 坦克的移动速度
  double speed;

  /// 坦克绘制的表述数组
  abstract List<List<int>> tankCells;

  /// 当前的坦克对于的绘制表格数据
  List<int> currentTankCells = [];

  /// 坦克的移动方向
  Vector2 direction;

  /// 坦克的核心颜色值
  Color heartColor = Colors.transparent;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    cellImage = await CanvasUtils.createCellImage(
      size: gridSize,
      renderColor: Colors.black,
    );
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

  /// 是否会与其他坦克的格子发生碰撞
  /// - [offset] 偏移量，被碰撞坦克的偏移位置
  /// - [tankCells] 被碰撞坦克的格子数据, 用来计算碰撞矩形
  bool isCollideWithTankCells({
    required Vector2 offset,
    required List<int> tankCells,
  }) {
    Set<Rect> allOtherTankRects = {};
    for (int i = 0; i < tankCells.length; i++) {
      int x = i % gridCount;
      int y = i ~/ gridCount;
      if (tankCells[i] != 0) {
        allOtherTankRects.add(
          (offset + Vector2(x * gridSize, y * gridSize)).toPositionedRect(
            Vector2.all(gridSize),
          ),
        );
      }
    }
    for (int i = 0; i < currentTankCells.length; i++) {
      int x = i % gridCount;
      int y = i ~/ gridCount;
      if (currentTankCells[i] != 0) {
        var rect = (position + Vector2(x * gridSize, y * gridSize))
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
    gameRef.board?.add(
      Bullet(
        speed: speed,
        ownerType: ownerType,
        direction: direction,
        size: Vector2.all(BaseTank.gridSize),
        position: position + Vector2.all(1.0) * BaseTank.gridSize,
      ),
    );
  }

  /// 当坦克移动出范围后，调整坦克位置
  void adjustTankPositionIfOutRange() {
    if (gameRef.board != null) {
      if (position.x <= 0) {
        position.x = 0;
      }
      if (position.y <= 0) {
        position.y = 0;
      }
      if (position.x >= gameRef.board!.size.x - size.x) {
        position.x = gameRef.board!.size.x - size.x;
      }
      if (position.y >= gameRef.board!.size.y - size.y) {
        position.y = gameRef.board!.size.y - size.y;
      }
    }
  }

  /// 判断坦克移动出一段距离，是否抛出屏幕
  bool testIsOutOfWallRange(Vector2 moveOffset) {
    if (gameRef.board != null) {
      if (position.x + moveOffset.x <= 0) {
        return true;
      }
      if (position.y + moveOffset.y <= 0) {
        return true;
      }
      if (position.x >= gameRef.board!.size.x - size.x + moveOffset.x) {
        return true;
      }
      if (position.y >= gameRef.board!.size.y - size.y + moveOffset.y) {
        return true;
      }
    }
    return false;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for (int i = 0; i < currentTankCells.length; i++) {
      int x = i % gridCount;
      int y = i ~/ gridCount;
      int value = currentTankCells[i];
      if (value <= 0) continue;
      canvas.drawImage(cellImage, Offset(x * gridSize, y * gridSize), Paint());
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    adjustTankPositionIfOutRange(); // 防止越界的判断处理
  }
}
