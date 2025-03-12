import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show KeyDownEvent, KeyUpEvent, LogicalKeyboardKey;
import 'package:flutter_tank_war/data/move_direction.dart';
import 'package:flutter_tank_war/tank/bullet.dart';
import 'package:flutter_tank_war/tank/base_tank.dart';
import 'package:flutter_tank_war/tank/enemy_tank.dart';

/// 玩家坦克
class HeroTank extends BaseTank {
  /// 构造方法
  HeroTank({super.position});

  @override
  List<List<int>> tankCells = [
    [0, 1, 0, 1, 1, 1, 1, 2, 1], //上
    [1, 1, 0, 2, 1, 1, 1, 1, 0], //右
    [1, 2, 1, 1, 1, 1, 0, 1, 0], //下
    [0, 1, 1, 1, 1, 2, 0, 1, 1], //左
  ];

  /// 玩家按下的键
  final Set<LogicalKeyboardKey> _playerPressedKeys = {};

  /// 判断玩家是否按下了某些键
  bool _isKeysPressed(Set<LogicalKeyboardKey> keys) =>
      _playerPressedKeys.intersection(keys).isNotEmpty;

  @override
  FutureOr<void> onLoad() async {
    currentTankCells = getTankCell(MoveDirection.up);
  }

  @override
  void update(double dt) {
    super.update(dt);
    var enemyTanks = gameRef.children.whereType<EnemyTank>();
    if (_isKeysPressed({LogicalKeyboardKey.keyW, LogicalKeyboardKey.arrowUp})) {
      moveDirection = MoveDirection.up;
      currentTankCells = getTankCell(moveDirection);
      if (!enemyTanks.any((element) => element.isCollideWithTank(this))) {
        position += moveDirection.vector * moveSpeed * dt;
      }
    } else if (_isKeysPressed({
      LogicalKeyboardKey.keyD,
      LogicalKeyboardKey.arrowRight,
    })) {
      moveDirection = MoveDirection.right;
      currentTankCells = getTankCell(moveDirection);
      if (!enemyTanks.any((element) => element.isCollideWithTank(this))) {
        position += moveDirection.vector * moveSpeed * dt;
      }
    } else if (_isKeysPressed({
      LogicalKeyboardKey.keyS,
      LogicalKeyboardKey.arrowDown,
    })) {
      moveDirection = MoveDirection.down;
      currentTankCells = getTankCell(moveDirection);
      if (!enemyTanks.any((element) => element.isCollideWithTank(this))) {
        position += moveDirection.vector * moveSpeed * dt;
      }
    } else if (_isKeysPressed({
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.arrowLeft,
    })) {
      moveDirection = MoveDirection.left;
      currentTankCells = getTankCell(moveDirection);
      if (!enemyTanks.any((element) => element.isCollideWithTank(this))) {
        position += moveDirection.vector * moveSpeed * dt;
      }
    }
  }

  /// 处理键盘事件
  bool handleKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyJ ||
          event.logicalKey == LogicalKeyboardKey.keyK) {
        fire(ownerType: Bullet.typeOfHeroBullet);
        return true;
      }
      if (keysPressed.intersection({
        LogicalKeyboardKey.keyW,
        LogicalKeyboardKey.keyA,
        LogicalKeyboardKey.keyS,
        LogicalKeyboardKey.keyD,
        LogicalKeyboardKey.arrowUp,
        LogicalKeyboardKey.arrowLeft,
        LogicalKeyboardKey.arrowDown,
        LogicalKeyboardKey.arrowRight,
      }).isNotEmpty) {
        _playerPressedKeys.addAll(keysPressed); // 添加按下的键
        return true;
      }
    } else if (event is KeyUpEvent) {
      _playerPressedKeys.remove(event.logicalKey); // 移除松开的键
    }
    return false;
  }
}
