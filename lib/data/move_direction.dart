import 'package:flame/components.dart' show Vector2;

/// 移动方向类的声明
class MoveDirection {
  /// 私有化构造函数，防止外部创建对象
  MoveDirection._();

  /// 向上
  static final up = Vector2(0, -1);

  /// 向下
  static final down = Vector2(0, 1);

  /// 向左
  static final left = Vector2(-1, 0);

  /// 向右
  static final right = Vector2(1, 0);

  static final all = [up, down, left, right];
}

extension MoveDirectionExtension on Vector2 {
  /// 根据方向获取形状索引
  int toCellShapeIndex() {
    if (x == MoveDirection.up.x && y == MoveDirection.up.y) {
      return 0;
    } else if (x == MoveDirection.right.x && y == MoveDirection.right.y) {
      return 1;
    } else if (x == MoveDirection.down.x && y == MoveDirection.down.y) {
      return 2;
    } else if (x == MoveDirection.left.x && y == MoveDirection.left.y) {
      return 3;
    }
    return 0;
  }
}
