import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:guanabana/state/home.state.dart';
import 'package:guanabana/zelpers/app.colors.dart';
import 'package:guanabana/zelpers/rndIt.dart';

import 'package:provider/provider.dart';

import '../../../../models/progress.model.dart';
import '../../../../state/progress.state.dart';
import '../../../../state/puzzle.state.dart';
import '../../../../zelpers/gi.dart';

class HillsStage extends StatefulWidget {
  const HillsStage({Key? key}) : super(key: key);

  @override
  _HillsStageState createState() => _HillsStageState();
}

class _HillsStageState extends State<HillsStage>
    with SingleTickerProviderStateMixin {
  late AnimationController colorController;
  late SequenceAnimation colorSequenceAnimation;

  int _currentStep = 0;
  List<ProgressSkyModel> progressSteps = [];
  final List<Offset> _grassLocs = [];
  @override
  void initState() {
    super.initState();
    colorController = AnimationController(vsync: this);

    _fillGrass();
  }

  Future<void> _fillGrass() async {
    await Future.delayed(const Duration(milliseconds: 150));
    Size screenSize = gi<HomeState>().screenSize;
    for (var i = 0; i < 50; i++) {
      _grassLocs.add(Offset(
          screenSize.width * Random().nextDouble(),
          screenSize.height * .65 +
              (screenSize.height * .35 * Random().nextDouble())));
    }
  }

  Future<bool> setScaleSA(SequenceAnimation value) async {
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
      int numOfSteps = gi<PuzzleState>().puzzle.tilesNum + 1;

      if (progressSteps.isEmpty) {
        // Color _colorNewA = const Color.fromARGB(255, 31, 14, 104);

        // Color _colorNewB = const Color.fromARGB(255, 84, 63, 176);
        Color _colorNewA = Colors.grey[900]!;

        Color _colorNewB = Colors.blueGrey[900]!;
        for (var i = 0; i < numOfSteps; i++) {
          switch (i) {
            case 1:
              _colorNewA = Colors.red[900]!;
              break;
            default:
              _colorNewA = greenLight;
              _colorNewB = greenDark;
          }

          progressSteps.add(
            ProgressSkyModel(
              colorNewA: _colorNewA,
              colorNewB: _colorNewB,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.linear,
              tag: 'color',
            ),
          );
        }
      }
      colorController.reset();
      await setScaleSA(SequenceAnimationBuilder()
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
            painter: HillsStagePainter(colorSequenceAnimation['colorA'].value,
                colorSequenceAnimation['colorB'].value, _grassLocs),
            child: Container(),
          );
        });
  }
}

class HillsStagePainter extends CustomPainter {
  final Color colorA;
  final Color colorB;
  final List<Offset> grassLocs;

