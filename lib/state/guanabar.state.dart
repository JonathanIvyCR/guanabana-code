import 'package:flutter/material.dart';

enum GuanaBarStage { startGame, playingGame, settings, about, stats, winner }

class GuanaBarState with ChangeNotifier {
  GuanaBarStage _stage = GuanaBarStage.startGame;
  GuanaBarStage get stage => _stage;
  void setGuanaBarStage(GuanaBarStage value) {
    _stage = value;
    notifyListeners();
  }
}
