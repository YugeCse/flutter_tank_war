import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart'
    show Colors, TextStyle, KeyEventResult, debugPrint;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart' show KeyEvent;
import 'package:flutter_tank_war/board.dart';
import 'package:flutter_tank_war/tank/base_tank.dart';
import 'package:flutter_tank_war/tank/enemy_tank.dart';
import 'package:flutter_tank_war/tank/hero_tank.dart';

/// 游戏类
class Game extends FlameGame with KeyboardEvents {
  /// 英雄坦克对象
  HeroTank? heroTank;

  TextComponent? heroLifeTextComponent;

  @override
  void onLoad() async {
    add(Board(size: size));
    List.generate(
      4,
      (index) => add(
        EnemyTank()
          ..position = index % 2 == 0 ? Vector2.all(0) : Vector2(size.x, 0),
      ),
    );
    add(
      heroTank = HeroTank(
        life: 3,
        position: Vector2(
          size.x / 2 - (BaseTank.gridSize * BaseTank.gridCount) / 2,
          size.y - BaseTank.gridSize * BaseTank.gridCount,
        ),
      ),
    );
    add(
      heroLifeTextComponent = TextComponent(
        text: "Life: ${heroTank!.life}",
        textRenderer: TextPaint(
          style: TextStyle(
            fontFamily: 'NotoSans SC',
            fontSize: 20,
            locale: Locale('zh', 'CN'),
          ),
        ),
      )..position = size / 2,
    );
  }

  /// 游戏结束
  void gameOver() {
    heroTank = null;
    debugPrint('game over');
    add(
      RectangleComponent(size: size, paint: Paint()..color = Colors.red)
        ..priority = 1
        ..add(TextComponent(text: "Game Over !")),
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
