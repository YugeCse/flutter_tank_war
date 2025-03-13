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
  final Random _random = Random();

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
        repeat: true,
        onTick: randomAutoMoveAndFire,
        period: _random.nextDouble() + 0.8, // 随机生成一个0.8~1.8秒的定时器
      ),
    ); // 每秒执行一次
  }

  /// 根据当前方向，返回下一个位置
  Vector2 generateRandomDirection() {
    return MoveDirection.all[_random.nextInt(
      MoveDirection.all.length,
    )]; //如果发生了碰撞，它的移动方向不变
  }

  /// 随机自动移动并随机开火
  void randomAutoMoveAndFire() {
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
    if ((_random.nextInt(1000) + 1) % (_random.nextInt(5) + 1) == 0) {
      fire(ownerType: Bullet.typeOfEnemyBullet); // 射击
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    _timerComponent?.removeFromParent(); //当组件被移除时一并移除定时器
  }
}
