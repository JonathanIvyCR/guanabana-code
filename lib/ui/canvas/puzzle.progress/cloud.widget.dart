import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:guanabana/models/cloud.model.dart';
import 'package:guanabana/zelpers/rndIt.dart';

import 'package:provider/provider.dart';

import '../../../../models/progress.model.dart';
import '../../../../state/progress.state.dart';
import '../../../../state/puzzle.state.dart';
import '../../../../zelpers/gi.dart';

class CloudWidget extends StatefulWidget {
  const CloudWidget({Key? key, required this.cloud}) : super(key: key);
  final CloudModel cloud;

  @override
  _CloudWidgetState createState() => _CloudWidgetState();
}

class _CloudWidgetState extends State<CloudWidget>
    with TickerProviderStateMixin {
  late AnimationController colorController;
  late SequenceAnimation colorSequenceAnimation;
  late AnimationController movementController;
  late SequenceAnimation movementSequenceAnimation;

  int _currentStep = 0;
  List<ProgressCloudModel> progressSteps = [];
  @override
  void initState() {
    super.initState();
    colorController = AnimationController(vsync: this);
    movementController = AnimationController(vsync: this);
    _processMovementAnimation();
  }

  Future<bool> setScaleSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        colorSequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  Future<bool> setMovementSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        movementSequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  Future<void> _processMovementAnimation() async {
    movementController.reset();
    int duration = 30 * (widget.cloud.id + 1);
    await setMovementSA(SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<Offset>(
            begin: widget.cloud.cloudLoc,
            end: widget.cloud.targetLoc,
          ),
          from: const Duration(),
          to: Duration(seconds: duration),
          tag: 'cloudPoint',
          curve: Curves.linear,
        )
        .animate(movementController));
    movementController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          widget.cloud.randos = RndIt.getRandos(widget.cloud.id);

          movementController.reset();
          movementController.forward();
          break;
        case AnimationStatus.dismissed:
          movementController.forward();
          break;
        default:
      }
    });
    await Future.delayed(Duration(seconds: 2 * (widget.cloud.id + 1)));
    movementController.forward();
  }

  Color _colorCurrentA = Colors.grey[400]!;
  Color _colorCurrentB = Colors.grey[600]!;

  Future<void> _processColorAnimation(int progressStep) async {
    if ((_currentStep != progressStep || _currentStep == 0)) {
      int numOfSteps = gi<PuzzleState>().puzzle.tilesNum + 1;

      if (progressSteps.isEmpty) {
        Color _colorNewA = Colors.grey[400]!;

        Color _colorNewB = Colors.grey[600]!;
        for (var i = 0; i < numOfSteps; i++) {
          // CanvasGradient
          switch (i) {
            case 0:
              // uses default
              break;
            case 1:
              _colorNewA = Colors.grey[400]!;
              _colorNewB = Colors.red[300]!;
              break;
            case 2:
              _colorNewA = Colors.red[300]!;
              _colorNewB = Colors.orange[200]!;
              break;
            case 3:
              _colorNewA = Colors.grey[300]!;
              _colorNewB = Colors.yellow[400]!;
              break;
            case 4:
              _colorNewA = Colors.grey[300]!;
              _colorNewB = Colors.yellow[200]!;
              break;
            case 5:
              _colorNewA = Colors.grey[500]!;
              _colorNewB = Colors.grey[100]!;
              break;
            default:
              _colorNewA = Colors.grey[600]!;
              _colorNewB = Colors.grey[100]!;
          }

          progressSteps.add(
            ProgressCloudModel(
              colorNewA: _colorNewA,
              colorNewB: _colorNewB,
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeInOut,
              tag: 'color',
            ),
          );
        }
      }
      colorController.reset();
      await setScaleSA(SequenceAnimationBuilder()
          .addAnimatable(
              animatable: ColorTween(
                  begin: _colorCurrentA,
                  end: progressSteps[progressStep].colorNewA),
              from: const Duration(),
              to: progressSteps[progressStep].duration,
              tag: 'colorA',
              curve: progressSteps[progressStep].curve)
          .addAnimatable(
              animatable: ColorTween(
                  begin: _colorCurrentB,
                  end: progressSteps[progressStep].colorNewB),
              from: const Duration(),
              to: progressSteps[progressStep].duration,
              tag: 'colorB',
              curve: progressSteps[progressStep].curve)
          .animate(colorController));
      colorController.forward();

      _currentStep = progressStep;
      _colorCurrentA = progressSteps[progressStep].colorNewA;
      _colorCurrentB = progressSteps[progressStep].colorNewB;
    }
  }

  @override
  void dispose() {
    colorController.dispose();
    movementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressState _progressState = Provider.of<ProgressState>(context);

    _processColorAnimation(_progressState.progressStep);

    return AnimatedBuilder(
        animation: colorController,
        builder: (context, child) {
          return AnimatedBuilder(
              animation: movementController,
              builder: (context, child) {
                return FittedBox(
                  child: SizedBox(
                    height: RndIt.rndIt(200, 0),
                    width: RndIt.rndIt(300, 0),
                    child: CustomPaint(
                      painter: CloudWidgetPainter(
                        colorSequenceAnimation['colorA'].value,
                        colorSequenceAnimation['colorB'].value,
                        movementSequenceAnimation['cloudPoint'].value,
                        widget.cloud,
                      ),
                      child: Container(),
                    ),
                  ),
                );
              });
        });
  }
}

