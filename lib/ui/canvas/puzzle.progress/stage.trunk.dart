import 'package:flutter/material.dart';

import 'wood.maker.dart';

class StageTrunk extends StatelessWidget {
  const StageTrunk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StageTrunkPainter(),
      child: Container(),
    );
  }
}

class StageTrunkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) async {
    await WoodMaker.makeTrunk(canvas);
  }

  @override
  bool shouldRepaint(covariant StageTrunkPainter oldDelegate) {
    return false;
  }
}
