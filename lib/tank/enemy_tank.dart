import 'dart:async';
import 'dart:math' show Random;

import 'package:flame/components.dart' show TextComponent, TimerComponent;
import 'package:flame/game.dart';
import 'package:flutter/material.dart' show TextStyle;
import 'package:flutter_tank_war/data/enemy_state.dart';
import 'package:flutter_tank_war/data/move_direction.dart';
import 'package:flutter_tank_war/tank/bullet.dart';
import 'package:flutter_tank_war/tank/base_tank.dart';

/// 敌方坦克
class EnemyTank extends BaseTank {
  /// 随机事件的随机数生成对象
  final Random _random = Random();

  @override
  List<List<int>> tankCells = [
    [0, 1, 0, 1, 1, 1, 1, 0, 1], //上
    [1, 1, 0, 0, 1, 1, 1, 1, 0], //右
    [1, 0, 1, 1, 1, 1, 0, 1, 0], //下
    [0, 1, 1, 1, 1, 0, 0, 1, 1], //左
  ];

  /// 敌方坦克的状态 - 默认巡逻状态
  EnemyState state = EnemyState.patrol;

  /// 坦克的移动控制定时器
  TimerComponent? _timerComponent;

  TextComponent? _tvStateComponent;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    add(
      _timerComponent = TimerComponent(
        repeat: true,
        onTick: randomAutoMoveAndFire,
        period: _random.nextDouble() + 0.8, // 随机生成一个0.8~1.8秒的定时器
      ),
    ); // 不同的坦克有不同的定时器随机重复时间
    add(
      _tvStateComponent = TextComponent(
        text: state.toString(),
        position: position + Vector2(size.x, -12),
        textRenderer: TextPaint(style: TextStyle(fontSize: 11)),
      ),
    );
  }

  /// 根据当前方向，返回下一个位置
  Vector2 generateRandomDirection() {
    var heroTank = gameRef.board?.heroTank;
    if (heroTank != null) {
      var value =
          state == EnemyState.patrol
              ? 0.3
              : (state == EnemyState.chase ? 0.9 : 0.5); // 根据不同的状态，设置不同的概率
      var canSmartMove = _random.nextDouble() <= value;
      if (canSmartMove) {
        var dx = heroTank.position.x - position.x;
        var dy = heroTank.position.y - position.y;
        if (dx.abs() > dy.abs()) {
          return dx > 0 ? MoveDirection.right : MoveDirection.left;
        } else {
          return dy > 0 ? MoveDirection.down : MoveDirection.up;
        }
      }
    }
    return MoveDirection.all[_random.nextInt(
      MoveDirection.all.length,
    )]; //如果发生了碰撞，它的移动方向不变
  }

  /// 随机自动移动并随机开火
  void randomAutoMoveAndFire() {
    var targetDirection = generateRandomDirection(); // 随机方向
    var targetTankCells = tankCells[targetDirection.toCellShapeIndex()];
    var heroTank = gameRef.board?.heroTank;
    var moveTargetDistance = targetDirection * BaseTank.gridSize;
    if (heroTank?.isCollideWithTankCells(
          tankCells: targetTankCells,
          offset: position + moveTargetDistance,
        ) !=
        true) {
      direction = targetDirection; // 如果没有发生碰撞，它的移动方向改变
      currentTankCells = tankCells[direction.toCellShapeIndex()];
      position += moveTargetDistance; // 移动坦克
      adjustTankPositionIfOutRange(); // 调整坦克位置
    }
    if (_random.nextDouble() <=
        (state == EnemyState.attack
            ? 0.5
            : (state == EnemyState.chase ? 0.4 : 0.3))) {
      fire(ownerType: Bullet.typeOfEnemyBullet); // 射击
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateEnemyState(); // 更新敌人状态
    _tvStateComponent?.text = state.toString();
  }

  /// 更新敌人状态
  void updateEnemyState() {
    var heroTank = gameRef.board?.heroTank;
    if (heroTank != null) {
      double distance = heroTank.position.distanceTo(position);
      if (distance > 500) {
        state = EnemyState.patrol;
      } else if (distance > 300) {
        state = EnemyState.chase;
      } else {
        state = EnemyState.attack;
      }
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    _timerComponent?.removeFromParent(); //当组件被移除时一并移除定时器
  }
}
