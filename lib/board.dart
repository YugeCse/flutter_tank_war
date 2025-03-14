import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors hide Image;
import 'package:flutter_tank_war/data/obstacle_info.dart';
import 'package:flutter_tank_war/tank/base_tank.dart';
import 'package:flutter_tank_war/tank/enemy_tank.dart' show EnemyTank;
import 'package:flutter_tank_war/tank/hero_tank.dart' show HeroTank;
import 'package:flutter_tank_war/utils/canvas_utils.dart';

class Board extends PositionComponent {
  Board({
    super.size,
    super.position,
    required this.mapXCount,
    required this.mapYCount,
  });

  /// 地图X轴格子数量
  int mapXCount;

  /// 地图Y轴格子数量
  int mapYCount;

  /// 静态地图图层
  late Image staticMapImage;

  /// 侧边栏的宽度
  late double sideBoardWidth;

  /// 英雄坦克对象
  HeroTank? heroTank;

  /// 障碍物数据集合
  List<ObstacleInfo> obstacles = [];

  @override
  FutureOr<void> onLoad() async {
    staticMapImage = await generateWarMap();
    List.generate(
      4,
      (index) => add(
        EnemyTank()
          ..position =
              index % 2 == 0
                  ? Vector2(
                    (mapXCount - BaseTank.gridCount) * BaseTank.gridSize,
                    0,
                  )
                  : Vector2.zero(),
      ),
    );
    add(
      heroTank = HeroTank(
        life: 3,
        position: Vector2(
          (mapXCount - BaseTank.gridCount) ~/ 2 * BaseTank.gridSize,
          size.y - BaseTank.gridSize * BaseTank.gridCount,
        ),
      ),
    );
  }

  /// 生成静态地图
  Future<Image> generateWarMap() async {
    var staticMapPicRecorder = PictureRecorder();
    var staticMapCanvas = Canvas(staticMapPicRecorder);
    for (var y = 0; y < mapYCount; y++) {
      for (var x = 0; x < mapXCount; x++) {
        staticMapCanvas.drawCell(
          col: x,
          row: y,
          cellSize: BaseTank.gridSize,
          renderColor: Colors.grey[600]!,
        );
        if (Random().nextInt(10) % 3 == 0) {
          obstacles.add(ObstacleInfo(x, y, BaseTank.gridSize));
        }
      }
    }
    return staticMapPicRecorder.endRecording().toImage(
      (mapXCount * BaseTank.gridSize).toInt(),
      (mapYCount * BaseTank.gridSize).toInt(),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawImage(staticMapImage, Offset.zero, Paint());
    for (var i = 0; i < obstacles.length; i++) {
      obstacles[i].render(canvas);
    }
  }
}
