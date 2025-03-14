import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
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
  /// 游戏面板
  Board? board;

  /// 地图偏移值
  late Offset mapOffset;

  /// 侧边栏的宽度，约为5个gridSize
  late double sideBarWidth;

  /// 英雄坦克对象
  HeroTank? heroTank;

  /// 英雄坦克生命值文本组件
  TextComponent? heroLifeTextComponent;

  @override
  void onLoad() async {
    sideBarWidth = BaseTank.gridSize * 5;
    var leftViewportWidth = size.x - sideBarWidth;
    var mapXCount = leftViewportWidth ~/ BaseTank.gridSize;
    var mapYCount = size.y ~/ BaseTank.gridSize;
    mapOffset = Offset(
      leftViewportWidth / 2 - (mapXCount * BaseTank.gridSize) / 2,
      size.y / 2 - (mapYCount * BaseTank.gridSize) / 2,
    );
    add(
      board = Board(
        mapXCount: mapXCount,
        mapYCount: mapYCount,
        size: Vector2(
          mapXCount * BaseTank.gridSize,
          mapYCount * BaseTank.gridSize,
        ),
        position: mapOffset.toVector2(),
      ),
    );
    List.generate(
      4,
      (index) => add(
        EnemyTank()
          ..position =
              index % 2 == 0
                  ? Vector2(
                    mapOffset.dx +
                        (mapXCount - BaseTank.gridCount) * BaseTank.gridSize,
                    mapOffset.dy,
                  )
                  : mapOffset.toVector2(),
      ),
    );
    add(
      heroTank = HeroTank(
        life: 3,
        position: Vector2(
          mapOffset.dx +
              (mapXCount - BaseTank.gridCount) ~/ 2 * BaseTank.gridSize,
          board!.position.x +
              board!.size.y -
              BaseTank.gridSize * BaseTank.gridCount,
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
