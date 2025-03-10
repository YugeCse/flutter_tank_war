import 'package:flame/game.dart' hide Game;
import 'package:flutter/material.dart';
import 'package:flutter_tank_war/game.dart' show Game;

void main() {
  runApp(GameWidget.controlled(gameFactory: () => Game()));
}
