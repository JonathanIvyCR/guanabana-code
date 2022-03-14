import 'package:flutter/material.dart';
import 'package:guanabana/ui/canvas/puzzle.progress/wood.maker.dart';

import '../../../state/progress.state.dart';
import '../../../zelpers/gi.dart';

class StageBranch extends StatelessWidget {
  const StageBranch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StageBranchPainter(),
      child: Container(),
    );
  }
}

class StageBranchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) async {
    if (gi<ProgressState>().trunkSet) {
      await WoodMaker.makeBranch(canvas);
    }
    if (gi<ProgressState>().progressStep <= 3) {
      gi<ProgressState>().setFruitPath(Path());
    }
  }

  @override
  bool shouldRepaint(covariant StageBranchPainter oldDelegate) {
    return false;
  }
}
