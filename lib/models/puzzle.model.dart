import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class PuzzleModel {
  PuzzleModel({
    required this.tilesNum,
    required this.movesNum,
    required this.tiles,
    required this.correctTiles,
    required this.solution,
    required this.tilesSolution,
    required this.tileHistory,
    required this.tileWidgets,
    required this.mascotTile,
    required this.mascotSightings,
    required this.mascotCaptured,
    required this.timer,
    this.showHints = true,
    required this.screenshot,
    required this.completed,
    this.individualTileHint = -1,
    this.playing = false,
    this.showPuzzleScreenshot = false,
  });

  int tilesNum;
  int movesNum;
  int timer;
  List<dynamic> tiles;
  List<dynamic> correctTiles;
  List<dynamic> solution;
  List<dynamic> tilesSolution;
  List<int> tileHistory;
  List<Widget> tileWidgets;
  int mascotTile;
  int mascotSightings;
  bool mascotCaptured;
  double get tilesSqrt => sqrt(tilesNum + 1);
  bool showHints;
  Uint8List screenshot;
  bool completed;
  bool playing;
  bool showPuzzleScreenshot;
  int individualTileHint;

  void setTimer(int value) {
    timer = value;
  }

  void setPlaying(bool value) {
    playing = value;
  }
}
