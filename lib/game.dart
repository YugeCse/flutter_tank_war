import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' show KeyEventResult;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart' show KeyEvent;
import 'package:flutter_tank_war/tank/base_tank.dart';
import 'package:flutter_tank_war/tank/enemy_tank.dart';
import 'package:flutter_tank_war/tank/hero_tank.dart';

/// 游戏类
class Game extends FlameGame with KeyboardEvents {
  /// 英雄坦克对象
  HeroTank? heroTank;

  @override
  void onLoad() async {
    List.generate(
      4,
      (index) => add(
        EnemyTank()
          ..position = index % 2 == 0 ? Vector2.all(0) : Vector2(size.x, 0),
      ),
    );
    add(
      heroTank = HeroTank(
        position: Vector2(
          size.x / 2 - (BaseTank.gridSize * BaseTank.gridCount) / 2,
          size.y - BaseTank.gridSize * BaseTank.gridCount,
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      size.toRect(),
      Paint()..color = const Color.fromARGB(255, 131, 131, 131),
    );
    super.render(canvas);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (heroTank?.handleKeyEvent(event, keysPressed) ==
        KeyEventResult.handled) {
      return KeyEventResult.handled;
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
