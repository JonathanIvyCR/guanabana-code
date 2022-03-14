import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:guanabana/state/home.state.dart';
import 'package:guanabana/zelpers/gi.dart';

import 'package:provider/provider.dart';
import 'package:sprung/sprung.dart';

import '../../../../state/progress.state.dart';

class StarStage extends StatefulWidget {
  const StarStage({Key? key}) : super(key: key);

  @override
  _StarStageState createState() => _StarStageState();
}

class _StarStageState extends State<StarStage>
    with SingleTickerProviderStateMixin {
  late AnimationController rotationController;
  late SequenceAnimation rotationSequenceAnimation;

  int _currentStep = 0;
  double _currentRotation = 30;
  double _newRotation = 30;
  final List<Offset> _starLocs = [];

  void _setStars() async {
    await Future.delayed(const Duration(milliseconds: 50));
    for (var i = 0; i < 50; i++) {
      _starLocs.add(Offset(
          gi<HomeState>().screenSize.width * Random().nextDouble(),
          gi<HomeState>().screenSize.height * Random().nextDouble()));
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(vsync: this);
    _setStars();
  }

  Future<bool> setRotationSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        rotationSequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  double _currentOpacity = 1;
  double _newOpacity = 1;

  Future<void> _processRotationAnimation(int progressStep) async {
    if ((_currentStep != progressStep || _currentStep == 0)) {
      switch (progressStep) {
        case 0:
          if (_currentOpacity == 0) {
            _newOpacity = 1;
          }
          if (_currentRotation != -45) {
            _newRotation = -45;
          }
          break;
        case 1:
          if (_currentOpacity == 0) {
            _newOpacity = 1;
          }
          if (_currentRotation != -30) {
            _newRotation = -30;
          }
          break;
        case 2:
          if (_currentOpacity == 0) {
            _newOpacity = 1;
          }
          if (_currentRotation != -15) {
            _newRotation = -15;
          }
          break;
        case 3:
          if (_currentOpacity == 0) {
            _newOpacity = 1;
          }
          if (_currentRotation != 0) {
            _newRotation = 0;
          }
          break;
        case 4:
          if (_currentOpacity == 0) {
            _newOpacity = 1;
          }
          if (_currentRotation != 60) {
            _newRotation = 60;
          }
          break;
        case 13:
          if (_currentRotation != -160) {
            _newRotation = -160;
          }
          break;
        case 14:
          if (_currentOpacity == 0) {
            _newOpacity = 1;
          }
          if (_currentRotation != -90) {
            _newRotation = -90;
          }
          break;
        case 15:
          if (_currentOpacity == 0) {
            _newOpacity = 1;
          }
          if (_currentRotation != -60) {
            _newRotation = -70;
          }
          break;
        default:
          if (_currentOpacity == 1) {
            _newOpacity = 0;
          }
          if (_currentRotation != -160) {
            _currentRotation = -160;
            _newRotation = -160;
          }
      }

      rotationController.reset();
      await setRotationSA(SequenceAnimationBuilder()
          .addAnimatable(
            animatable:
                Tween<double>(begin: _currentRotation, end: _newRotation),
            from: const Duration(),
            to: const Duration(milliseconds: 1300),
            tag: 'star',
            curve: Sprung(),
          )
          .addAnimatable(
            animatable:
                Tween<double>(begin: _currentRotation, end: _newRotation),
            from: const Duration(),
            to: const Duration(milliseconds: 1500),
            tag: 'moon',
            curve: Sprung(),
          )
          .addAnimatable(
            animatable: Tween<double>(begin: _currentOpacity, end: _newOpacity),
            from: const Duration(),
            to: const Duration(milliseconds: 1500),
            tag: 'opacity',
            curve: Curves.easeInOut,
          )
          .animate(rotationController));
      rotationController.forward();

      _currentStep = progressStep;
      _currentRotation = _newRotation;
      _currentOpacity = _newOpacity;
    }
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressState _progressState = Provider.of<ProgressState>(context);

    _processRotationAnimation(_progressState.progressStep);
    return AnimatedBuilder(
        animation: rotationController,
        builder: (context, child) {
          return Opacity(
            opacity: rotationSequenceAnimation['opacity'].value,
            child: CustomPaint(
              painter: StarStagePainter(rotationSequenceAnimation['star'].value,
                  rotationSequenceAnimation['moon'].value, _starLocs),
              child: Container(),
            ),
          );
        });
  }
}

class StarStagePainter extends CustomPainter {
  final double star;
  final double moon;
  List<Offset> starPoints;

  StarStagePainter(this.star, this.moon, this.starPoints);
  @override
  void paint(Canvas canvas, Size size) {
    // Path path = Path();

    canvas.save();

    canvas.translate(size.width * .5, size.height);
    canvas.rotate(star * (pi / 180));
    canvas.translate(-size.width * .5, -size.height);
    for (var i = 0; i < starPoints.length; i++) {
      Offset sp = starPoints[i];
      canvas.drawCircle(Offset(sp.dx, sp.dy), i.isEven ? 2 : 3,
          Paint()..color = Colors.white70);
    }

    canvas.restore();

    canvas.save();

    canvas.translate(size.width * .5, size.height);
    canvas.rotate(moon * (pi / 180));
    canvas.translate(-size.width * .5, -size.height);
    canvas.drawCircle(Offset(size.width * .8, size.height * .45), 30,
        Paint()..color = Colors.grey[300]!);
    canvas.drawCircle(Offset(size.width * .804, size.height * .45), 10,
        Paint()..color = Colors.grey);
    canvas.drawCircle(Offset(size.width * .795, size.height * .448), 10,
        Paint()..color = Colors.grey[600]!);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant StarStagePainter oldDelegate) {
    return starPoints.isNotEmpty || oldDelegate.star != star;
    // return oldDelegate.star != star || oldDelegate.starPoints != starPoints;
  }
}
