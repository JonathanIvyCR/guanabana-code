import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:guanabana/state/puzzle.state.dart';
import 'package:guanabana/ui/spiker.dart';
import 'package:guanabana/zelpers/app.colors.dart';
import 'package:guanabana/zelpers/gi.dart';

import '../../../zelpers/rndIt.dart';

class GuanabanaWholePainter extends CustomPainter {
  final double rotation;

  GuanabanaWholePainter({
    this.rotation = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Function rndIt = RndIt.rndIt;
    final double sideSize = gi<PuzzleState>().size.height;
    final double sideScale = sideSize / 1000;
    final double half = sideScale * sideSize;

    double rotX = Random().nextInt(1).toDouble();
    double rotY = Random().nextInt(1).toDouble();
    double rotZ = Random().nextInt(1).toDouble();
    if (Random().nextBool()) {
      rotX = -rotX;
    }

    if (Random().nextBool()) {
      rotY = -rotY;
    }

    if (Random().nextBool()) {
      rotZ = -rotZ;
    }

    Offset _startingPoint = Offset(rndIt(500, 50), rndIt(120, 50));
    final Path guanabanaFront = Path();
    guanabanaFront.moveTo(_startingPoint.dx, _startingPoint.dy);
    guanabanaFront.quadraticBezierTo(
      rndIt(100, 75),
      rndIt(100, 75),
      rndIt(200, 65),
      rndIt(400, 165),
    );

    guanabanaFront.quadraticBezierTo(
      rndIt(200, 75),
      rndIt(850, 75),
      rndIt(500, 65),
      rndIt(920, 65),
    );

    guanabanaFront.quadraticBezierTo(
      rndIt(700, 75),
      rndIt(850, 175),
      rndIt(750, 65),
      rndIt(500, 165),
    );

    guanabanaFront.quadraticBezierTo(
      rndIt(900, 75),
      rndIt(100, 75),
      _startingPoint.dx,
      _startingPoint.dy,
    );

    final PathMetric fruitPathMetric =
        guanabanaFront.computeMetrics().toList().first;

    canvas.translate(rndIt(40, 0), 0);

    canvas.save(); // pathLayer.matrix.rotation != 0

    canvas.translate(half, half);
    canvas.rotate(rotation * (pi / 180));
    canvas.translate(-half, -half);

    canvas.save(); // pathLayer.matrix.rotateX != 0
    canvas.translate(half, half);
    final Matrix4 rotateX0p2 = Matrix4.identity()
      ..setEntry(3, 2, 0)
      ..rotateX(rotX * (pi / 180));
    canvas.transform(rotateX0p2.storage);
    canvas.translate(-half, -half);

    canvas.save(); // pathLayer.matrix.rotateY != 0
    canvas.translate(half, half);
    final Matrix4 rotateY0p2 = Matrix4.identity()
      ..setEntry(3, 2, 0)
      ..rotateY(rotY * (pi / 180));
    canvas.transform(rotateY0p2.storage);
    canvas.translate(-half, -half);

    canvas.save(); // pathLayer.matrix.rotateZ != 0
    canvas.translate(half, half);
    final Matrix4 rotateZ0p2 = Matrix4.identity()
      ..setEntry(3, 2, 0)
      ..rotateZ(rotZ * (pi / 180));
    canvas.transform(rotateZ0p2.storage);
    canvas.translate(-half, -half);

    canvas.save(); // pathLayer.matrix.scaleY != 0
    canvas.translate(half, half);
    final Matrix4 scaleY0p2 = Matrix4.identity()
      ..setEntry(3, 2, 0)
      ..scale(1.0, 1.0);
    canvas.transform(scaleY0p2.storage);
    canvas.translate(-half, -half);

    canvas.save(); // pathLayer.matrix.skewX || skewY != 0
    canvas.translate(half, half);
    canvas.skew(0, 0);
    canvas.translate(-half, -half);

    Rect boundsFruit = guanabanaFront.getBounds();
    canvas.save(); // pathLayer.matrix.skewX || skewY != 0
    canvas.translate(half, half);
    canvas.rotate(-10 * (pi / 180));
    canvas.translate(-half, -half);
    Path shadowPath = Path();

    Offset shadowTop = fruitPathMetric
        .getTangentForOffset(fruitPathMetric.length * 0)!
        .position;
    Offset shadowBottom = fruitPathMetric
        .getTangentForOffset(fruitPathMetric.length * .5)!
        .position;

    shadowPath.moveTo(shadowTop.dx, shadowTop.dy - rndIt(30, 0));

    shadowPath.quadraticBezierTo(rndIt(-300, 0), rndIt(100, 0),
        shadowBottom.dx - rndIt(1, 0), shadowBottom.dy - rndIt(20, 0));

    // shadow points
    Spiker.paintSpikes(
        path: shadowPath, canvas: canvas, numberOfSpikes: 40, isShadow: true);
    canvas.drawPath(shadowPath, Paint()..color = Colors.black26);

    canvas.restore();
    Rect guanabanaFrontRect = guanabanaFront.getBounds();
    Path woodStemPath = Path();
    Offset coreTopA = guanabanaFront
        .computeMetrics()
        .toList()
        .first
        .getTangentForOffset(rndIt(70, 0))!
        .position;
    Offset coreTopB = guanabanaFront
        .computeMetrics()
        .toList()
        .first
        .getTangentForOffset(fruitPathMetric.length - rndIt(70, 0))!
        .position;
    woodStemPath.moveTo(coreTopA.dx + 25, coreTopA.dy + 5);
    woodStemPath.quadraticBezierTo(
        coreTopA.dx + 15, coreTopA.dy + 20, coreTopB.dx - 20, coreTopB.dy + 5);
    woodStemPath.quadraticBezierTo(
        coreTopB.dx - 15, coreTopB.dy - 50, coreTopB.dx - 10, coreTopB.dy - 50);
    woodStemPath.quadraticBezierTo(
        coreTopA.dx + 15, coreTopA.dy - 60, coreTopA.dx + 5, coreTopA.dy - 45);
    woodStemPath.quadraticBezierTo(
        coreTopA.dx + 25, coreTopA.dy - 25, coreTopA.dx + 25, coreTopA.dy + 5);
    canvas.translate(-rndIt(30, 0), -rndIt(30, 0));
    canvas.drawPath(woodStemPath, Paint()..color = Colors.black26);
    canvas.translate(rndIt(20, 0), rndIt(20, 0));
    canvas.drawPath(woodStemPath, Paint()..color = Colors.brown);
    canvas.drawOval(
        Rect.fromPoints(Offset(coreTopA.dx + 12, coreTopA.dy - 40),
            Offset(coreTopB.dx - 12, coreTopB.dy - 55)),
        Paint()..color = Colors.brown[400]!);

    canvas.save(); // pathLayer.matrix.rotateY != 0
    canvas.translate(half, half);
    final Matrix4 rotateFrontY = Matrix4.identity()
      ..setEntry(3, 2, 0)
      // ..rotateY(-30 * (pi / 180));
      ..rotateY(0);
    canvas.transform(rotateFrontY.storage);
    canvas.translate(-half, -half);
    canvas.drawPath(
        guanabanaFront,
        Paint()
          ..shader = const RadialGradient(
            focal: Alignment(0.6, 0),
            focalRadius: .15,
            center: Alignment(.5, .4),
            colors: [
              greenLight,
              greenDark,
            ],
          ).createShader(
            Rect.fromPoints(
              guanabanaFrontRect.topLeft,
              guanabanaFrontRect.bottomRight,
            ),
          ));
    canvas.drawPath(
        guanabanaFront,
        Paint()
          ..strokeWidth = rndIt(7, 0)
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..blendMode = BlendMode.srcOver
          ..style = PaintingStyle.stroke
          ..color = const Color(0xff005804)
          ..isAntiAlias = true);
    canvas.drawPath(
        guanabanaFront,
        Paint()
          ..color = greenLight
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    Spiker.paintSpikes(
        path: guanabanaFront, canvas: canvas, numberOfSpikes: 45);

    Offset anchorPointBottomRight = fruitPathMetric
        .getTangentForOffset(fruitPathMetric.length * .7)!
        .position;

    for (var i = 0; i < 5; i++) {
      Path spikePath = Path();
      Offset spikePathTop = fruitPathMetric
          .getTangentForOffset(fruitPathMetric.length * (i / 30))!
          .position;
      Offset spikePathBottom = fruitPathMetric
          .getTangentForOffset(fruitPathMetric.length * (.5 - (i / 30)))!
          .position;
      spikePath.moveTo(spikePathTop.dx, spikePathTop.dy + rndIt(50, 0));

      spikePath.quadraticBezierTo(
          rndIt((size.width * .5 - (-rndIt(150, 0) * (-i / 5))).toInt(), 0),
          rndIt(anchorPointBottomRight.dy.toInt(), 0),
          spikePathBottom.dx,
          spikePathBottom.dy);

      Spiker.paintSpikes(path: spikePath, canvas: canvas, numberOfSpikes: 70);
    }

    for (var i = 0; i < 5; i++) {
      Path spikePath = Path();
      Offset spikePathTop = fruitPathMetric
          .getTangentForOffset(fruitPathMetric.length * (1 - (i / 30)))!
          .position;
      Offset spikePathBottom = fruitPathMetric
          .getTangentForOffset(fruitPathMetric.length * (.5 + (i / 30)))!
          .position;
      spikePath.moveTo(spikePathBottom.dx, spikePathBottom.dy - rndIt(120, 10));

      spikePath.quadraticBezierTo(
          rndIt((size.width * 1 + (rndIt(150, 0) * (i / 5))).toInt(), 0),
          rndIt(anchorPointBottomRight.dy.toInt(), 0),
          spikePathTop.dx,
          spikePathTop.dy);

      Spiker.paintSpikes(path: spikePath, canvas: canvas, numberOfSpikes: 70);
    }

    Offset middleSpikesTop = Offset(
        boundsFruit.topCenter.dx, boundsFruit.topCenter.dy + rndIt(100, 0));

    Offset middleSpikesBottom = Offset(boundsFruit.bottomCenter.dx,
        boundsFruit.bottomCenter.dy - rndIt(100, 0));
    Path middleSpikeLeftPath = Path();
    middleSpikeLeftPath.moveTo(middleSpikesTop.dx, middleSpikesTop.dy);
    middleSpikeLeftPath.quadraticBezierTo(boundsFruit.center.dx - rndIt(100, 0),
        boundsFruit.center.dy, middleSpikesBottom.dx, middleSpikesBottom.dy);
    Spiker.paintSpikes(
        path: middleSpikeLeftPath, canvas: canvas, numberOfSpikes: 70);

    Path middleSpikeRightPath = Path();
    middleSpikeRightPath.moveTo(middleSpikesBottom.dx, middleSpikesBottom.dy);
    middleSpikeRightPath.quadraticBezierTo(
        boundsFruit.center.dx + rndIt(20, 20),
        boundsFruit.center.dy,
        middleSpikesTop.dx,
        middleSpikesTop.dy);
    Spiker.paintSpikes(
        path: middleSpikeRightPath, canvas: canvas, numberOfSpikes: 70);
    canvas.restore(); // restoring fruitFront rotation y
    canvas.restore(); // restoring rotation transform
    canvas.restore(); // restoring rotateX transform
    canvas.restore(); // restoring rotateY transform
    canvas.restore(); // restoring rotateZ transform
    // canvas.restore(); // restoring scaleY transform
    canvas.restore(); // restoring interiorshadow scale transform
    canvas.restore(); // restoring skew transform
  }

  @override
  bool shouldRepaint(covariant GuanabanaWholePainter oldDelegate) {
    return false;
  }
}
