import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:guanabana/state/progress.state.dart';

import 'package:guanabana/ui/new.spiker.dart';
import 'package:guanabana/zelpers/gi.dart';

import '../../../zelpers/app.colors.dart';
import '../../../zelpers/rndIt.dart';

class GuanabanaMaker {
  static Offset makeFruitStem(Canvas canvas) {
    final Offset branchPoint = gi<ProgressState>().branchPoint;
    // print('branchPoint: $branchPoint');
    Function rndIt = RndIt.rndIt;
    Path stemPath = Path();
    stemPath.moveTo(branchPoint.dx, branchPoint.dy);
    stemPath.quadraticBezierTo(
        branchPoint.dx + rndIt(40, 0),
        branchPoint.dy - rndIt(30, 0),
        branchPoint.dx + rndIt(95, 0),
        branchPoint.dy + rndIt(50, 0));
    stemPath.quadraticBezierTo(
        branchPoint.dx + rndIt(60, 0),
        branchPoint.dy + rndIt(70, 0),
        branchPoint.dx + rndIt(65, 0),
        branchPoint.dy + rndIt(75, 0));
    stemPath.quadraticBezierTo(
        branchPoint.dx + rndIt(40, 0),
        branchPoint.dy - rndIt(10, 0),
        branchPoint.dx - rndIt(5, 0),
        branchPoint.dy + rndIt(20, 0));
    stemPath.quadraticBezierTo(branchPoint.dx - rndIt(30, 0),
        branchPoint.dy - rndIt(10, 0), branchPoint.dx, branchPoint.dy);
    canvas.save();
    Rect stemBounds = stemPath.getBounds();
    canvas.drawPath(
        stemPath,
        Paint()
          ..shader = RadialGradient(
            focal: gi<ProgressState>().lightAlignment,
            focalRadius: .01,
            center: gi<ProgressState>().lightAlignment,
            colors: [
              Colors.brown[800]!,
              Colors.brown[700]!,
            ],
          ).createShader(
            Rect.fromPoints(
              stemBounds.topLeft,
              stemBounds.bottomRight,
            ),
          ));
    canvas.drawPath(
      stemPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.brown[900]!.withOpacity(.4)
        ..strokeWidth = rndIt(1, 0),
    );
    canvas.translate(-branchPoint.dx, -branchPoint.dy);
    canvas.restore();
    final PathMetric pathMetric = stemPath.computeMetrics().toList().first;
    final Offset stemPoint =
        pathMetric.getTangentForOffset(pathMetric.length * .5)!.position;

    return stemPoint;
  }

  static Path makeFruit(Canvas canvas, double scale, List<double> randos) {
    Path fruitPath = Path();
    Function rndIt = RndIt.rndIt;

    Offset stemPoint = makeFruitStem(canvas);

    fruitPath.moveTo(stemPoint.dx, stemPoint.dy);

    fruitPath.relativeQuadraticBezierTo(
      rndIt(180 * scale, 0) + (50 * randos[0]),
      rndIt(-150 * scale, 0) + (30 * randos[1]),
      rndIt(250 * scale, 0) + (50 * randos[2]),
      rndIt(200 * scale, 0) + (30 * randos[3]),
    );

    fruitPath.relativeQuadraticBezierTo(
      rndIt(50 * scale, 0) + (30 * randos[4]),
      rndIt(50 * scale, 0) + (30 * randos[5]),
      rndIt(-50 * scale, 0) + (30 * randos[6]),
      rndIt(130 * scale, 0) + (50 * randos[7]),
    );
    fruitPath.relativeQuadraticBezierTo(
      rndIt(-50 * scale, 0) + (30 * randos[8]),
      rndIt(150 * scale, 0) + (30 * randos[0]),
      rndIt(-200 * scale, 0) + (30 * randos[1]),
      rndIt(50 * scale, 0) + (30 * randos[2]),
    );
    fruitPath.quadraticBezierTo(
      stemPoint.dx + rndIt(-150 * scale, 0) + (20 * randos[0]),
      stemPoint.dy + rndIt(50 * scale, 0) + (20 * randos[0]),
      stemPoint.dx,
      stemPoint.dy,
    );

    Rect fruitBoundsRect = fruitPath.getBounds();

    canvas.drawPath(
        fruitPath,
        Paint()
          ..shader = RadialGradient(
            focal: gi<ProgressState>().lightAlignment,
            focalRadius: .22,
            center: gi<ProgressState>().lightAlignment,
            colors: const [
              greenLight,
              greenDark,
            ],
          ).createShader(
            Rect.fromPoints(
              fruitBoundsRect.topLeft,
              fruitBoundsRect.bottomRight,
            ),
          ));
    NewSpiker.spikenPath(fruitPath, canvas, rndIt(40, 0));

    canvas.drawPath(
        fruitPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = greenDark
          ..strokeWidth = 2);
    canvas.drawPath(
        fruitPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = greenLight
          ..strokeWidth = .75);
    NewSpiker.spikenPathTotal(fruitPath, canvas);
    // canvas.restore();
    makeFruitStem(canvas);
    return fruitPath;
  }

