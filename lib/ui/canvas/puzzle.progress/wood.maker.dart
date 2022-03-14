import 'package:flutter/material.dart';
import 'package:guanabana/state/home.state.dart';
import 'package:guanabana/zelpers/rndIt.dart';
import 'package:guanabana/zelpers/gi.dart';

import '../../../state/progress.state.dart';

class WoodMaker {
  static Future<bool> makeTrunk(Canvas canvas) async {
    final ps = gi<ProgressState>();
    Function rndIt = RndIt.rndIt;
    final Size screenSize = gi<HomeState>().screenSize;
    if (!ps.trunkSet) {
      Path trunkPath = Path();
      trunkPath.lineTo(0, screenSize.height);
      trunkPath.lineTo(screenSize.width * .1, screenSize.height);
      trunkPath.quadraticBezierTo(
        screenSize.width * .07,
        screenSize.height * .5,
        screenSize.width * .08,
        0,
      );
      trunkPath.lineTo(0, 0);
      ps.setTrunk(trunkPath);
    } else {
      canvas.drawShadow(ps.trunkPath, Colors.black45, 20, false);
      canvas.drawPath(
          ps.trunkPath,
          Paint()
            ..shader = LinearGradient(
              begin: const Alignment(0, 1),
              // end: Alignment(1, gi<ProgressState>().lightAlignment.y),
              end: gi<ProgressState>().lightAlignment,
              colors: [
                // Colors.brown[700]!,
                // Colors.brown[600]!,
                Colors.brown[700]!,
                Colors.brown[800]!,
              ],
            ).createShader(
              Rect.fromPoints(
                ps.trunkBounds.topLeft,
                ps.trunkBounds.bottomRight,
              ),
            ));
      Path accentPath = Path();
      accentPath.moveTo(ps.trunkBounds.left, ps.trunkBounds.bottom);
      accentPath.quadraticBezierTo(
          screenSize.width * .02,
          screenSize.height * .4,
          ps.trunkBounds.topLeft.dx,
          ps.trunkBounds.topLeft.dy);
      accentPath.lineTo(ps.trunkBounds.left, ps.trunkBounds.bottom);

      accentPath.moveTo(ps.trunkBounds.right * .7, ps.trunkBounds.bottom);
      accentPath.quadraticBezierTo(
          screenSize.width * .02,
          screenSize.height * .4,
          ps.trunkBounds.center.dx,
          ps.trunkBounds.center.dy);
      accentPath.quadraticBezierTo(
          screenSize.width * .05,
          screenSize.height * .8,
          ps.trunkBounds.right * .7,
          ps.trunkBounds.bottom);

      accentPath.moveTo(
        ps.trunkBounds.right * .3,
        ps.trunkBounds.center.dy,
      );
      accentPath.quadraticBezierTo(
          screenSize.width * .02,
          screenSize.height * .4,
          ps.trunkBounds.topCenter.dx - rndIt(30, 0),
          ps.trunkBounds.topCenter.dy - rndIt(30, 0));
      accentPath.quadraticBezierTo(
          screenSize.width * .03,
          screenSize.height * .8,
          ps.trunkBounds.right * .3,
          ps.trunkBounds.center.dy);
      canvas.drawPath(accentPath, Paint()..color = Colors.brown[900]!);
    }
    return Future.value(ps.trunkSet);
  }

