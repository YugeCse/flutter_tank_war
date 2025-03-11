import 'package:flame/components.dart' show Vector2;

enum MoveDirection {
  up(0),
  right(1),
  down(2),
  left(3);

  final int value;

  const MoveDirection(this.value);

  static const List<MoveDirection> all = [up, down, left, right];
}

extension MoveDirectionExtension on MoveDirection {
  Vector2 get vector {
    switch (this) {
      case MoveDirection.up:
        return Vector2(0, -1);
      case MoveDirection.down:
        return Vector2(0, 1);
      case MoveDirection.left:
        return Vector2(-1, 0);
      case MoveDirection.right:
        return Vector2(1, 0);
    }
  }
}