  static Path makeFlower(Canvas canvas, double flowerScale, Color color,
      double translateX, double translateY) {
    Function rndIt = RndIt.rndIt;
    canvas.save();
    Offset stemPoint = makeFruitStem(canvas);

    canvas.translate(stemPoint.dx, stemPoint.dy);
    final Matrix4 scaleY0p2 = Matrix4.identity()
      ..setEntry(3, 2, 0)
      ..scale(flowerScale, flowerScale);
    // ..scale(1.01, 1);
    canvas.transform(scaleY0p2.storage);

    // canvas.save(); // overall save
    final Path petal1Path = Path();
    petal1Path.moveTo(stemPoint.dx + -translateX, stemPoint.dy + translateY);
    petal1Path.quadraticBezierTo(
      stemPoint.dx + rndIt(200, 0) + -translateX,
      stemPoint.dy + rndIt(-100, 0) + translateY,
      stemPoint.dx + rndIt(150, 0) + -translateX,
      stemPoint.dy + rndIt(150, 0) + translateY,
    );
    petal1Path.quadraticBezierTo(
      stemPoint.dx + rndIt(-50, 0) + -translateX,
      stemPoint.dy + rndIt(50, 0) + translateY,
      stemPoint.dx + -translateX,
      stemPoint.dy + translateY,
    );

    final Path petal2Path = Path();
    petal2Path.moveTo(
        stemPoint.dx + (translateX * .5), stemPoint.dy + translateY);
    petal2Path.quadraticBezierTo(
      stemPoint.dx + rndIt(100, 0) + (translateX * .5),
      stemPoint.dy + rndIt(-100, 0) + translateY,
      stemPoint.dx + rndIt(150, 0) + (translateX * .5),
      stemPoint.dy + rndIt(150, 0) + translateY,
    );
    petal2Path.quadraticBezierTo(
      stemPoint.dx + rndIt(-125, 0) + (translateX * .5),
      stemPoint.dy + rndIt(175, 0) + translateY + (flowerScale + 1),
      stemPoint.dx + (translateX * .5),
      stemPoint.dy + translateY,
    );

    final Path petal3Path = Path();
    petal3Path.moveTo(stemPoint.dx + translateX, stemPoint.dy + translateY);
    petal3Path.quadraticBezierTo(
      stemPoint.dx + rndIt(100, 0) + translateX,
      stemPoint.dy + rndIt(-100, 0) + translateY,
      stemPoint.dx + rndIt(150, 0) + translateX,
      stemPoint.dy + rndIt(150, 0) + translateY,
    );
    petal3Path.quadraticBezierTo(
      stemPoint.dx + rndIt(-100, 0) + translateX,
      stemPoint.dy + rndIt(100, 0) + translateY,
      stemPoint.dx + translateX,
      stemPoint.dy + translateY,
    );

    canvas.translate(-stemPoint.dx, -stemPoint.dy);

    Path shaderPath = Path();
    shaderPath.addPath(petal1Path, Offset.zero);
    shaderPath.addPath(petal2Path, Offset.zero);
    shaderPath.addPath(petal3Path, Offset.zero);
    Rect shaderRect = shaderPath.getBounds();
    canvas.drawPath(
        petal1Path,
        Paint()
          ..style = PaintingStyle.fill
          ..strokeJoin = StrokeJoin.miter
          ..strokeCap = StrokeCap.butt
          ..isAntiAlias = true
          ..blendMode = BlendMode.srcOver
          ..shader = RadialGradient(
            focal: const Alignment(.5, 0),
            focalRadius: .1,
            center: const Alignment(0, 0),
            colors: [color, greenLight],
          ).createShader(
            Rect.fromPoints(shaderRect.topLeft, shaderRect.bottomRight),
          ));

    canvas.drawPath(
        petal2Path,
        Paint()
          ..style = PaintingStyle.fill
          ..strokeJoin = StrokeJoin.miter
          ..strokeCap = StrokeCap.butt
          ..isAntiAlias = true
          ..blendMode = BlendMode.srcOver
          ..shader = RadialGradient(
            focal: const Alignment(0, .5),
            focalRadius: .1,
            center: const Alignment(0, 0),
            colors: [color, greenLight],
          ).createShader(
            Rect.fromPoints(shaderRect.topLeft, shaderRect.bottomRight),
          ));

    canvas.drawPath(
        petal3Path,
        Paint()
          ..style = PaintingStyle.fill
          ..strokeJoin = StrokeJoin.miter
          ..strokeCap = StrokeCap.butt
          ..isAntiAlias = true
          ..blendMode = BlendMode.srcOver
          ..shader = RadialGradient(
            focal: const Alignment(0.2, 0.2),
            focalRadius: .15,
            center: const Alignment(0, 0),
            colors: [color, greenLight],
          ).createShader(
            Rect.fromPoints(shaderRect.topLeft, shaderRect.bottomRight),
          ));

    canvas.restore(); // restoring skew transform

    return shaderPath;
  }
}
