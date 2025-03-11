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

  bool _canMove = false;

  @override
  FutureOr<void> onLoad() async {
    debugPrint('创建了英雄坦克 $position, $size');
    currentTankCells = getTankCell(MoveDirection.up);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_canMove) {
      position += moveDirection.vector * dt * 200;
    }
  }

  /// 处理键盘事件
  bool handleKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyUpEvent) {
      _canMove = false;
      return true;
    } else if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyJ ||
          event.logicalKey == LogicalKeyboardKey.keyK) {
        fire();
        return true;
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
          keysPressed.contains(LogicalKeyboardKey.keyW)) {
        _canMove = true;
        moveDirection = MoveDirection.up;
        currentTankCells = getTankCell(moveDirection);
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) {
        _canMove = true;
        moveDirection = MoveDirection.right;
        currentTankCells = getTankCell(moveDirection);
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
          keysPressed.contains(LogicalKeyboardKey.keyS)) {
        _canMove = true;
        moveDirection = MoveDirection.down;
        currentTankCells = getTankCell(moveDirection);
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA)) {
        _canMove = true;
        moveDirection = MoveDirection.left;
        currentTankCells = getTankCell(moveDirection);
        return true;
      }
    }
    return false;
  }
}
