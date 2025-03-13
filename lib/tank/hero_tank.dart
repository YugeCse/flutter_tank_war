import 'dart:async';

import 'package:flame/game.dart' show Vector2;
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
  HeroTank({super.position, super.speed});

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

  /// 判断新的移动方向是否会与其他敌人坦克碰撞
  bool _isCollideWithEnemyTanks({
    required double dt,
    required Vector2 targetDirection,
  }) {
    var enemyTanks = gameRef.children.whereType<EnemyTank>();
    var targetCells = tankCells[targetDirection.toCellShapeIndex()];
    return !enemyTanks.any(
      (el) => el.isCollideWithCells(
        position + targetDirection * speed * dt,
        targetCells,
      ),
    );
  }

  @override
  FutureOr<void> onLoad() async {
    direction = MoveDirection.up;
    currentTankCells = tankCells[direction.toCellShapeIndex()];
  }

  @override
  void update(double dt) {
    super.update(dt);
    var enemyTanks = gameRef.children.whereType<EnemyTank>();
    if (_isKeysPressed({LogicalKeyboardKey.keyW, LogicalKeyboardKey.arrowUp}) &&
        !_isCollideWithEnemyTanks(dt: dt, targetDirection: MoveDirection.up)) {
      direction = MoveDirection.up;
      currentTankCells = tankCells[direction.toCellShapeIndex()];
      position += direction * speed * dt;
    } else if (_isKeysPressed({
          LogicalKeyboardKey.keyD,
          LogicalKeyboardKey.arrowRight,
        }) &&
        !_isCollideWithEnemyTanks(
          dt: dt,
          targetDirection: MoveDirection.right,
        )) {
      direction = MoveDirection.right;
      currentTankCells = tankCells[direction.toCellShapeIndex()];
      position += direction * speed * dt;
    } else if (_isKeysPressed({
          LogicalKeyboardKey.keyS,
          LogicalKeyboardKey.arrowDown,
        }) &&
        !_isCollideWithEnemyTanks(
          dt: dt,
          targetDirection: MoveDirection.down,
        )) {
      direction = MoveDirection.down;
      currentTankCells = tankCells[direction.toCellShapeIndex()];
      position += direction * speed * dt;
    } else if (_isKeysPressed({
          LogicalKeyboardKey.keyA,
          LogicalKeyboardKey.arrowLeft,
        }) &&
        !_isCollideWithEnemyTanks(
          dt: dt,
          targetDirection: MoveDirection.left,
        )) {
      direction = MoveDirection.left;
      currentTankCells = tankCells[direction.toCellShapeIndex()];
      position += direction * speed * dt;
    }
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
        LogicalKeyboardKey.keyA,
        LogicalKeyboardKey.keyS,
        LogicalKeyboardKey.keyD,
        LogicalKeyboardKey.arrowUp,
        LogicalKeyboardKey.arrowLeft,
        LogicalKeyboardKey.arrowDown,
        LogicalKeyboardKey.arrowRight,
      }).isNotEmpty) {
        _playerPressedKeys.addAll(keysPressed); // 添加按下的键
        return KeyEventResult.handled;
      }
    } else if (event is KeyUpEvent) {
      _playerPressedKeys.remove(event.logicalKey); // 移除松开的键
    }
    return KeyEventResult.ignored;
  }
}
