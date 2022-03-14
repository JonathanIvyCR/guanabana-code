import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:guanabana/state/puzzle.state.dart';
import 'package:guanabana/zelpers/rndIt.dart';

import 'package:guanabana/zelpers/app.colors.dart';
import 'package:guanabana/zelpers/gi.dart';

import '../../spiker.dart';

class GuanabanaFrontPainter extends CustomPainter {
  final double rotation;

  GuanabanaFrontPainter({
    this.rotation = 0,
  });
  // size: Size(600.0, 600.0)
  @override
  void paint(Canvas canvas, Size size) {
    Function rndIt = RndIt.rndIt;
    final double sideSize = gi<PuzzleState>().size.height;
    final double sideScale = sideSize / 1000;
    final double half = sideScale * sideSize;
    // print('half! $half');
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

    // Rect boundsFruit = guanabanaFront.getBounds();
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

    shadowPath.quadraticBezierTo(rndIt(-300, 0), rndIt(300, 0),
        shadowBottom.dx - rndIt(1, 0), shadowBottom.dy - rndIt(20, 0));

    // shadow points
    Spiker.paintSpikes(
        path: shadowPath, canvas: canvas, numberOfSpikes: 60, isShadow: true);
    canvas.drawPath(shadowPath, Paint()..color = Colors.black26);

    canvas.restore();
    // back body of fruit
    Path backPath = Path();
    Offset bodyTop = fruitPathMetric
        .getTangentForOffset(fruitPathMetric.length * .9)!
        .position;
    Offset bodyBottom = fruitPathMetric
        .getTangentForOffset(fruitPathMetric.length * .55)!
        .position;

    backPath.moveTo(bodyBottom.dx, bodyBottom.dy);

    backPath.quadraticBezierTo(rndIt(1100, 0), rndIt(500, 0),
        bodyTop.dx - rndIt(80, 0), bodyTop.dy - rndIt(40, 0));
    Rect backPathRect = backPath.getBounds();
    canvas.drawPath(
      backPath,
      Paint()
        ..shader = const RadialGradient(
          focal: Alignment(0.6, 0),
          focalRadius: .12,
          center: Alignment(.6, .1),
          colors: [
            greenLight,
            greenDark,
          ],
        ).createShader(
          Rect.fromPoints(
            backPathRect.topLeft,
            backPathRect.bottomRight,
          ),
        ),
    );
    // outermost spikes
    Spiker.paintSpikes(path: backPath, canvas: canvas, numberOfSpikes: 50);
    // midpath spikes
    Path midPath = Path();
    midPath.moveTo(bodyBottom.dx, bodyBottom.dy);
    midPath.quadraticBezierTo(
      rndIt(980, 0),
      rndIt(400, 0),
      bodyTop.dx - rndIt(20, 0),
      bodyTop.dy,
    );

    Spiker.paintSpikes(path: midPath, canvas: canvas, numberOfSpikes: 70);

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
          ..style = PaintingStyle.fill
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..blendMode = BlendMode.srcOver
          ..color = greenLight);
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

    // Interior

    Offset whiteFruitTopPosition =
        fruitPathMetric.getTangentForOffset(0)!.position;

    Offset whiteFruitMiddlePosition = fruitPathMetric
        .getTangentForOffset(fruitPathMetric.length * .25)!
        .position;

    Path whiteFruitInteriorPath = Path();
    whiteFruitInteriorPath.moveTo(
        whiteFruitTopPosition.dx, whiteFruitTopPosition.dy + rndIt(20, 0));
    whiteFruitInteriorPath.quadraticBezierTo(
        whiteFruitMiddlePosition.dx - rndIt(90, 0),
        whiteFruitMiddlePosition.dy - rndIt(350, 0),
        whiteFruitMiddlePosition.dx + rndIt(30, 0),
        whiteFruitMiddlePosition.dy);

    Offset whiteFruitBottomPositionA = fruitPathMetric
        .getTangentForOffset(fruitPathMetric.length * .4)!
        .position;
    whiteFruitInteriorPath.quadraticBezierTo(
        whiteFruitBottomPositionA.dx - rndIt(15, 0),
        whiteFruitBottomPositionA.dy - rndIt(70, 0),
        whiteFruitBottomPositionA.dx + rndIt(20, 0),
        whiteFruitBottomPositionA.dy - rndIt(20, 0));
    Offset whiteFruitBottomPositionB = fruitPathMetric
        .getTangentForOffset(fruitPathMetric.length * .6)!
        .position;
    whiteFruitInteriorPath.quadraticBezierTo(
        whiteFruitBottomPositionB.dx - rndIt(150, 0),
        whiteFruitBottomPositionB.dy + rndIt(190, 0),
        whiteFruitBottomPositionB.dx - rndIt(40, 0),
        whiteFruitBottomPositionB.dy - rndIt(20, 0));

