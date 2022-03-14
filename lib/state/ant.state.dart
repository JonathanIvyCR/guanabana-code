import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:guanabana/state/progress.state.dart';
import 'package:guanabana/zelpers/gi.dart';
import 'package:guanabana/zelpers/rndIt.dart';

import 'home.state.dart';

enum AntZone { trunk, branch, fruit, board }
enum AntGoal {
  search,
  up,
  down,
  left,
  right,
  collect,
  fall,
  fight,
  flee,
  dance
}

class AntModel {
  AntModel({
    required this.id,
    required this.angleCurrent,
    required this.angleNew,
    required this.locCur,
    required this.locNew,
    required this.distance,
    required this.totalPossibleDistance,
    required this.zone,
    required this.goal,
    required this.scale,
    required this.size,
    this.fall = false,
    required this.walkCompleted,
    this.problemCounter = 0,
  });
  int id;
  double angleCurrent;
  double angleNew;
  Offset locCur;
  Offset locNew;
  double distance;
  double totalPossibleDistance;
  AntZone zone;
  AntGoal goal;
  double scale;
  Size size;
  bool fall;
  bool walkCompleted;
  int problemCounter;
}

class AntState with ChangeNotifier {
  void setNewLoc(int antId) {
    final AntModel ant = _ants[antId];
    final ProgressState ps = gi<ProgressState>();

    ant.locCur = ant.locNew;

    bool _foundNext = false;
    for (var i = 1; i < 100; i++) {
      if (!_foundNext) {
        Offset possibleNewLoc = Offset.zero;
        double _distancePythag = 0;
        double _totalPossibleDistance = 20;
        double xChanceLeft = .5;
        double yChanceUp = .3;
        if (ant.id == 1) {
          // print(ant.goal);
        }
        switch (ant.goal) {
          case AntGoal.up:
            yChanceUp = .1;
            break;
          case AntGoal.down:
            yChanceUp = .9;
            break;
          case AntGoal.left:
            xChanceLeft = .1;
            break;
          case AntGoal.right:
            xChanceLeft = .9;
            break;
          default:
        }

        int perc = 100 ~/ i;

        double xRan = RndIt.getNegPosDouble(10, perc, xChanceLeft);

        double x = ant.locCur.dx + xRan;
        double yRan = RndIt.getNegPosDouble(10, perc, yChanceUp);
        double y = ant.locCur.dy + yRan;
        possibleNewLoc = Offset(x, y);
        _distancePythag = sqrt(xRan) + sqrt(yRan);

        bool checkPath() {
          switch (ant.zone) {
            case AntZone.trunk:
              if (ant.locCur.dy <= RndIt.rndIt(100, 0)) {
                ant.goal = AntGoal.down;
              } else if (ant.locCur.dy >
                  gi<HomeState>().screenSize.height - RndIt.rndIt(100, 0)) {
                ant.goal = AntGoal.up;
              } else if (ps.branchPath.contains(possibleNewLoc)) {
                ant.zone = AntZone.branch;
                return true;
              } else if (ps.progressStep >= 4 &&
                  ps.fruitPath.contains(possibleNewLoc)) {
                ant.zone = AntZone.fruit;
                return true;
              }
              return ps.trunkPath.contains(possibleNewLoc);
            case AntZone.branch:
              if (ant.locCur.dx <= gi<ProgressState>().trunkBounds.right) {
                ant.goal = AntGoal.right;
                // return true;
              } else if (ant.locCur.dx >
                  gi<HomeState>().screenSize.width - RndIt.rndIt(100, 0)) {
                ant.goal = AntGoal.left;
                // return true;
              }
              if (ps.progressStep >= 4 &&
                  ps.fruitPath.contains(possibleNewLoc)) {
                ant.zone = AntZone.fruit;
                return true;
              } else if (ps.trunkPath.contains(possibleNewLoc)) {
                ant.zone = AntZone.trunk;
                return true;
              }
              // print(ps.branchPath.contains(possibleNewLoc));

              return ps.branchPath.contains(possibleNewLoc);
            case AntZone.fruit:
              if (ps.branchPath.contains(possibleNewLoc) &&
                  Random().nextDouble() > .8) {
                ant.zone = AntZone.branch;
                return true;
              } else if (ps.trunkPath.contains(possibleNewLoc) &&
                  Random().nextDouble() > .8) {
                ant.zone = AntZone.trunk;
                return true;
              } else {
                if (ant.goal != AntGoal.search) {
                  ant.goal = AntGoal.search;
                }
              }
              return ps.fruitPath.contains(possibleNewLoc);

            default:
              return false;
          }
        }

        if (checkPath()) {
          double _newAngleTemp = 0;

          try {
            Path nextPath = Path();

            nextPath.moveTo(ant.locCur.dx, ant.locCur.dy);
            nextPath.lineTo(possibleNewLoc.dx, possibleNewLoc.dy);

            PathMetric pathMetric = nextPath.computeMetrics().toList().first;

            Tangent tangent =
                pathMetric.getTangentForOffset(pathMetric.length * .5)!;

            _newAngleTemp = -atan2(tangent.vector.dx, tangent.vector.dy);

            double diff = (_newAngleTemp - ant.angleCurrent).abs();
            if (diff <= 2.5) {
              _foundNext = true;
              ant.locNew = possibleNewLoc;
              ant.angleNew = _newAngleTemp;
              ant.distance = _distancePythag;
              ant.totalPossibleDistance = _totalPossibleDistance;
            } else if (diff <= 3) {
              _foundNext = true;
              ant.locNew = possibleNewLoc;
              ant.angleNew = _newAngleTemp;
              ant.distance = _distancePythag;
              ant.totalPossibleDistance = _totalPossibleDistance;
            } else if (diff <= 3.5) {
              _foundNext = true;
              ant.locNew = possibleNewLoc;
              ant.angleNew = _newAngleTemp;
              ant.distance = _distancePythag;
              ant.totalPossibleDistance = _totalPossibleDistance;
            } else {
              if (i > 95) {
                _foundNext = true;
                ant.locNew = possibleNewLoc;
                ant.angleNew = _newAngleTemp;
                ant.distance = _distancePythag;
                ant.totalPossibleDistance = _totalPossibleDistance;
              }
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
    }

    notifyListeners();
  }

  void setWalkCompleted(int antId) {
    final AntModel ant = _ants[antId];
    ant.walkCompleted = true;
    setNewLoc(antId);
    notifyListeners();
  }

  void setWalkCompletedFalse(int antId) {
    final AntModel ant = _ants[antId];
    ant.walkCompleted = false;
  }

  void clearAnt(int value) async {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (_ants.length == 1) {
        _ants.clear();
      } else {
        _ants.removeWhere((element) => element.id == value);
      }
      addAnt();
      notifyListeners();
    });
  }

  final List<AntModel> _ants = [];
  List<AntModel> get ants => _ants;
  void addAnt() {
    _ants.add(
      AntModel(
        id: _ants.length,
        angleCurrent: 0,
        angleNew: 0,
        locCur:
            Offset(10, gi<HomeState>().screenSize.height + RndIt.rndIt(100, 0)),
        locNew: Offset(10, gi<HomeState>().screenSize.height),
        distance: 0,
        totalPossibleDistance: 0,
        zone: AntZone.trunk,
        goal: AntGoal.up,
        scale: .9 + (Random().nextDouble() / 2),
        size: Size.zero,
        walkCompleted: true,
      ),
    );
    notifyListeners();
  }
}
