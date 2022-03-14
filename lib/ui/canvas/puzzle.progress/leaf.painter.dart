import 'package:flutter/material.dart';

import '../../../models/leaf.model.dart';
import '../../../state/progress.state.dart';
import '../../../zelpers/app.colors.dart';
import '../../../zelpers/gi.dart';
import '../../../zelpers/rndIt.dart';

class LeafPainter extends CustomPainter {
  LeafPainter(this.leaf, this.scale);
  final LeafModel leaf;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    Function rndIt = RndIt.rndIt;
    Path stemPath = Path();
    Path leafPath = Path();
    Path veinPath = Path();
    stemPath.moveTo(leaf.stemBase.dx, leaf.stemBase.dy);
    if (leaf.isFront) {
      // front leaves
      stemPath.quadraticBezierTo(
        leaf.stemBase.dx + rndIt(10 + (10 * leaf.randos[4]), 0),
        leaf.stemBase.dy + rndIt(10 + (10 * leaf.randos[2]), 0),
        leaf.leafBase.dx,
        leaf.leafBase.dy,
      );

      leafPath.moveTo(leaf.leafBase.dx, leaf.leafBase.dy);
      leafPath.quadraticBezierTo(
          leaf.leafBase.dx + rndIt(100, 0) + (10 * leaf.randos[0]),
          leaf.leafBase.dy + rndIt(2, 0) + (10 * leaf.randos[1]),
          leaf.leafBase.dx + rndIt(150, 0) + (10 * leaf.randos[2]),
          leaf.leafBase.dy + rndIt(85, 0) + (10 * leaf.randos[3]));

      leafPath.quadraticBezierTo(
        leaf.leafBase.dx + rndIt(230, 0) + (10 * leaf.randos[4]),
        leaf.leafBase.dy + rndIt(200, 0) + (10 * leaf.randos[5]),
        leaf.leafTip.dx,
        leaf.leafTip.dy,
      );

      leafPath.quadraticBezierTo(
          leaf.leafBase.dx + rndIt(111, 0) + (10 * leaf.randos[3]),
          leaf.leafBase.dy + rndIt(285, 0) + (10 * leaf.randos[8]),
          leaf.leafBase.dx + rndIt(70, 0) + (10 * leaf.randos[7]),
          leaf.leafBase.dy + rndIt(188, 0) + (10 * leaf.randos[6]));

      leafPath.quadraticBezierTo(
        leaf.leafBase.dx - rndIt(50, 0) + (10 * leaf.randos[5]),
        leaf.leafBase.dy + rndIt(30, 0) + (10 * leaf.randos[4]),
        leaf.leafBase.dx,
        leaf.leafBase.dy,
      );

      veinPath.moveTo(leaf.leafBase.dx, leaf.leafBase.dy);
      veinPath.quadraticBezierTo(
          leaf.leafBase.dx + rndIt(100 + (20 * leaf.randos[7]), 0),
          leaf.leafBase.dy + rndIt(80 + (20 * leaf.randos[3]), 0),
          leaf.leafTip.dx,
          leaf.leafTip.dy);
    } else {
      // behind leaves
      stemPath.quadraticBezierTo(
          leaf.stemBase.dx + rndIt(10 + (10 * leaf.randos[0]), 0),
          leaf.stemBase.dy - rndIt(10 + (10 * leaf.randos[1]), 0),
          leaf.leafBase.dx,
          leaf.leafBase.dy);

      leafPath.moveTo(leaf.leafBase.dx, leaf.leafBase.dy);
      leafPath.quadraticBezierTo(
          leaf.leafBase.dx + rndIt(100 + (10 * leaf.randos[2]), 0),
          leaf.leafBase.dy + rndIt(25 + (10 * leaf.randos[3]), 0),
          leaf.leafBase.dx + rndIt(180 + (10 * leaf.randos[4]), 0),
          leaf.leafBase.dy - rndIt(25 + (10 * leaf.randos[5]), 0));

      leafPath.quadraticBezierTo(
        leaf.leafBase.dx + rndIt(300 + (10 * leaf.randos[6]), 0),
        leaf.leafBase.dy - rndIt(50 + (10 * leaf.randos[7]), 0),
        leaf.leafTip.dx,
        leaf.leafTip.dy,
      );

      leafPath.quadraticBezierTo(
          leaf.leafBase.dx + rndIt(250 + (10 * leaf.randos[8]), 0),
          leaf.leafBase.dy - rndIt(200 + (10 * leaf.randos[0]), 0),
          leaf.leafBase.dx + rndIt(130 + (10 * leaf.randos[1]), 0),
          leaf.leafBase.dy - rndIt(150 + (10 * leaf.randos[2]), 0));

      leafPath.quadraticBezierTo(
        leaf.leafBase.dx - rndIt(100 + (20 * leaf.randos[3]), 0),
        leaf.leafBase.dy - rndIt(30 + (20 * leaf.randos[4]), 0),
        leaf.leafBase.dx,
        leaf.leafBase.dy,
      );

      veinPath.moveTo(leaf.leafBase.dx, leaf.leafBase.dy);
      veinPath.quadraticBezierTo(
          leaf.leafBase.dx + rndIt(100 + (40 * leaf.randos[5]), 0),
          leaf.leafBase.dy - rndIt(80 + (40 * leaf.randos[6]), 0),
          leaf.leafTip.dx,
          leaf.leafTip.dy);
    }

    Rect leafBounds = leafPath.getBounds();
    canvas.save();
    canvas.translate(leaf.stemBase.dx, leaf.stemBase.dy);
    final Matrix4 scaleY0p2 = Matrix4.identity()
      ..setEntry(3, 2, 0)
      ..scale(scale, scale);
    // ..scale(1.0, 1.0);

    canvas.transform(scaleY0p2.storage);
    canvas.translate(-leaf.stemBase.dx, -leaf.stemBase.dy);
    canvas.drawPath(
        stemPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = rndIt(6, 0)
          ..strokeCap = StrokeCap.round
          ..color = Colors.brown[800]!);
    canvas.drawShadow(leafPath, Colors.black, 7, false);
    canvas.drawPath(
        leafPath,
        Paint()
          ..style = PaintingStyle.fill
          ..isAntiAlias = true
          ..shader = RadialGradient(
              focal: gi<ProgressState>().lightAlignment,
              focalRadius: .17,
              center: gi<ProgressState>().lightAlignment,
              colors: const [greenLight, greenDark]).createShader(
            Rect.fromPoints(leafBounds.topLeft, leafBounds.bottomRight),
          ));
    canvas.drawShadow(veinPath, Colors.white10, 7, true);
    canvas.drawPath(
      veinPath,
      Paint()
        ..color = greenLight
        ..style = PaintingStyle.stroke,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LeafPainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}