    Offset whiteFruitRightMiddlePosition = fruitPathMetric
        .getTangentForOffset(fruitPathMetric.length * .75)!
        .position;
    whiteFruitInteriorPath.quadraticBezierTo(
        whiteFruitRightMiddlePosition.dx - rndIt(50, 0),
        whiteFruitRightMiddlePosition.dy + rndIt(140, 0),
        whiteFruitRightMiddlePosition.dx - rndIt(25, 0),
        whiteFruitRightMiddlePosition.dy);

    whiteFruitInteriorPath.quadraticBezierTo(
        whiteFruitTopPosition.dx + rndIt(320, 0),
        whiteFruitTopPosition.dy - rndIt(20, 0),
        whiteFruitTopPosition.dx,
        whiteFruitTopPosition.dy + rndIt(25, 0));

    canvas.drawPath(
        whiteFruitInteriorPath,
        Paint()
          ..style = PaintingStyle.fill
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..blendMode = BlendMode.srcOver
          ..color = const Color(0xffe0e2df));

    // Fruit Core

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

    Rect bounds = guanabanaFront.getBounds();
    Offset coreBottomA = Offset(coreTopA.dx - rndIt(5, 15),
        bounds.bottom * .7 + Random().nextInt(rndIt(50, 20) ~/ 1));

    Path fruitCorePath = Path();

    fruitCorePath.moveTo(coreTopA.dx, coreTopA.dy);

    fruitCorePath.relativeCubicTo(-rndIt(30, 0), 50, -rndIt(30, 0),
        rndIt(250, 0), rndIt(30, 0), rndIt(300, 0));
    fruitCorePath.relativeCubicTo(-rndIt(30, 0), rndIt(50, 0), -rndIt(30, 0),
        rndIt(250, 0), 0, rndIt(300, 0));
    fruitCorePath.relativeCubicTo(rndIt(30, 0), -rndIt(50, 0), rndIt(30, 0),
        -rndIt(250, 0), 0, rndIt(-300, 0));
    fruitCorePath.relativeCubicTo(rndIt(30, 0), -rndIt(50, 0), rndIt(30, 0),
        -rndIt(250, 0), rndIt(30, 0), rndIt(-300, 0));
    canvas.drawPath(fruitCorePath, Paint()..color = const Color(0xffe9dfb9));

    canvas.save(); // pathLayer.matrix.scaleY != 0
    canvas.translate(half, half);
    final Matrix4 fruitPathMatrix = Matrix4.identity()
      ..setEntry(3, 2, 0)
      ..scale(.6, .9);
    canvas.transform(fruitPathMatrix.storage);
    canvas.translate(-half, -half);
    canvas.drawPath(fruitCorePath,
        Paint()..color = const Color(0xffe9dfa1).withOpacity(.8));
    canvas.translate(rndIt(25, 0), -rndIt(15, 0));
    canvas.restore();

    // stem

    Path stemGreenPath = Path();
    stemGreenPath.moveTo(coreTopA.dx, coreTopA.dy);
    stemGreenPath.quadraticBezierTo(coreTopA.dx + rndIt(20, 0),
        coreTopA.dy + rndIt(50, 0), coreTopB.dx, coreTopB.dy);
    stemGreenPath.quadraticBezierTo(coreTopB.dx - rndIt(20, 0),
        coreTopB.dy - rndIt(20, 0), coreTopA.dx, coreTopA.dy);
    canvas.drawPath(stemGreenPath, Paint()..color = greenLight);

    Path woodStemPath = Path();
    woodStemPath.moveTo(coreTopA.dx + rndIt(25, 0), coreTopA.dy + rndIt(5, 0));
    woodStemPath.quadraticBezierTo(
        coreTopA.dx + rndIt(15, 0),
        coreTopA.dy + rndIt(20, 0),
        coreTopB.dx - rndIt(20, 0),
        coreTopB.dy + rndIt(5, 0));
    woodStemPath.quadraticBezierTo(
        coreTopB.dx - rndIt(15, 0),
        coreTopB.dy - rndIt(50, 0),
        coreTopB.dx - rndIt(10, 0),
        coreTopB.dy - rndIt(50, 0));
    woodStemPath.quadraticBezierTo(
        coreTopA.dx + rndIt(15, 0),
        coreTopA.dy - rndIt(60, 0),
        coreTopA.dx + rndIt(5, 0),
        coreTopA.dy - rndIt(45, 0));
    woodStemPath.quadraticBezierTo(
        coreTopA.dx + rndIt(25, 0),
        coreTopA.dy - rndIt(25, 0),
        coreTopA.dx + rndIt(25, 0),
        coreTopA.dy + rndIt(5, 0));
    canvas.drawPath(woodStemPath, Paint()..color = Colors.brown);
    canvas.drawOval(
        Rect.fromPoints(
            Offset(coreTopA.dx + rndIt(12, 0), coreTopA.dy - rndIt(40, 0)),
            Offset(coreTopB.dx - rndIt(12, 0), coreTopB.dy - rndIt(55, 0))),
        Paint()..color = Colors.brown[400]!);
    // Seeds
    Path seedPath = Path();
    seedPath.moveTo(coreTopA.dx, coreTopA.dy);
    seedPath.quadraticBezierTo(coreTopA.dx - rndIt(60, 0), rndIt(350, 0),
        coreBottomA.dx + rndIt(30, 0), coreBottomA.dy + rndIt(50, 0));
    seedPath.quadraticBezierTo(coreTopB.dx + rndIt(60, 0),
        coreTopB.dy + rndIt(350, 0), coreTopB.dx, coreTopB.dy);

