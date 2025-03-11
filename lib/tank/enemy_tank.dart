import 'dart:async';
import 'dart:math' show Random;

import 'package:flame/components.dart' show TimerComponent;
import 'package:flutter_tank_war/data/move_direction.dart';
import 'package:flutter_tank_war/tank/tank.dart';

class EnemyTank extends Tank {
  @override
  List<List<int>> tankCells = [
    [0, 1, 0, 1, 1, 1, 1, 0, 1], //上
    [1, 1, 0, 0, 1, 1, 1, 1, 0], //右
    [1, 0, 1, 1, 1, 1, 0, 1, 0], //下
    [0, 1, 1, 1, 1, 0, 0, 1, 1], //左
  ];

  /// 坦克的移动控制定时器
  TimerComponent? _timerComponent;

  @override
  FutureOr<void> onLoad() async {
    add(
      _timerComponent = TimerComponent(
        period: 1.0,
        repeat: true,
        onTick: () {
          randomAutoMove(); // 随机移动
          if ((Random().nextInt(1000) + 1) % 5 == 0) {
            fire(); // 射击
          }
        },
      ),
    );
  }

  /// 随机自动移动
  void randomAutoMove() {
    moveDirection = generateRandomDirection(); // 随机方向
    currentTankCells = getTankCell(moveDirection);
    position += moveDirection.vector * Tank.gridSize; // 移动坦克
  }

  @override
  void onRemove() {
    _timerComponent?.removeFromParent();
    super.onRemove();
  }
}
