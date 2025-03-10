import 'dart:math';
import 'dart:ui';

import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' show Colors;

/// 画布工具类
extension CanvasUtils on Canvas {
  /// 绘制坦克的每个格子
  /// - [col] 列
  /// - [row] 行
  /// - [cellSize] 格子大小
  /// - [radius] 圆角半径, 默认：3.0
  /// - [margin] 边距, 默认：2.0
  /// - [strokeWidth] 边框宽度, 默认：2.0
  /// - [offset] 偏移量, 默认：Offset.zero
  /// - [renderColor] 渲染颜色, 默认：Colors.white
  void drawCell({
    required int col,
    required int row,
    required double cellSize,
    double radius = 3.0,
    double margin = 1.5,
    double strokeWidth = 1.2,
    Offset offset = Offset.zero,
    Color renderColor = Colors.white,
  }) {
    final Paint paint = Paint()..color = renderColor; // 创建一个 Paint 对象并设置颜色
    final double x = col * cellSize + offset.dx; // 计算格子的 x 坐标
    final double y = row * cellSize + offset.dy; // 计算格子的 y 坐标
    Rect rect = Rect.fromLTWH(x, y, cellSize, cellSize); // 创建一个矩形
    rect = rect.deflate(margin); // 缩小矩形以适应边框
    drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    ); // 绘制填充的圆角矩形
    drawHeartIcon(center: rect.center.toVector2(), renderColor: renderColor);
  }

  /// 绘制桃心
  /// - [center] 绘制位置
  /// - [renderColor] 绘制颜色
  /// - [scale] 缩放比例, 默认：0.245
  void drawHeartIcon({
    required Vector2 center,
    required Color renderColor,
    final double scale = 0.245, // 缩放比例
  }) {
    final Paint paint =
        Paint()
          ..color = renderColor
          ..style = PaintingStyle.fill;
    final double offsetX = center.x; // 水平居中
    final double offsetY = center.y; // 垂直居中
    final Path path = Path();
    for (double t = 0; t <= 2 * 3.141592653589793; t += 0.01) {
      final double x = 16.0 * pow(sin(t), 3);
      final double y =
          13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t);
      final double scaledX = x * scale + offsetX;
      final double scaledY = -y * scale + offsetY; // 反转 y 轴以适配屏幕坐标系
      if (t == 0) {
        path.moveTo(scaledX, scaledY);
      } else {
        path.lineTo(scaledX, scaledY);
      }
    }
    path.close();
    drawPath(path, paint); // 绘制路径
  }
}
