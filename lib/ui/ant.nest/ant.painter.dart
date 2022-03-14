import 'dart:ui';

import 'package:flutter/material.dart';

import '../../state/ant.state.dart';
import '../../zelpers/app.colors.dart';
import '../../zelpers/rndIt.dart';

class AntPainter extends CustomPainter {
  AntPainter({required this.ant, this.legAnim = 0});
  final AntModel ant;
  final double legAnim;

  @override
  void paint(Canvas canvas, Size size) {
    Function rndIt = RndIt.rndIt;
    // abdomen
    Path pathAbdomen = Path();
    pathAbdomen.moveTo(size.width * .5, size.height * .33);
    pathAbdomen.quadraticBezierTo(size.width * .0, size.height * .15,
        (size.width * .5 - 2.5) + legAnim / 2, -rndIt(7, 0));
    pathAbdomen.quadraticBezierTo(
        size.width * 1, size.height * .15, size.width * .5, size.height * .33);
    Rect abdoRect = pathAbdomen.getBounds();
    canvas.drawShadow(pathAbdomen, Colors.black54, 7, false);
    canvas.drawPath(
        pathAbdomen,
        Paint()
          ..shader = const RadialGradient(
            focal: Alignment(0, 0),
            focalRadius: .15,
            center: Alignment(0, .2),
            colors: [
              redDark,
              redLight,
            ],
          ).createShader(
            Rect.fromPoints(
              abdoRect.topLeft,
              abdoRect.bottomRight,
            ),
          ));
    PathMetric abdoPM = pathAbdomen.computeMetrics().toList().first;
    Offset abdoP1 = abdoPM.getTangentForOffset(abdoPM.length * .3)!.position;
    Offset abdoP2 = abdoPM.getTangentForOffset(abdoPM.length * .7)!.position;
    Offset abdoP3 = abdoPM.getTangentForOffset(abdoPM.length * .2)!.position;
    Offset abdoP4 = abdoPM.getTangentForOffset(abdoPM.length * .8)!.position;
    Path abdoLines = Path();
    abdoLines.moveTo(abdoP1.dx, abdoP1.dy);
    abdoLines.quadraticBezierTo(abdoP2.dx - abdoRect.width * .5,
        abdoP1.dy - rndIt(3, 0), abdoP2.dx, abdoP2.dy);
    abdoLines.moveTo(abdoP3.dx, abdoP3.dy);
    abdoLines.quadraticBezierTo(abdoP4.dx - abdoRect.width * .5,
        abdoP3.dy - rndIt(1, 0), abdoP4.dx, abdoP4.dy);
    canvas.drawPath(
        abdoLines,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = redLight
          ..strokeWidth = .8);
    // thorax
    Path pathThorax = Path();
    pathThorax.moveTo(size.width * .5, size.height * .66);
    pathThorax.quadraticBezierTo(size.width * .2 - legAnim / 4,
        size.height * .5, size.width * .5, size.height * .33);
    pathThorax.quadraticBezierTo(size.width * .8 + legAnim / 4,
        size.height * .5, size.width * .5, size.height * .66);
    // Rect thoraxRect = pathThorax.getBounds();

    PathMetric pathMetricThorax = pathThorax.computeMetrics().toList().first;
    double pathMetricThoraxLen = pathMetricThorax.length;
    Paint paintLeg = Paint();
    paintLeg.style = PaintingStyle.stroke;
    paintLeg.strokeWidth = rndIt(1, 0);
    paintLeg.color = redDark;
    // leg lower left
    Offset legLLPoint = pathMetricThorax
        .getTangentForOffset(pathMetricThoraxLen * .6)!
        .position;
    // canvas.drawCircle(legLLPoint, 2, Paint()..color = Colors.yellow);
    Path legLLPath = Path();
    legLLPath.moveTo(legLLPoint.dx, legLLPoint.dy);
    legLLPath.relativeQuadraticBezierTo(
        rndIt(5, 0), rndIt(3, 0), rndIt(15, 0), rndIt(-15 + legAnim, 0));
    legLLPath.relativeQuadraticBezierTo(
        rndIt(5, 0), rndIt(3, 0), rndIt(15, 0), rndIt(-15 + legAnim / 2, 0));
    canvas.drawPath(legLLPath, paintLeg);
    // legs lower right
    Offset legLRPoint = pathMetricThorax
        .getTangentForOffset(pathMetricThoraxLen * .4)!
        .position;
    // canvas.drawCircle(legLRPoint, 2, Paint()..color = Colors.yellow);
    Path legLRPath = Path();
    legLRPath.moveTo(legLRPoint.dx, legLRPoint.dy);
    legLRPath.relativeQuadraticBezierTo(rndIt(-5, 0), rndIt(3, 0),
        rndIt(-15, 0), rndIt(-15 + (10 - legAnim), 0));
    legLRPath.relativeQuadraticBezierTo(rndIt(-5, 0), rndIt(3, 0),
        rndIt(-15, 0), rndIt(-15 + (10 - legAnim) / 2, 0));
    canvas.drawPath(legLRPath, paintLeg);

    // legs center right
    Offset legCRPoint = pathMetricThorax
        .getTangentForOffset(pathMetricThoraxLen * .3)!
        .position;
    // canvas.drawCircle(legCRPoint, 2, Paint()..color = Colors.yellow);
    Path legCRPath = Path();
    legCRPath.moveTo(legCRPoint.dx, legCRPoint.dy);
    legCRPath.relativeQuadraticBezierTo(
        rndIt(-5, 0), rndIt(3, 0), rndIt(-19, 0), rndIt(-5 + legAnim, 0));
    legCRPath.relativeQuadraticBezierTo(
        rndIt(-5, 0), rndIt(3, 0), rndIt(-19, 0), rndIt(-5 + legAnim / 2, 0));
    canvas.drawPath(legCRPath, paintLeg);

    // legs center left
    Offset legCLPoint = pathMetricThorax
        .getTangentForOffset(pathMetricThoraxLen * .7)!
        .position;
    // canvas.drawCircle(legCLPoint, 2, Paint()..color = Colors.yellow);
    Path legCLPath = Path();
    legCLPath.moveTo(legCLPoint.dx, legCLPoint.dy);
    legCLPath.relativeQuadraticBezierTo(
        rndIt(5, 0), rndIt(3, 0), rndIt(19, 0), rndIt(-5 + (10 - legAnim), 0));
    legCLPath.relativeQuadraticBezierTo(
        rndIt(5, 0), rndIt(3, 0), rndIt(19, 0), rndIt(-5 + (10 - legAnim), 0));
    canvas.drawPath(legCLPath, paintLeg);

    // legs top left
    Offset legTLPoint = pathMetricThorax
        .getTangentForOffset(pathMetricThoraxLen * .35)!
        .position;
    // canvas.drawCircle(legTLPoint, 2, Paint()..color = Colors.yellow);
    Path legTLPath = Path();
    legTLPath.moveTo(legTLPoint.dx, legTLPoint.dy);
    legTLPath.relativeQuadraticBezierTo(
        rndIt(5, 0), rndIt(6, 0), rndIt(20, 0), rndIt(8 + legAnim, 0));
    legTLPath.relativeQuadraticBezierTo(
        rndIt(5, 0), rndIt(6, 0), rndIt(20, 0), rndIt(8 + legAnim / 2, 0));
    canvas.drawPath(legTLPath, paintLeg);

    // legs top right
    Offset legTRPoint = pathMetricThorax
        .getTangentForOffset(pathMetricThoraxLen * .65)!
        .position;
    // canvas.drawCircle(legTRPoint, 2, Paint()..color = Colors.yellow);
    Path legTRPath = Path();
    legTRPath.moveTo(legTRPoint.dx, legTRPoint.dy);
    legTRPath.relativeQuadraticBezierTo(
        rndIt(-5, 0), rndIt(6, 0), rndIt(-20, 0), rndIt(8 + (10 - legAnim), 0));
    legTRPath.relativeQuadraticBezierTo(
        rndIt(-5, 0), rndIt(6, 0), rndIt(-20, 0), rndIt(8 + (10 - legAnim), 0));
    canvas.drawPath(legTRPath, paintLeg);

    // paint thorax on top of legs
    canvas.drawShadow(pathThorax, Colors.black54, 7, false);
    canvas.drawPath(pathThorax, Paint()..color = redDark);
    canvas.drawLine(
        legLRPoint,
        legLLPoint,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = redLight);
    canvas.drawLine(
        legCRPoint,
        legCLPoint,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = redLight);

    // head
    Path pathHead = Path();
    pathHead.moveTo(size.width * .5, size.height * .66);
    pathHead.quadraticBezierTo(0, size.height * .8,
        (size.width * .5 - 2.5) + legAnim / 3, size.height);
    pathHead.quadraticBezierTo(
        size.width, size.height * .8, size.width * .5, size.height * .66);
    Rect headRect = pathHead.getBounds();
    canvas.drawShadow(pathHead, Colors.black54, 7, false);
    canvas.drawPath(
        pathHead,
        Paint()
          ..shader = const RadialGradient(
            focal: Alignment(0, 0),
            focalRadius: .17,
            center: Alignment(0, 0),
            colors: [
              redDark,
              redLight,
            ],
          ).createShader(
            Rect.fromPoints(
              headRect.topLeft,
              headRect.bottomRight,
            ),
          ));
    canvas.drawCircle(Offset(size.width * .4, size.height * .91), .7, Paint());
    canvas.drawCircle(Offset(size.width * .6, size.height * .91), .7, Paint());
    Path antennaPathL = Path();
    antennaPathL.moveTo(size.width * .48, size.height);
    antennaPathL.quadraticBezierTo(
        size.width * .8, size.height - 3, size.width, size.height);
    antennaPathL.quadraticBezierTo(size.width * .9, size.height + 7,
        (size.width + 4) + legAnim / 3, size.height + 15);
    canvas.drawPath(antennaPathL, paintLeg..strokeWidth = rndIt(.5, 0));
    Path antennaPathR = Path();
    antennaPathR.moveTo((size.width), size.height);
    antennaPathR.quadraticBezierTo(
        size.width * .2, size.height - 3, 0, size.height);
    antennaPathR.quadraticBezierTo(
        size.width * .1, size.height + 7, -4 + legAnim / 3, size.height + 15);
    canvas.drawPath(antennaPathR, paintLeg..strokeWidth = rndIt(.5, 0));
  }

  @override
  bool shouldRepaint(covariant AntPainter oldDelegate) {
    return oldDelegate.ant != ant;
  }
}