  HillsStagePainter(
    this.colorA,
    this.colorB,
    this.grassLocs,
  );
  @override
  void paint(Canvas canvas, Size size) {
    Path hillBack = Path();
    hillBack.moveTo(0, size.height * .9);
    hillBack.quadraticBezierTo(
        size.width * .6, size.height * .5, size.width, size.height * .7);
    hillBack.lineTo(size.width, size.height);
    hillBack.lineTo(0, size.height);
    hillBack.close();

    Rect hillBackBounds = hillBack.getBounds();
    Path hillFront = Path();
    hillFront.moveTo(0, size.height * .8);
    hillFront.quadraticBezierTo(
        size.width * .4, size.height * .6, size.width, size.height);
    hillFront.lineTo(0, size.height);
    hillFront.close();
    Rect hillFrontBounds = hillFront.getBounds();
    canvas.drawShadow(hillBack, Colors.black54, 40, false);
    canvas.drawPath(
        hillBack,
        Paint()
          ..isAntiAlias = true
          ..shader = LinearGradient(
            // begin: gi<ProgressState>().lightAlignment,
            begin: gi<ProgressState>().lightAlignment,
            end: Alignment.bottomCenter,
            colors: [colorA, colorB],
          ).createShader(
            Rect.fromPoints(hillBackBounds.topLeft, hillBackBounds.bottomRight),
          ));

    canvas.drawShadow(hillFront, Colors.black, 60, false);
    canvas.drawPath(
        hillFront,
        Paint()
          ..isAntiAlias = true
          ..shader = LinearGradient(
            // begin: gi<ProgressState>().lightAlignment,
            begin: gi<ProgressState>().lightAlignment,
            end: Alignment.bottomCenter,
            colors: [colorA, colorB],
          ).createShader(
            Rect.fromPoints(
                hillFrontBounds.topLeft, hillFrontBounds.bottomRight),
          ));

    for (var i = 0; i < grassLocs.length; i++) {
      final Offset o = grassLocs[i];
      Path grassPath = Path();
      grassPath.moveTo(o.dx, o.dy);
      if (hillFront.contains(o)) {
        grassPath.quadraticBezierTo(
            o.dx - RndIt.rndIt(3, 0),
            o.dy - RndIt.rndIt(3, 0),
            o.dx + RndIt.rndIt(5, 0),
            o.dy - RndIt.rndIt(22, 0));

        grassPath.moveTo(o.dx + RndIt.rndIt(8, 0), o.dy);
        grassPath.relativeQuadraticBezierTo(
          RndIt.rndIt(5, 0),
          i.isEven ? RndIt.rndIt(10, 0) : -RndIt.rndIt(10, 0),
          RndIt.rndIt(1, 0),
          -RndIt.rndIt(20, 0),
        );
        grassPath.moveTo(o.dx - RndIt.rndIt(8, 0), o.dy);
        grassPath.relativeQuadraticBezierTo(
          i.isEven ? RndIt.rndIt(10, 0) : -RndIt.rndIt(5, 0),
          i.isOdd ? -RndIt.rndIt(6, 0) : RndIt.rndIt(10, 0),
          -RndIt.rndIt(1, 0),
          -RndIt.rndIt(20, 0),
        );
        Rect grassBounds = grassPath.getBounds();
        canvas.drawPath(
            grassPath,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = RndIt.rndIt(9, 0)
              ..strokeCap = StrokeCap.round
              ..shader = RadialGradient(
                focal: gi<ProgressState>().lightAlignment,
                focalRadius: 1.5,
                center: gi<ProgressState>().lightAlignment,
                colors: [colorB, colorA],
              ).createShader(
                Rect.fromPoints(grassBounds.topLeft, grassBounds.bottomRight),
              ));
      } else if (hillBack.contains(o)) {
        grassPath.quadraticBezierTo(
            o.dx - RndIt.rndIt(3, 0),
            o.dy - RndIt.rndIt(3, 0),
            o.dx + RndIt.rndIt(5, 0),
            o.dy - RndIt.rndIt(11, 0));

        grassPath.moveTo(o.dx + RndIt.rndIt(3, 0), o.dy);
        grassPath.relativeQuadraticBezierTo(
          RndIt.rndIt(3, 0),
          i.isEven ? RndIt.rndIt(6, 0) : RndIt.rndIt(-5, 0),
          i.isOdd ? RndIt.rndIt(6, 0) : -RndIt.rndIt(6, 0),
          i.isOdd ? RndIt.rndIt(6, 0) : -RndIt.rndIt(11, 0),
        );
        grassPath.moveTo(o.dx - RndIt.rndIt(3, 0), o.dy);
        grassPath.relativeQuadraticBezierTo(
          i.isEven ? RndIt.rndIt(5, 0) : -RndIt.rndIt(3, 0),
          RndIt.rndIt(5, 0),
          -RndIt.rndIt(1, 0),
          -RndIt.rndIt(11, 0),
        );

        Rect grassBounds = grassPath.getBounds();
        canvas.drawPath(
            grassPath,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = RndIt.rndIt(3, 0)
              ..strokeCap = StrokeCap.round
              ..shader = RadialGradient(
                focal: gi<ProgressState>().lightAlignment,
                focalRadius: 1,
                center: gi<ProgressState>().lightAlignment,
                colors: [colorA, colorB],
              ).createShader(
                Rect.fromPoints(grassBounds.topLeft, grassBounds.bottomRight),
              ));
      }
    }
  }

  @override
  bool shouldRepaint(covariant HillsStagePainter oldDelegate) {
    return oldDelegate.colorA != colorA || oldDelegate.colorB != colorB;
  }
}
