import 'package:flutter/material.dart';

import '../../../models/leaf.model.dart';
import '../../../state/progress.state.dart';
import '../../../zelpers/gi.dart';
import '../../../zelpers/rndIt.dart';

class LeafMaker {
  static void makeLeavesNew() {
    Function rndIt = RndIt.rndIt;
    //
    final ProgressState _ps = gi<ProgressState>();

    final int numLeaves = _ps.branchPathMetric.length ~/ rndIt(300, 0);

    final int halfLeaves = numLeaves ~/ 2;

    for (var i = 0; i < numLeaves; i++) {
      Offset stemBase = Offset.zero;
      Offset leafBase = Offset.zero;
      Offset leafTip = Offset.zero;
      if (i > halfLeaves) {
        // front leaves
        stemBase = _ps.branchPathMetric
            .getTangentForOffset(
                (_ps.branchPathMetric.length / numLeaves) * i + rndIt(55, 0))!
            .position;

        leafBase =
            Offset(stemBase.dx + rndIt(10, 0), stemBase.dy + rndIt(10, 0));
        leafTip =
            Offset(leafBase.dx + rndIt(200, 0), leafBase.dy + rndIt(300, 0));
        if (i != numLeaves - 1) {
          _ps.leavesBehind.add(
            LeafModel(
              id: i,
              stemBase: stemBase,
              leafBase: leafBase,
              leafTip: leafTip,
              isFront: true,
              randos: RndIt.getRandos(i),
            ),
          );
        }
      } else if (i < halfLeaves) {
        // behind leaves
        stemBase = _ps.branchPathMetric
            .getTangentForOffset(
                (_ps.branchPathMetric.length / numLeaves) * i + rndIt(165, 0))!
            .position;

        leafBase =
            Offset(stemBase.dx + rndIt(10, 0), stemBase.dy - rndIt(10, 0));
        leafTip =
            Offset(leafBase.dx + rndIt(350, 0), leafBase.dy - rndIt(150, 0));
        if (i != 0) {
          _ps.leavesFront.add(
            LeafModel(
              id: i,
              stemBase: stemBase,
              leafBase: leafBase,
              leafTip: leafTip,
              isFront: false,
              randos: RndIt.getRandos(i),
            ),
          );
        }
      }
    }
  }
}