    int _rawSeeds = 8 + Random().nextInt(6);

    PathMetric corePathMetric = seedPath.computeMetrics().toList().first;

    for (var i = 0; i < _rawSeeds; i++) {
      Offset _seedLoc = corePathMetric
          .getTangentForOffset(corePathMetric.length * (i / _rawSeeds))!
          .position;
      if (_seedLoc.dy > bounds.top + rndIt(80, 0) &&
          _seedLoc.dy < bounds.bottom - rndIt(80, 0)) {
        Path _seedPath = Path();

        if (i >= _rawSeeds / 2) {
          Offset _seedTip = Offset(_seedLoc.dx + rndIt(80, 15), _seedLoc.dy);

          _seedPath.moveTo(_seedLoc.dx, _seedLoc.dy);
          _seedPath.cubicTo(
            _seedLoc.dx + rndIt(4, 0),
            _seedLoc.dy - rndIt(20, 0),
            _seedTip.dx + rndIt(2, 0),
            _seedTip.dy - rndIt(34, 0),
            _seedTip.dx,
            _seedTip.dy,
          );
          _seedPath.cubicTo(
            _seedTip.dx + rndIt(2, 0),
            _seedTip.dy + rndIt(34, 0),
            _seedLoc.dx + rndIt(4, 0),
            _seedLoc.dy + rndIt(20, 0),
            _seedLoc.dx,
            _seedLoc.dy,
          );
        } else {
          Offset _seedTip = Offset(_seedLoc.dx - rndIt(80, 15), _seedLoc.dy);

          _seedPath.moveTo(_seedLoc.dx, _seedLoc.dy);
          _seedPath.cubicTo(
            _seedLoc.dx - rndIt(4, 0),
            _seedLoc.dy - rndIt(20, 0),
            _seedTip.dx - rndIt(2, 0),
            _seedTip.dy - rndIt(34, 0),
            _seedTip.dx,
            _seedTip.dy,
          );
          _seedPath.cubicTo(
            _seedTip.dx - rndIt(2, 0),
            _seedTip.dy + rndIt(34, 0),
            _seedLoc.dx - rndIt(4, 0),
            _seedLoc.dy + rndIt(20, 0),
            _seedLoc.dx,
            _seedLoc.dy,
          );
        }
        if (Random().nextDouble() >= .0) {
          canvas.save(); // pathLayer.matrix.scaleY != 0
          canvas.translate(half, half);
          final Matrix4 shadow = Matrix4.identity()
            ..setEntry(3, 2, 0)
            ..scale(1.05, 1.03);
          canvas.transform(shadow.storage);
          canvas.translate(-half, -half);
          canvas.drawPath(_seedPath, Paint()..color = const Color(0xffe9dfb9));
          canvas.restore();
          canvas.drawPath(_seedPath, Paint());
          Rect seedBounds = _seedPath.getBounds();
          // print(seedBounds.center);
          Path _seedHighlightPath = Path();
          if (i >= _rawSeeds / 2) {
            _seedHighlightPath.moveTo(
                seedBounds.center.dx - rndIt(15, 0), seedBounds.center.dy);
            _seedHighlightPath.relativeQuadraticBezierTo(
                rndIt(11, 0), -rndIt(8, 0), rndIt(23, 0), -rndIt(7, 0));
            _seedHighlightPath.relativeQuadraticBezierTo(
                rndIt(8, 0), rndIt(12, 0), rndIt(3, 0), rndIt(10, 0));
            _seedHighlightPath.relativeQuadraticBezierTo(
                0, -rndIt(7, 0), -rndIt(26, 0), -rndIt(3, 0));
          } else {
            _seedHighlightPath.moveTo(
                seedBounds.center.dx + 15, seedBounds.center.dy);
            _seedHighlightPath.relativeQuadraticBezierTo(
                -13, -rndIt(8, 0), -25, -rndIt(7, 0));
            _seedHighlightPath.relativeQuadraticBezierTo(
                -rndIt(8, 0), rndIt(12, 0), -rndIt(3, 0), rndIt(10, 0));
            _seedHighlightPath.relativeQuadraticBezierTo(
                0, -rndIt(7, 0), rndIt(26, 0), -rndIt(3, 0));
          }

          canvas.drawPath(_seedHighlightPath, Paint()..color = Colors.white);
        }
      }
    }

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
  bool shouldRepaint(covariant GuanabanaFrontPainter oldDelegate) {
    return false;
  }
}
