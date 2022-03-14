import 'package:flutter/material.dart';
import 'package:guanabana/state/progress.state.dart';
import 'package:guanabana/ui/canvas/puzzle.progress/cloud.stack.dart';
import 'package:guanabana/ui/canvas/puzzle.progress/leaf.stack.dart';
import 'package:guanabana/ui/canvas/puzzle.progress/stage.light.dart';
import 'package:guanabana/ui/canvas/puzzle.progress/stage.branch.dart';
import 'package:guanabana/ui/canvas/puzzle.progress/stage.fruitling.dart';
import 'package:guanabana/ui/canvas/puzzle.progress/stage.hills.dart';
import 'package:guanabana/ui/canvas/puzzle.progress/stage.stars.dart';
import 'package:guanabana/ui/canvas/puzzle.progress/stage.trunk.dart';

import 'package:provider/provider.dart';

import 'stage.sky.dart';
import 'stage.flower.dart';

class PuzzleProgressIndicator extends StatelessWidget {
  const PuzzleProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProgressState _progressState = Provider.of<ProgressState>(context);

    return Stack(
      children: [
        const LightStage(),
        const SkyStage(),
        const StarStage(),
        const CloudStack(),
        const HillsStage(),
        const StageTrunk(),
        if (_progressState.branchSet)
          const LeafStack(
            isFront: true,
          ),
        if (_progressState.trunkSet) const StageBranch(),
        if (_progressState.branchSet)
          Stack(
            children: [
              const LeafStack(
                isFront: false,
              ),
              if (_progressState.progressStep >= 6 &&
                  _progressState.progressStep <= 15)
                const FruitlingStage(),
              if (_progressState.progressStep >= 4 &&
                  _progressState.progressStep <= 6)
                const FlowerStage(),
            ],
          ),
      ],
    );
  }
}
