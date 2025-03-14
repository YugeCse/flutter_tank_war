import 'package:flutter/material.dart';
import 'package:flutter_tank_war/utils/canvas_utils.dart';

/// 障碍物信息类
class ObstacleInfo {
  int x;
  int y;
  double size;
  ObstacleInfo(this.x, this.y, this.size);

  void render(Canvas canvas, {Offset offset = Offset.zero}) {
    canvas.drawCell(
      col: x,
      row: y,
      cellSize: size,
      offset: offset,
      renderColor: Colors.black,
    );
  }
}
