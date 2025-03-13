import 'dart:async';
import 'dart:math' show Random;

import 'package:flame/components.dart' show TimerComponent;
import 'package:flame/game.dart';
import 'package:flutter_tank_war/data/move_direction.dart';
import 'package:flutter_tank_war/tank/bullet.dart';
import 'package:flutter_tank_war/tank/base_tank.dart';
import 'package:flutter_tank_war/tank/hero_tank.dart';

/// 敌方坦克
class EnemyTank extends BaseTank {
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
          var random = Random(DateTime.now().millisecondsSinceEpoch);
          randomAutoMove(); // 随机移动
          if ((random.nextInt(1000) + 1) % (random.nextInt(5) + 1) == 0) {
            fire(ownerType: Bullet.typeOfEnemyBullet); // 射击
          }
        },
      ),
    );
  }

  /// 根据当前方向，返回下一个位置
  Vector2 generateRandomDirection() {
    return MoveDirection.all[Random(
      DateTime.now().millisecondsSinceEpoch,
    ).nextInt(MoveDirection.all.length)]; //如果发生了碰撞，它的移动方向不变
  }

  /// 随机自动移动
  void randomAutoMove() {
    var targetDirection = generateRandomDirection(); // 随机方向
    var targetTankCells = tankCells[targetDirection.toCellShapeIndex()];
    var heroTanks = gameRef.children.whereType<HeroTank>();
    var moveTargetDistance = targetDirection * BaseTank.gridSize;
    if (!heroTanks.any(
      (el) => el.isCollideWithCells(
        cells: targetTankCells,
        offset: position + moveTargetDistance,
      ),
    )) {
      direction = targetDirection; // 如果没有发生碰撞，它的移动方向改变
      currentTankCells = tankCells[direction.toCellShapeIndex()];
      position += moveTargetDistance; // 移动坦克
    }
  }

  @override
  void onRemove() {
    _timerComponent?.removeFromParent();
    super.onRemove();
  }
}
