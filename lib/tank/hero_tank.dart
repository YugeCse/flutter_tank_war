import 'package:flutter_tank_war/tank/tank.dart';

class HeroTank extends Tank {
  @override
  List<List<int>> tankCells = [
    [0, 1, 0, 1, 1, 1, 1, 2, 1], //上
    [1, 1, 0, 2, 1, 1, 1, 1, 0], //右
    [1, 2, 1, 1, 1, 1, 0, 1, 0], //下
    [0, 1, 1, 1, 1, 2, 0, 1, 1], //左
  ];
}
