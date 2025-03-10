import 'package:flame/game.dart';
import 'package:flutter_tank_war/tank/enemy_tank.dart';
import 'package:flutter_tank_war/tank/hero_tank.dart';
import 'package:flutter_tank_war/tank/tank.dart';

class Game extends FlameGame {
  Tank? heroTank;

  @override
  void onLoad() async {
    super.onLoad();
    add(heroTank = EnemyTank()..position = Vector2.all(200));
    add(heroTank = EnemyTank()..position = Vector2.all(400));
    add(heroTank = EnemyTank()..position = Vector2.all(500));
    add(heroTank = EnemyTank()..position = Vector2.all(300));
    add(heroTank = EnemyTank()..position = Vector2.all(600));
    add(heroTank = EnemyTank()..position = Vector2.all(700));
    add(heroTank = EnemyTank()..position = Vector2.all(550));
    add(heroTank = EnemyTank()..position = Vector2.all(150));
    add(heroTank = EnemyTank()..position = Vector2.all(260));
    add(heroTank = HeroTank()..position = Vector2.all(100));
  }
}
