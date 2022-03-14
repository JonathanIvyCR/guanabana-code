import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:guanabana/zelpers/app.colors.dart';

import '../zelpers/rndIt.dart';

class Spiker {
  static Path makeSpikePath(Offset pointA, Offset pointB) {
    Function rndIt = RndIt.rndIt;
    Path path = Path();
    path.moveTo(pointA.dx, pointA.dy);
    Offset tip = Offset.zero;

    if (pointA.dx - pointB.dx > 0) {
      if (pointA.dy - pointB.dy > 0) {
        // upper right
        tip = Offset(pointA.dx + rndIt(45, 15),
            pointB.dy - (pointB.dy - pointA.dy) - rndIt(45, 15));
        path.quadraticBezierTo(
            tip.dx - rndIt(15, 3), tip.dy - rndIt(18, 3), tip.dx, tip.dy);
        path.quadraticBezierTo(
            tip.dx - rndIt(15, 3), tip.dy - rndIt(18, 3), pointB.dx, pointB.dy);
      } else {
        // upper left
        tip = Offset(pointA.dx - rndIt(75, 40),
            pointA.dy + (pointB.dy - pointA.dy) - rndIt(45, 20));
        path.quadraticBezierTo(
            tip.dx + rndIt(25, 13), tip.dy - rndIt(25, 3), tip.dx, tip.dy);
        path.quadraticBezierTo(tip.dx + rndIt(15, 13), tip.dy - rndIt(25, 13),
            pointB.dx, pointB.dy);
      }
    } else {
      if (pointA.dy - pointB.dy > 0) {
        // lower right
        tip = Offset(pointA.dx + rndIt(45, 5),
            pointB.dy - (pointB.dy - pointA.dy) + rndIt(45, 5));
        path.quadraticBezierTo(
            tip.dx + rndIt(18, 3), tip.dy - rndIt(18, 3), tip.dx, tip.dy);
        path.quadraticBezierTo(
            tip.dx + rndIt(18, 3), tip.dy - rndIt(18, 3), pointB.dx, pointB.dy);
      } else {
        // lower left
        tip = Offset(pointA.dx - rndIt(45, 5),
            pointB.dy - (pointB.dy - pointA.dy) + rndIt(45, 15));
        path.quadraticBezierTo(
            tip.dx + rndIt(15, 3), tip.dy - rndIt(20, 3), tip.dx, tip.dy);
        path.quadraticBezierTo(
            tip.dx + rndIt(15, 3), tip.dy - rndIt(20, 3), pointB.dx, pointB.dy);
      }
    }
    return path;
  }

  static void paintSpikesTotal({
    required Path path,
    required Canvas canvas,
  }) {
    PathMetric pathMetric = path.computeMetrics().toList().first;
    Rect pathBounds = path.getBounds();

    Offset top = pathMetric.getTangentForOffset(0)!.position;
    for (var i = 0; i < 10; i++) {
      Path ring = Path();

      ring.addOval(Rect.fromCircle(
        center: Offset(top.dx, top.dy + (i * 3)),
        radius: 19.0 * i,
      ));
      var ringMetric = ring.computeMetrics().toList();

      if (ringMetric.isEmpty) continue;

      PathMetric metric = ringMetric.first;
      double len = metric.length * .5;
      Path section = metric.extractPath(0, len);

      PathMetric m = section.computeMetrics().first;

      for (var i = 0; i < 15; i++) {
        Offset loc = m.getTangentForOffset(30.0 * i)!.position;
        if (path.contains(loc)) {
          paintSpike(
              canvas: canvas,
              pointA: Offset(loc.dx, loc.dy),
              pointB: Offset(loc.dx + 25, loc.dy + 20),
              fillColor: greenDark,
              strokeColor: greenLight,
              length: 30,
              width: 20,
              strokeWidth: 1.5,
              angle: 0,
              isShadow: false);
        }
      }
    }

    canvas.drawRect(pathBounds, Paint()..style = PaintingStyle.stroke);
  }

  static void paintSpike({
    required Canvas canvas,
    required Offset pointA,
    required Offset pointB,
    required Color fillColor,
    required Color strokeColor,
    required double length,
    required double width,
    required double strokeWidth,
    required double angle,
    required bool isShadow,
  }) {
    Path spikePath = makeSpikePath(pointA, pointB);

    canvas.drawPath(spikePath, Paint()..color = fillColor);
    canvas.drawPath(
        spikePath,
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth);
  }

  static void paintSpikes(
      {required Path path,
      required Canvas canvas,
      required int numberOfSpikes,
      bool isShadow = false,
      bool reverse = false}) {
    Function rndIt = RndIt.rndIt;
    PathMetric pathMetric = path.computeMetrics().toList().first;

    final int numPointsMidPath = pathMetric.length ~/ numberOfSpikes;

    for (var i = 0; i < numPointsMidPath; i++) {
      final double dist = i / numPointsMidPath;

      Offset pointA = Offset.zero;
      Offset pointB = Offset.zero;
      if (reverse) {
        pointA =
            pathMetric.getTangentForOffset(pathMetric.length * dist)!.position;
        pointB = pathMetric
            .getTangentForOffset((pathMetric.length * dist) - rndIt(25, 5))!
            .position;
      } else {
        pointA =
            pathMetric.getTangentForOffset(pathMetric.length * dist)!.position;
        pointB = pathMetric
            .getTangentForOffset((pathMetric.length * dist) + rndIt(25, 5))!
            .position;
      }
      Path spikePath = makeSpikePath(pointA, pointB);
      if (isShadow) {
        canvas.drawPath(spikePath, Paint()..color = Colors.black26);
      } else {
        canvas.drawPath(spikePath, Paint()..color = greenDark);
        canvas.drawPath(
            spikePath,
            Paint()
              ..color = greenLight
              ..style = PaintingStyle.stroke
              ..strokeWidth = rndIt(2, 0));
      }
    }
  }
}
