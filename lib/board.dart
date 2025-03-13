import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tank_war/tank/base_tank.dart';
import 'package:flutter_tank_war/tank/bullet.dart' show Bullet;
import 'package:flutter_tank_war/utils/canvas_utils.dart';

class Board extends PositionComponent {
  Board({super.size, super.position});

  late int mapXCount;

  late int mapYCount;

  late double sideBoardWidth;

  late List<List<int>> mapGrids;

  bool isCollideWithWall(Bullet bullet) {}

  @override
  FutureOr<void> onLoad() async {
    sideBoardWidth = BaseTank.gridSize * 6;
    mapYCount = size.y ~/ BaseTank.gridSize;
    mapXCount = (size.x - sideBoardWidth) ~/ BaseTank.gridSize;
    mapGrids = List.generate(mapYCount, (index) => List.filled(mapXCount, 0));
    for (var y = 0; y < mapYCount; y++) {
      for (var x = 0; x < mapXCount; x++) {
        if ((x < 4 && y < 4) || (x > mapXCount - 5 && y > mapYCount - 5)) {
          continue;
        }
        var value = Random().nextInt(10) % 3 == 0;
        if (value) {
          mapGrids[y][x] = -1;
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for (var y = 0; y < mapYCount; y++) {
      for (var x = 0; x < mapXCount; x++) {
        var value = mapGrids[y][x];
        canvas.drawCell(
          col: x,
          row: y,
          cellSize: BaseTank.gridSize,
          offset: Offset(0, size.y / 2 - BaseTank.gridSize * mapYCount / 2),
          renderColor:
              value == -1
                  ? Colors.red
                  : const Color.fromARGB(255, 127, 125, 125),
        );
      }
    }
  }
}
