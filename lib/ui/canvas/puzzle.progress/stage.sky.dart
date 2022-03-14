import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:guanabana/zelpers/app.colors.dart';

import 'package:provider/provider.dart';

import '../../../../models/progress.model.dart';
import '../../../../state/progress.state.dart';
import '../../../../state/puzzle.state.dart';
import '../../../../zelpers/gi.dart';

class SkyStage extends StatefulWidget {
  const SkyStage({Key? key}) : super(key: key);

  @override
  _SkyStageState createState() => _SkyStageState();
}

class _SkyStageState extends State<SkyStage>
    with SingleTickerProviderStateMixin {
  late AnimationController colorController;
  late SequenceAnimation colorSequenceAnimation;

  int _currentStep = 0;
  List<ProgressSkyModel> progressSteps = [];
  @override
  void initState() {
    super.initState();
    colorController = AnimationController(vsync: this);
    _setProgressSteps();
  }

  void _setProgressSteps() {
    if (progressSteps.isEmpty) {
      int numOfSteps = gi<PuzzleState>().puzzle.tilesNum + 1;
      late Color _cA;
      late Color _cB;
      for (var i = 0; i < numOfSteps; i++) {
        // CanvasGradient
        switch (i) {
          case 0:
            _cA = Colors.black;
            _cB = Colors.black;
            break;
          case 1:
            _cA = Colors.red[900]!.withOpacity(.6);
            _cB = Colors.black;
            break;
          case 2:
            _cA = Colors.orange[600]!;
            _cB = Colors.red[800]!.withOpacity(.6);
            break;
          case 3:
            _cA = yellow.withOpacity(.6);
            _cB = Colors.red[600]!.withOpacity(.8);
            break;
          case 4:
            _cA = trueBlue;
            _cB = blue;
            break;
          case 5:
            _cA = trueBlue;
            _cB = blue;
            break;
          case 6:
            _cA = trueBlue;
            _cB = blue;
            break;
          case 7:
            _cA = trueBlue;
            _cB = blue;
            break;
          case 8:
            _cA = trueBlue;
            _cB = blue;
            break;
          case 9:
            _cA = trueBlue;
            _cB = blue;
            break;
          case 10:
            _cA = trueBlue;
            _cB = blue;
            break;
          case 11:
            _cA = trueBlue;
            _cB = blue;
            break;
          case 12:
            _cA = trueBlue;
            _cB = blue;
            break;
          case 13:
            _cA = trueBlue;
            _cB = blue;
            break;
          case 14:
            _cA = trueBlue;
            _cB = blue;
            break;
          case 15:
            _cA = trueBlue;
            _cB = blue;
            break;

          default:
            _cA = trueBlue;
            _cB = blue;
        }

        progressSteps.add(
          ProgressSkyModel(
            colorNewA: _cA,
            colorNewB: _cB,
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            tag: 'color',
          ),
        );
      }
    }
  }

  Future<bool> setColorSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        colorSequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  Color _currentColorA = Colors.black;
  Color _currentColorB = Colors.black;

  Future<void> _processColorAnimation(int progressStep) async {
    if ((_currentStep != progressStep || _currentStep == 0)) {
      colorController.reset();
      await setColorSA(SequenceAnimationBuilder()
          .addAnimatable(
              animatable: ColorTween(
                  begin: _currentColorA,
                  end: progressSteps[progressStep].colorNewA),
              from: const Duration(),
              to: progressSteps[progressStep].duration,
              tag: 'colorA',
              curve: progressSteps[progressStep].curve)
          .addAnimatable(
              animatable: ColorTween(
                  begin: _currentColorB,
                  end: progressSteps[progressStep].colorNewB),
              from: const Duration(),
              to: progressSteps[progressStep].duration,
              tag: 'colorB',
              curve: progressSteps[progressStep].curve)
          .animate(colorController));
      colorController.forward();

      _currentStep = progressStep;
      _currentColorA = progressSteps[progressStep].colorNewA;
      _currentColorB = progressSteps[progressStep].colorNewB;
    }
  }

  @override
  void dispose() {
    colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressState _progressState = Provider.of<ProgressState>(context);

    _processColorAnimation(_progressState.progressStep);
    return AnimatedBuilder(
        animation: colorController,
        builder: (context, child) {
          return CustomPaint(
            painter: SkyStagePainter(
              colorSequenceAnimation['colorA'].value,
              colorSequenceAnimation['colorB'].value,
            ),
            child: Container(),
          );
        });
  }
}

class SkyStagePainter extends CustomPainter {
  final Color colorA;
  final Color colorB;

  SkyStagePainter(
    this.colorA,
    this.colorB,
  );
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.addRect(Rect.largest);
    canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            // begin: gi<ProgressState>().lightAlignment,
            begin: gi<ProgressState>().lightAlignment,
            end: Alignment.bottomCenter,
            colors: [colorA, colorB],
          ).createShader(
            Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
          ));
  }

  @override
  bool shouldRepaint(covariant SkyStagePainter oldDelegate) {
    return oldDelegate.colorA != colorA || oldDelegate.colorB != colorB;
  }
}
