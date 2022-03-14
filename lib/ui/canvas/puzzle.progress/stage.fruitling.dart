import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:guanabana/zelpers/rndIt.dart';

import 'package:provider/provider.dart';
import 'package:sprung/sprung.dart';

import '../../../models/progress.model.dart';
import '../../../state/progress.state.dart';
import '../../../state/puzzle.state.dart';
import '../../../zelpers/gi.dart';
import 'guanabana.maker.dart';

class FruitlingStage extends StatefulWidget {
  const FruitlingStage({Key? key}) : super(key: key);

  @override
  _FruitlingStageState createState() => _FruitlingStageState();
}

class _FruitlingStageState extends State<FruitlingStage>
    with SingleTickerProviderStateMixin {
  late AnimationController scaleController;
  late SequenceAnimation scaleSequenceAnimation;

  int _currentStep = 0;
  List<ProgressFruitModel> progressSteps = [];
  @override
  void initState() {
    super.initState();
    scaleController = AnimationController(vsync: this);
    _randos = RndIt.getRandos(1);
  }

  Future<bool> setScaleSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        scaleSequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  Future<void> _processScaleAnimation(int progressStep) async {
    if (_currentStep != progressStep || _currentStep == 0) {
      int numOfSteps = gi<PuzzleState>().puzzle.tilesNum + 1;

      if (progressSteps.isEmpty) {
        for (var i = 0; i < numOfSteps; i++) {
          double _scale = i / numOfSteps;
          progressSteps.add(
            ProgressFruitModel(
              scale: _scale * 1.5,
              duration: const Duration(milliseconds: 1500),
              curve: Sprung(),
              tag: 'scaleController',
            ),
          );
        }
      }
      scaleController.reset();
      await setScaleSA(SequenceAnimationBuilder()
          .addAnimatable(
              animatable: Tween<double>(
                  begin: progressSteps[_currentStep].scale,
                  end: progressSteps[progressStep].scale),
              from: const Duration(),
              to: progressSteps[progressStep].duration,
              tag: progressSteps[progressStep].tag,
              curve: progressSteps[progressStep].curve)
          .animate(scaleController));
      scaleController.forward();

      _currentStep = progressStep;
      if (progressStep <= 5) {
        _randos = RndIt.getRandos(progressStep);
      }
    }
  }

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }

  List<double> _randos = [];

  @override
  Widget build(BuildContext context) {
    final ProgressState _progressState = Provider.of<ProgressState>(context);

    _processScaleAnimation(_progressState.progressStep);
    return AnimatedBuilder(
        animation: scaleController,
        builder: (context, child) {
          return CustomPaint(
            painter: FruitlingStagePainter(
              scaleSequenceAnimation['scaleController'].value,
              _randos,
            ),
            child: Container(),
          );
        });
  }
}

class FruitlingStagePainter extends CustomPainter {
  final double scale;
  final List<double> randos;

  FruitlingStagePainter(this.scale, this.randos);
  @override
  void paint(Canvas canvas, Size size) {
    Path fruitlingPath = GuanabanaMaker.makeFruit(canvas, scale, randos);

    gi<ProgressState>().setFruitPath(fruitlingPath);
  }

  @override
  bool shouldRepaint(covariant FruitlingStagePainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}
