import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

import 'package:provider/provider.dart';
import 'package:sprung/sprung.dart';

import '../../../../state/progress.state.dart';
import '../../../models/progress.model.dart';
import '../../../state/puzzle.state.dart';
import '../../../zelpers/gi.dart';

class LightStage extends StatefulWidget {
  const LightStage({Key? key}) : super(key: key);

  @override
  _LightStageState createState() => _LightStageState();
}

class _LightStageState extends State<LightStage>
    with SingleTickerProviderStateMixin {
  late AnimationController lightController;
  late SequenceAnimation lightSequenceAnimation;

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    lightController = AnimationController(vsync: this);
  }

  Future<bool> setLightSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        lightSequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  Alignment _currentAlignment = Alignment.center;

  List<ProgressLightModel> progressSteps = [];

  Future<void> _processLightAnimation(int progressStep) async {
    if (_currentStep != progressStep || _currentStep == 0) {
      int numOfSteps = gi<PuzzleState>().puzzle.tilesNum + 1;
      // double width = gi<HomeState>().screenSize.width;
      if (progressSteps.isEmpty) {
        for (var i = 0; i < numOfSteps; i++) {
          double x = (i / numOfSteps) - ((numOfSteps / 2) / numOfSteps);

          x = x * 2;
          double y = (i / numOfSteps) - ((numOfSteps / 2) / numOfSteps);

          y = -cos(y - .5);

          progressSteps.add(ProgressLightModel(
              alignmentNew: Alignment(x, y),
              curve: Sprung(),
              duration: const Duration(milliseconds: 1500),
              tag: 'light'));
        }
      }
      lightController.reset();
      await setLightSA(SequenceAnimationBuilder()
          .addAnimatable(
              animatable: AlignmentTween(
                  begin: _currentAlignment,
                  end: progressSteps[progressStep].alignmentNew),
              from: const Duration(),
              to: progressSteps[progressStep].duration,
              tag: progressSteps[progressStep].tag,
              curve: progressSteps[progressStep].curve)
          .animate(lightController));
      lightController.forward();

      _currentStep = progressStep;
      _currentAlignment = progressSteps[progressStep].alignmentNew;
    }
  }

  @override
  void dispose() {
    lightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressState _progressState = Provider.of<ProgressState>(context);

    _processLightAnimation(_progressState.progressStep);

    return AnimatedBuilder(
        animation: lightController,
        builder: (context, child) {
          _progressState
              .setLightAlignment(lightSequenceAnimation['light'].value);
          return const SizedBox.shrink();
        });
  }
}