class CloudWidgetPainter extends CustomPainter {
  final Color colorA;
  final Color colorB;
  final Offset cloudPoint;
  final CloudModel cloud;

  CloudWidgetPainter(
    this.colorA,
    this.colorB,
    this.cloudPoint,
    this.cloud,
  );
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    canvas.save();
    canvas.translate(cloudPoint.dx, cloudPoint.dy);
    canvas.scale(cloud.scale);

    path.moveTo(
      cloudPoint.dx + 75,
      cloudPoint.dy + 12,
    );
    path.quadraticBezierTo(
      cloudPoint.dx + 50 - RndIt.rndIt(50 * cloud.randos[1], 0),
      cloudPoint.dy + 12,
      cloudPoint.dx + 50,
      cloudPoint.dy + 50,
    );

    path.quadraticBezierTo(
      cloudPoint.dx + 10 + RndIt.rndIt(50 * cloud.randos[2], 0),
      cloudPoint.dy + 51 - RndIt.rndIt(50 * cloud.randos[3], 0),
      cloudPoint.dx + 10,
      cloudPoint.dy + 70,
    );

    path.quadraticBezierTo(
      cloudPoint.dx + 15 - RndIt.rndIt(50 * cloud.randos[7], 0),
      cloudPoint.dy + 100 + RndIt.rndIt(50 * cloud.randos[4], 0),
      cloudPoint.dx + 75,
      cloudPoint.dy + 100 - RndIt.rndIt(50 * cloud.randos[8], 0),
    );

    path.quadraticBezierTo(
      cloudPoint.dx + 140 + RndIt.rndIt(50 * cloud.randos[6], 0),
      cloudPoint.dy + 95 + RndIt.rndIt(50 * cloud.randos[1], 0),
      cloudPoint.dx + 145,
      cloudPoint.dy + 70,
    );

    path.quadraticBezierTo(
      cloudPoint.dx + 140 + RndIt.rndIt(50 * cloud.randos[4], 0),
      cloudPoint.dy + 35 + RndIt.rndIt(50 * cloud.randos[2], 0),
      cloudPoint.dx + 100,
      cloudPoint.dy + 50,
    );

    path.quadraticBezierTo(
      cloudPoint.dx + 110 + RndIt.rndIt(50 * cloud.randos[3], 0),
      cloudPoint.dy + 12 - RndIt.rndIt(50 * cloud.randos[5], 0),
      cloudPoint.dx + 75,
      cloudPoint.dy + 12,
    );

    canvas.translate(-cloudPoint.dx, -cloudPoint.dy);
    canvas.drawShadow(path, Colors.black54, 10, false);
    Rect cloudRect = path.getBounds();
    canvas.drawPath(
        path,
        Paint()
          ..shader = RadialGradient(
            focal: gi<ProgressState>().lightAlignment,
            focalRadius: 1,
            center: gi<ProgressState>().lightAlignment,
            colors: [colorA, colorB],
          ).createShader(
            Rect.fromPoints(cloudRect.topLeft, cloudRect.bottomRight),
          ));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CloudWidgetPainter oldDelegate) {
    return oldDelegate.cloudPoint != cloudPoint ||
        oldDelegate.colorA != colorA ||
        oldDelegate.colorB != colorB;
  }
}
