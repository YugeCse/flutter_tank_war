import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
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
  MoveDirection moveDirection = MoveDirection.none;

  Color heartColor = Colors.transparent;

  /// 坦克绘制的表述数组
  abstract List<List<int>> tankCells;

  /// 坦克的移动控制定时器
  TimerComponent? _timerComponent;

  ///
  List<int> currentTankCells = [];

  List<int> getTankCell(MoveDirection md) {
    if (md == MoveDirection.none) {
      return currentTankCells;
    }
    currentTankCells = tankCells[md.value];
    return currentTankCells;
  }

  Tank() {
    size = Vector2.all(gridSize * gridCount);
  }

  @override
  FutureOr<void> onLoad() async {
    add(
      _timerComponent = TimerComponent(
        period: 1.0,
        repeat: true,
        onTick: () {
          moveDirection = generateRandomDirection(); // 随机方向
          currentTankCells = getTankCell(moveDirection);
          position += moveDirection.vector * Tank.gridSize; // 移动坦克
          var allTanks = gameRef.children.whereType<Tank>();
          for (var tank in allTanks) {
            if (tank != this && tank.overlaps(this)) {
              position -= moveDirection.vector * Tank.gridSize;
            }
          }
          if (moveDirection != MoveDirection.none &&
              (Random().nextInt(12) + 1) % 3 == 0) {
            Vector2 adjustVector = Vector2(1, 1);
            if (moveDirection == MoveDirection.up) {
              adjustVector = Vector2(1, -1);
            }
            gameRef.add(
              Bullet(
                owner: this,
                size: Vector2.all(gridSize),
                position: position + adjustVector * Tank.gridSize,
              )..moveDiection = moveDirection,
            );
            debugPrint(
              '===>添加字段坐标：$position    ${position + moveDirection.vector}',
            );
          }
        },
      ),
    );
  }

  /// 根据当前方向，返回下一个位置
  MoveDirection generateRandomDirection() {
    return MoveDirection.all[Random(
      DateTime.now().millisecondsSinceEpoch,
    ).nextInt(MoveDirection.all.length)];
  }

  bool overlaps(Tank bullet) {
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
        renderColor: value != 0 ? Colors.red : Colors.transparent,
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (position.x < 0) {
      position.x = 0;
    } else if (position.x > gameRef.size.x - size.x) {
      position.x = gameRef.size.x - size.x;
    } else if (position.y < 0) {
      position.y = 0;
    } else if (position.y > gameRef.size.y - size.y) {
      position.y = gameRef.size.y - size.y;
    }
  }

  @override
  void onRemove() {
    _timerComponent?.removeFromParent();
    super.onRemove();
  }
}
