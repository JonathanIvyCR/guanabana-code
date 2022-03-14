import 'package:flutter/material.dart';

import '../../../models/leaf.model.dart';
import 'leaf.painter.dart';

class LeafWidget extends StatelessWidget {
  const LeafWidget(
      {Key? key, required this.leaf, required this.scale, required this.fallY})
      : super(key: key);
  final LeafModel leaf;
  final double scale;
  final double fallY;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, fallY),
      child: CustomPaint(
        painter: LeafPainter(leaf, scale),
        child: Container(),
      ),
    );
  }
}
