import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show KeyDownEvent, KeyUpEvent, LogicalKeyboardKey;
import 'package:flutter_tank_war/data/move_direction.dart';
import 'package:flutter_tank_war/tank/tank.dart';

class HeroTank extends Tank {
  @override
  List<List<int>> tankCells = [
    [0, 1, 0, 1, 1, 1, 1, 2, 1], //上
    [1, 1, 0, 2, 1, 1, 1, 1, 0], //右
    [1, 2, 1, 1, 1, 1, 0, 1, 0], //下
    [0, 1, 1, 1, 1, 2, 0, 1, 1], //左
  ];

  final Set<LogicalKeyboardKey> _pressedKeys = {};

  bool _isKeysPressed(Set<LogicalKeyboardKey> keys) {
    return _pressedKeys.intersection(keys).length > 1;
  }

  @override
  FutureOr<void> onLoad() async {
    debugPrint('创建了英雄坦克 $position, $size');
    currentTankCells = getTankCell(MoveDirection.up);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isKeysPressed({LogicalKeyboardKey.keyW, LogicalKeyboardKey.arrowUp})) {
      moveDirection = MoveDirection.up;
      currentTankCells = getTankCell(moveDirection);
      position += moveDirection.vector * moveSpeed * dt;
    } else if (_isKeysPressed({
      LogicalKeyboardKey.keyD,
      LogicalKeyboardKey.arrowRight,
    })) {
      moveDirection = MoveDirection.right;
      currentTankCells = getTankCell(moveDirection);
      position += moveDirection.vector * moveSpeed * dt;
    } else if (_isKeysPressed({
      LogicalKeyboardKey.keyS,
      LogicalKeyboardKey.arrowDown,
    })) {
      moveDirection = MoveDirection.down;
      currentTankCells = getTankCell(moveDirection);
      position += moveDirection.vector * moveSpeed * dt;
    } else if (_isKeysPressed({
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.arrowLeft,
    })) {
      moveDirection = MoveDirection.left;
      currentTankCells = getTankCell(moveDirection);
      position += moveDirection.vector * moveSpeed * dt;
    }
  }

  /// 处理键盘事件
  bool handleKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyJ ||
          event.logicalKey == LogicalKeyboardKey.keyK) {
        fire();
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
          }).length ==
          1) {
        _pressedKeys.addAll(keysPressed); // 添加按下的键
        return true;
      }
    } else if (event is KeyUpEvent) {
      _pressedKeys.remove(event.logicalKey); // 移除松开的键
    }
    return false;
  }
}
