import 'dart:math';
import 'dart:ui';

import 'package:guanabana/state/progress.state.dart';
import 'package:guanabana/zelpers/app.colors.dart';
import 'package:guanabana/zelpers/gi.dart';

import '../zelpers/rndIt.dart';

class NewSpiker {
  static void spikenPathTotal(Path path, Canvas canvas) {
    Function rndIt = RndIt.rndIt;
    try {
      PathMetric pathMetric = path.computeMetrics().first;

      double length = pathMetric.length;
      int numRows = gi<ProgressState>().progressStep > 8
          ? 8
          : gi<ProgressState>().progressStep;

      for (var i = 1; i < numRows; i++) {
        Offset pointA =
            pathMetric.getTangentForOffset(length * (i / 20))!.position;
        Offset pointB =
            pathMetric.getTangentForOffset(length * (1 - (i / 20)))!.position;

        Path quad = Path();
        quad.moveTo(pointA.dx, pointA.dy);
        Offset fineTune = const Offset(-50, 155);
        quad.quadraticBezierTo(
          pointA.dx + rndIt(fineTune.dx, 0),
          pointA.dy + rndIt(fineTune.dy, 0),
          pointB.dx,
          pointB.dy,
        );

        spikenPath(quad, canvas, rndIt(35, 0));
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  static void spikenPath(Path path, Canvas canvas, double lenBetweenSpikes) {
    Function rndIt = RndIt.rndIt;
    try {
      PathMetric pathMetric = path.computeMetrics().first;
      double length = pathMetric.length;
      int numSpikes = length ~/ lenBetweenSpikes;
      //
      for (var i = 0; i < numSpikes; i++) {
        Tangent tangentA =
            pathMetric.getTangentForOffset(length * (i / numSpikes))!;
        canvas.save();
        canvas.translate(tangentA.position.dx, tangentA.position.dy);
        canvas.rotate(pi - tangentA.angle);
        canvas.translate(-tangentA.position.dx, -tangentA.position.dy);
        Path spikePath = Path();
        spikePath.moveTo(tangentA.position.dx, tangentA.position.dy);
        spikePath.relativeQuadraticBezierTo(
            -rndIt(5, 0), rndIt(2, 0), rndIt(7, 0), rndIt(40, 0));
        spikePath.relativeQuadraticBezierTo(
            rndIt(5, 0), -rndIt(2, 0), rndIt(7, 0), -rndIt(43, 0));
        canvas.translate(-rndIt(20, 0), 0);
        canvas.drawPath(spikePath, Paint()..color = greenDark);
        canvas.drawPath(
            spikePath,
            Paint()
              ..color = greenLight
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1);
        canvas.restore();
      }
    } catch (e) {
      //
    }
  }
}
