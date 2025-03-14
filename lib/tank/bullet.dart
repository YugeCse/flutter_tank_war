import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_tank_war/game.dart' show Game;
import 'package:flutter_tank_war/tank/enemy_tank.dart';
import 'package:flutter_tank_war/tank/base_tank.dart' show BaseTank;
import 'package:flutter_tank_war/utils/canvas_utils.dart';

/// 子弹组件
class Bullet extends PositionComponent with HasGameRef<Game> {
  /// Hero的子弹
  static final int typeOfHeroBullet = 0;

  /// 敌人的子弹
  static final int typeOfEnemyBullet = 1;

  /// 构造方法
  Bullet({
    super.size,
    super.position,
    required this.ownerType,
    required this.direction,
    this.speed = 100,
  });

  /// 子弹的拥有者类型
  final int ownerType;

  /// 子弹速度, 默认：100
  double speed;

  /// 子弹移动方向
  final Vector2 direction;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCell(
      col: 0,
      row: 0,
      cellSize: BaseTank.gridSize,
      renderColor: Colors.black,
    );
  }

  /// 与子弹发生碰撞
  bool isCollideWith(Bullet bullet) {
    return Rect.fromLTWH(
      bullet.position.x,
      bullet.position.y,
      bullet.size.x,
      bullet.size.y,
    ).overlaps(Rect.fromLTWH(position.x, position.y, size.x, size.y));
  }

  /// 与坦克发生碰撞
  bool isCollideWithTank(BaseTank tank) {
    for (var i = 0; i < tank.currentTankCells.length; i++) {
      var x = i % BaseTank.gridCount;
      var y = i ~/ BaseTank.gridCount;
      var value = tank.currentTankCells[i];
      if (value != 0) {
        var tankCellRect = (tank.position +
                Vector2(x * BaseTank.gridSize, y * BaseTank.gridSize))
            .toPositionedRect(Vector2.all(BaseTank.gridSize));
        if (tankCellRect.overlaps(position.toPositionedRect(size))) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (position.x <= -BaseTank.gridSize ||
        position.x > gameRef.size.x ||
        position.y <= -BaseTank.gridSize ||
        position.y > gameRef.size.y) {
      removeFromParent(); //超出屏幕边界，从父组件中移除
    } else {
      var allBullets = gameRef.board?.children.whereType<Bullet>() ?? [];
      for (var bullet in allBullets) {
        if (bullet != this &&
            bullet.ownerType != ownerType &&
            bullet.isCollideWith(this)) {
          removeFromParent(); //与子弹碰撞，从父组件中移除
          bullet.removeFromParent(); //与子弹碰撞，从父组件中移除
          return;
        }
      }
      if (ownerType == typeOfHeroBullet) {
        var allEnemyTanks =
            gameRef.board?.children.whereType<EnemyTank>() ?? [];
        for (var enemyTank in allEnemyTanks) {
          if (isCollideWithTank(enemyTank)) {
            removeFromParent(); //与敌人坦克碰撞，从父组件中移除
            enemyTank.removeFromParent(); //与Hero子弹碰撞，从父组件中移除
            return;
          }
        }
      } else if (ownerType == typeOfEnemyBullet) {
        var heroTank = gameRef.board?.heroTank;
        if (heroTank != null && isCollideWithTank(heroTank)) {
          if (heroTank.life > 1) {
            removeFromParent(); //与Hero坦克碰撞，从父组件中移除
            heroTank.life--; //与Hero坦克子弹碰撞，减少生命值
            gameRef.heroLifeTextComponent?.text = "Life: ${heroTank.life}";
            return;
          }
          heroTank.life--; //与Hero坦克子弹碰撞，减少生命值
          removeFromParent(); //与Hero坦克碰撞，从父组件中移除
          heroTank.removeFromParent(); //与Hero坦克碰撞，从父组件中移除
          gameRef.gameOver(); //游戏结束
          return;
        }
      }
      position += direction * dt * speed; //更新子弹位置
    }
  }
}
