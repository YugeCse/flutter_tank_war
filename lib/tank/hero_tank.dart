import 'dart:async';

import 'package:flame/game.dart' show Vector2;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyDownEvent, LogicalKeyboardKey;
import 'package:flutter_tank_war/data/move_direction.dart';
import 'package:flutter_tank_war/tank/bullet.dart';
import 'package:flutter_tank_war/tank/base_tank.dart';
import 'package:flutter_tank_war/tank/enemy_tank.dart';

/// 玩家坦克
class HeroTank extends BaseTank {
  /// 构造方法
  HeroTank({super.position, super.speed, super.life = 3});

  @override
  List<List<int>> tankCells = [
    [0, 1, 0, 1, 1, 1, 1, 2, 1], //上
    [1, 1, 0, 2, 1, 1, 1, 1, 0], //右
    [1, 2, 1, 1, 1, 1, 0, 1, 0], //下
    [0, 1, 1, 1, 1, 2, 0, 1, 1], //左
  ];

  /// 判断新的移动方向是否会与其他敌人坦克碰撞
  /// - [targetDirection] 目标方向，用于判断新的移动方向是否会与其他敌人坦克碰撞
  bool _isCollideWithEnemyTanks({required Vector2 targetDirection}) {
    var enemyTanks = gameRef.children.whereType<EnemyTank>();
    var targetCells = tankCells[targetDirection.toCellShapeIndex()];
    return enemyTanks.any(
      (el) => el.isCollideWithTankCells(
        tankCells: targetCells,
        offset: position + targetDirection,
      ),
    );
  }

  @override
  FutureOr<void> onLoad() async {
    direction = MoveDirection.up;
    currentTankCells = tankCells[direction.toCellShapeIndex()];
  }

  /// 处理键盘事件
  KeyEventResult handleKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyJ ||
          event.logicalKey == LogicalKeyboardKey.keyK) {
        fire(ownerType: Bullet.typeOfHeroBullet);
        return KeyEventResult.handled;
      }
      if (keysPressed.intersection({
            LogicalKeyboardKey.keyW,
            LogicalKeyboardKey.arrowUp,
          }).isNotEmpty &&
          !_isCollideWithEnemyTanks(targetDirection: MoveDirection.up)) {
        if (direction != MoveDirection.up) {
          direction = MoveDirection.up;
          currentTankCells = tankCells[direction.toCellShapeIndex()];
          return KeyEventResult.handled;
        }
        position += direction * BaseTank.gridSize;
      } else if (keysPressed.intersection({
            LogicalKeyboardKey.keyD,
            LogicalKeyboardKey.arrowRight,
          }).isNotEmpty &&
          !_isCollideWithEnemyTanks(targetDirection: MoveDirection.right)) {
        if (direction != MoveDirection.right) {
          direction = MoveDirection.right;
          currentTankCells = tankCells[direction.toCellShapeIndex()];
          return KeyEventResult.handled;
        }
        position += direction * BaseTank.gridSize;
      } else if (keysPressed.intersection({
            LogicalKeyboardKey.keyS,
            LogicalKeyboardKey.arrowDown,
          }).isNotEmpty &&
          !_isCollideWithEnemyTanks(targetDirection: MoveDirection.down)) {
        if (direction != MoveDirection.down) {
          direction = MoveDirection.down;
          currentTankCells = tankCells[direction.toCellShapeIndex()];
          return KeyEventResult.handled;
        }
        position += direction * BaseTank.gridSize;
      } else if (keysPressed.intersection({
            LogicalKeyboardKey.keyA,
            LogicalKeyboardKey.arrowLeft,
          }).isNotEmpty &&
          !_isCollideWithEnemyTanks(targetDirection: MoveDirection.left)) {
        if (direction != MoveDirection.left) {
          direction = MoveDirection.left;
          currentTankCells = tankCells[direction.toCellShapeIndex()];
          return KeyEventResult.handled;
        }
        position += direction * BaseTank.gridSize;
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
