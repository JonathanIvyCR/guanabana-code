import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:guanabana/models/leaf.model.dart';
import 'package:guanabana/state/puzzle.state.dart';
import 'package:guanabana/zelpers/gi.dart';
import 'package:guanabana/zelpers/rndIt.dart';

import '../models/cloud.model.dart';
import 'home.state.dart';

class ProgressState with ChangeNotifier {
  bool _sayingGuanabana = false;
  bool get sayingGuanabana => _sayingGuanabana;
  void setSayingGuanabana(bool value) async {
    _sayingGuanabana = value;
    notifyListeners();
  }

  Rect _signRect = Rect.zero;
  Rect get signRect => _signRect;
  double get signHeight => _signRect.bottomLeft.dy - _signRect.topLeft.dy;
  double get signWidth => _signRect.bottomRight.dx - _signRect.bottomLeft.dx;
  Future<bool> setSignRect(Rect value) async {
    _signRect = value;
    // notifyListeners();
    return Future.value(_signRect == value);
  }

  final List<CloudModel> _clouds = [];
  List<CloudModel> get clouds => _clouds;
  final List<LeafModel> _leavesBehind = [];
  List<LeafModel> get leavesBehind => _leavesBehind;
  final List<LeafModel> _leavesFront = [];
  List<LeafModel> get leavesFront => _leavesFront;

  Alignment _lightAlignment = const Alignment(0, -1);
  Alignment get lightAlignment => _lightAlignment;
  void setLightAlignment(Alignment value) {
    _lightAlignment = value;
    // notifyListeners();
  }

  int _timer = 0;
  int get timer => _timer;
  void setTimer(int value) {
    _timer = value;
    notifyListeners();
  }

  Path _textPath = Path();
  Path get textPath => _textPath;
  bool _textSet = false;
  bool get textSet => _textSet;
  Future<void> setTextPath(Path value) async {
    // used by ants for contains
    if (!_textSet) {
      _textSet = true;
      _textPath = value;
    }
  }

  Path _boardPath = Path();
  Path get boardPath => _boardPath;
  bool _boardSet = false;
  bool get boardSet => _boardSet;
  late PathMetric _boardPathMetric;
  PathMetric get boardPathMetric => _boardPathMetric;
  Rect _boardBounds = Rect.zero;
  Rect get boardBounds => _boardBounds;

  Future<void> setBoard(Path value) async {
    if (!_boardSet) {
      _boardSet = true;
      _boardPath = value;
      _boardPathMetric = _boardPath.computeMetrics().toList().first;

      _boardBounds = _boardPath.getBounds();

      await Future.delayed(const Duration(milliseconds: 150));
      notifyListeners();
    }
  }

  Path _trunkPath = Path();
  Path get trunkPath => _trunkPath;
  bool _trunkSet = false;
  bool get trunkSet => _trunkSet;
  late PathMetric _trunkPathMetric;
  PathMetric get trunkPathMetric => _trunkPathMetric;
  Rect _trunkBounds = Rect.zero;
  Rect get trunkBounds => _trunkBounds;
  Offset _trunkBranchPoint = Offset.zero;
  Offset get trunkBranchPoint => _trunkBranchPoint;
  Future<void> setTrunk(Path value) async {
    if (!_trunkSet) {
      _trunkPath = value;
      _trunkPathMetric = _trunkPath.computeMetrics().toList().first;
      _trunkBranchPoint = _trunkPathMetric
          .getTangentForOffset(_trunkPathMetric.length * .81)!
          .position;
      _trunkBounds = _trunkPath.getBounds();
      _trunkSet = true;
      await Future.delayed(const Duration(milliseconds: 150));
      notifyListeners();
    }
  }

  Path _branchPath = Path();
  Path get branchPath => _branchPath;
  bool _branchSet = false;
  bool get branchSet => _branchSet;
  late PathMetric _branchPathMetric;
  PathMetric get branchPathMetric => _branchPathMetric;
  Rect _branchBounds = Rect.zero;
  Rect get branchBounds => _branchBounds;
  Offset _branchPoint = Offset.zero;
  Offset get branchPoint => _branchPoint;
  Future<void> setBranch(Path value) async {
    if (!_branchSet) {
      _branchPath = value;
      _branchPathMetric = _branchPath.computeMetrics().toList().first;
      // _branchPoint = _branchPathMetric
      //     .getTangentForOffset(_branchPathMetric.length * .89)!
      //     .position;
      _branchBounds = _branchPath.getBounds();
      _branchPoint = Offset(gi<ProgressState>().trunkBranchPoint.dx * .97,
          gi<HomeState>().screenSize.height * .17);
      _branchBounds = _branchPath.getBounds();
      _branchSet = true;
      await Future.delayed(const Duration(milliseconds: 150));
      notifyListeners();
      // print('progressState: _setBranch()');
    }
  }

  Path _everythingPath = Path();
  Path get everythingPath => _everythingPath;
  void setEverythingPath(Path value) {
    _everythingPath = value;
  }

  Path _fruitPath = Path();
  Path get fruitPath => _fruitPath;
  void setFruitPath(Path value) {
    _fruitPath = value;
  }

  bool _goToFruit = false;
  bool get goToFruit => _goToFruit;
  void setGoToFruit(bool value) {
    _goToFruit = value;
  }

  int _progressStep = 4;
  int get progressStep => _progressStep;

  void setProgress(int newProgressStep) {
    if (gi<PuzzleState>().puzzle.tilesNum == 15) {
      if (newProgressStep == 0) {
        for (LeafModel leaf in _leavesFront) {
          leaf.shouldFall = true;
          leaf.randos = RndIt.getRandos(leaf.id);
        }
        for (LeafModel leaf in _leavesBehind) {
          leaf.shouldFall = true;
          leaf.randos = RndIt.getRandos(leaf.id);
        }
      } else if (_leavesFront.first.shouldFall) {
        for (LeafModel leaf in _leavesFront) {
          leaf.shouldFall = false;
        }
        for (LeafModel leaf in _leavesBehind) {
          leaf.shouldFall = false;
        }
      }
      _progressStep = newProgressStep;

      notifyListeners();
    }
  }
}
