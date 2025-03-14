import 'package:flame/image_composition.dart' show Image;
import 'package:flutter/material.dart' hide Image;

/// 障碍物信息类
class ObstacleInfo {
  int x;
  int y;
  double size;
  ObstacleInfo(this.x, this.y, this.size);

  void render(
    Canvas canvas, {
    required Image cellImage,
    Offset offset = Offset.zero,
  }) {
    canvas.drawImage(
      cellImage,
      Offset(x * size + offset.dx, y * size + offset.dy),
      Paint(),
    );
  }
}