  static Future<bool> makeBranch(Canvas canvas) async {
    // Function rndIt = RndIt.rndIt;
    final ps = gi<ProgressState>();
    final Size screenSize = gi<HomeState>().screenSize;
    Path branchPath = Path();
    Offset _textOffsetA = Offset(
      screenSize.width * .45,
      screenSize.height * .09,
    );
    Offset _textOffsetB = Offset(
      screenSize.width * .65,
      screenSize.height * .16,
    );
    gi<ProgressState>().setSignRect(
      Rect.fromPoints(
        _textOffsetA,
        _textOffsetB,
      ),
    );
    double _textWidth = _textOffsetB.dx - _textOffsetA.dx;
    double _textHeight = _textOffsetB.dy - _textOffsetA.dy;
    if (!ps.branchSet) {
      branchPath.moveTo(
        ps.trunkBranchPoint.dx * .7,
        screenSize.height * .15,
      );
      branchPath.quadraticBezierTo(
        screenSize.width * .2,
        screenSize.height * .1,
        _textOffsetA.dx,
        _textOffsetA.dy,
      );
      branchPath.quadraticBezierTo(
        _textOffsetA.dx + (_textWidth * .5),
        _textOffsetA.dy - (_textHeight),
        _textOffsetB.dx,
        _textOffsetA.dy,
      );

      branchPath.quadraticBezierTo(
        screenSize.width * .85,
        screenSize.height * .1,
        screenSize.width,
        screenSize.height * .15,
      );
      branchPath.lineTo(screenSize.width, screenSize.height * .2);
      branchPath.quadraticBezierTo(
        screenSize.width * .9,
        screenSize.height * .15,
        _textOffsetB.dx,
        _textOffsetB.dy,
      );
      branchPath.quadraticBezierTo(
        _textOffsetA.dx + (_textWidth * .5),
        _textOffsetB.dy + (_textHeight),
        _textOffsetA.dx,
        _textOffsetB.dy,
      );
      branchPath.quadraticBezierTo(
        screenSize.width * .25,
        screenSize.height * .13,
        ps.trunkBranchPoint.dx * .7,
        screenSize.height * .2,
      );
      branchPath.quadraticBezierTo(
        ps.trunkBranchPoint.dx * .4,
        screenSize.height * .175,
        ps.trunkBranchPoint.dx * .7,
        screenSize.height * .15,
      );

      await ps.setBranch(branchPath);
    } else {
      // print('drawing branch');
      canvas.drawShadow(ps.branchPath, Colors.black45, 5, false);
      canvas.drawPath(
          ps.branchPath,
          Paint()
            ..style = PaintingStyle.fill
            ..strokeJoin = StrokeJoin.round
            ..strokeCap = StrokeCap.round
            ..blendMode = BlendMode.srcOver
            ..shader = LinearGradient(
              begin: gi<ProgressState>().lightAlignment,
              end: const Alignment(0, 1),
              colors: [
                Colors.brown[800]!,
                Colors.brown[900]!,
                Colors.brown[700]!,
              ],
              // stops: [.4, .5, .9],
            ).createShader(
              Rect.fromPoints(
                  ps.branchBounds.topLeft, ps.branchBounds.bottomRight),
            ));

      Path woodPath = Path();
      woodPath.moveTo(_textOffsetA.dx + (_textWidth * .05), _textOffsetA.dy);
      woodPath.quadraticBezierTo(
        _textOffsetA.dx + (_textWidth * .5),
        _textOffsetA.dy - (_textHeight * .7),
        _textOffsetB.dx - (_textWidth * .05),
        _textOffsetA.dy,
      );
      woodPath.quadraticBezierTo(
        _textOffsetB.dx + (_textWidth * .05),
        _textOffsetB.dy - (_textHeight * .5),
        _textOffsetB.dx - (_textWidth * .05),
        _textOffsetB.dy,
      );
      woodPath.quadraticBezierTo(
        _textOffsetA.dx + (_textWidth * .5),
        _textOffsetB.dy + (_textHeight * .7),
        _textOffsetA.dx + (_textWidth * .05),
        _textOffsetB.dy,
      );
      woodPath.quadraticBezierTo(
        _textOffsetA.dx - (_textWidth * .05),
        _textOffsetA.dy + (_textHeight * .5),
        _textOffsetA.dx + (_textWidth * .05),
        _textOffsetA.dy,
      );

      canvas.drawPath(woodPath, Paint()..color = Colors.brown[500]!);
    }

    return Future.value(ps.branchSet);
  }
}
