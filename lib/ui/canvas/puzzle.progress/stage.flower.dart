import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:guanabana/zelpers/app.colors.dart';
import 'package:provider/provider.dart';
import 'package:sprung/sprung.dart';

import '../../../state/home.state.dart';
import '../../../state/progress.state.dart';
import '../../../zelpers/gi.dart';
import 'guanabana.maker.dart';

class FlowerStage extends StatefulWidget {
  const FlowerStage({Key? key}) : super(key: key);

  @override
  _FlowerStageState createState() => _FlowerStageState();
}

class _FlowerStageState extends State<FlowerStage>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late SequenceAnimation sequenceAnimation;
  late AnimationController petalController;
  late SequenceAnimation petalSequenceAnimation;

  Future<bool> setPetalSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        petalSequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    petalController = AnimationController(vsync: this);
  }

  Future<bool> setSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        sequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  int _currentStep = 0;

  Future<void> _processPetalAnimation(int progressStep) async {
    if (_currentStep != progressStep) {
      if (progressStep == 4 || progressStep == 5) {
        petalController.reset();
        await setPetalSA(SequenceAnimationBuilder()
            .addAnimatable(
                animatable: Tween<double>(begin: 0, end: 0),
                from: const Duration(),
                to: const Duration(milliseconds: 111),
                tag: 'translateY',
                curve: Curves.easeOut)
            .addAnimatable(
                animatable: Tween<double>(begin: 0, end: 0),
                from: const Duration(),
                to: const Duration(milliseconds: 111),
                tag: 'translateX',
                curve: Curves.easeOut)
            .animate(petalController));
      } else if (progressStep == 6 || progressStep < 4) {
        if (_currentStep != 0) {
          petalController.reset();
          await setPetalSA(SequenceAnimationBuilder()
              .addAnimatable(
                  animatable: Tween<double>(begin: 0, end: 75),
                  from: const Duration(),
                  to: const Duration(milliseconds: 500),
                  tag: 'translateX',
                  curve: Curves.easeOut)
              .addAnimatable(
                  animatable: Tween<double>(begin: 75, end: -75),
                  from: const Duration(milliseconds: 500),
                  to: const Duration(milliseconds: 1500),
                  tag: 'translateX',
                  curve: Curves.easeOut)
              .addAnimatable(
                  animatable: Tween<double>(begin: 75, end: 0),
                  from: const Duration(milliseconds: 1500),
                  to: const Duration(milliseconds: 2500),
                  tag: 'translateX',
                  curve: Curves.easeOut)
              .addAnimatable(
                  animatable: Tween<double>(
                      begin: 0, end: gi<HomeState>().screenSize.height * 3),
                  from: const Duration(),
                  to: const Duration(milliseconds: 6500),
                  tag: 'translateY',
                  curve: Curves.easeOut)
              .animate(petalController));
          petalController.forward();
        } else {
          petalController.reset();
          await setPetalSA(SequenceAnimationBuilder()
              .addAnimatable(
                  animatable: Tween<double>(begin: 0, end: 75),
                  from: const Duration(),
                  to: const Duration(milliseconds: 500),
                  tag: 'translateX',
                  curve: Curves.easeOut)
              .addAnimatable(
                  animatable: Tween<double>(
                      begin: gi<HomeState>().screenSize.height * 2,
                      end: gi<HomeState>().screenSize.height * 2),
                  from: const Duration(),
                  to: const Duration(milliseconds: 2500),
                  tag: 'translateY',
                  curve: Curves.easeOut)
              .animate(petalController));
        }
      }
    } else {
      // if (progressStep < 4 && petalController.isDismissed) {
      //   petalController.forward();
      // }
    }
  }

  Future<void> _processAnimation(int progressStep) async {
    if (_currentStep != progressStep) {
      if (progressStep == 4) {
        await setSA(SequenceAnimationBuilder()
            .addAnimatable(
                animatable: Tween<double>(begin: 0, end: 1),
                from: const Duration(),
                to: const Duration(milliseconds: 1500),
                tag: 'scale',
                curve: Sprung())
            .addAnimatable(
                animatable: ColorTween(begin: greenLight, end: greenDark),
                from: const Duration(),
                to: const Duration(milliseconds: 1500),
                tag: 'color',
                curve: Curves.easeInOut)
            .animate(controller));

        controller.forward();
      } else if (progressStep == 5) {
        controller.reset();
        await setSA(SequenceAnimationBuilder()
            .addAnimatable(
                animatable: Tween<double>(begin: 1, end: 1.05),
                from: const Duration(),
                to: const Duration(milliseconds: 700),
                tag: 'scale',
                curve: Curves.easeIn)
            .addAnimatable(
                animatable: ColorTween(begin: greenDark, end: greenDark),
                from: const Duration(),
                to: const Duration(milliseconds: 1500),
                tag: 'color',
                curve: Curves.easeInOut)
            .animate(controller));

        controller.forward();
      } else if (progressStep == 6) {
        if (_currentStep <= 5) {
          controller.reset();
          await setSA(SequenceAnimationBuilder()
              .addAnimatable(
                  animatable: Tween<double>(begin: 1.05, end: 1),
                  from: const Duration(),
                  to: const Duration(milliseconds: 700),
                  tag: 'scale',
                  curve: Curves.easeIn)
              .addAnimatable(
                  animatable: ColorTween(begin: greenLight, end: greenDark),
                  from: const Duration(),
                  to: const Duration(milliseconds: 1500),
                  tag: 'color',
                  curve: Curves.easeInOut)
              .animate(controller));

          controller.forward();
        }
      }

      _currentStep = progressStep;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    petalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressState _progressState = Provider.of<ProgressState>(context);
    _processPetalAnimation(_progressState.progressStep);
    _processAnimation(_progressState.progressStep);

    return AnimatedBuilder(
        animation: petalController,
        builder: (context, child) {
          return AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: FlowerStagePainter(
                    sequenceAnimation['scale'].value,
                    sequenceAnimation['color'].value,
                    petalSequenceAnimation['translateX'].value,
                    petalSequenceAnimation['translateY'].value,
                  ),
                  child: Container(),
                );
              });
        });
  }
}

class FlowerStagePainter extends CustomPainter {
  final double scale;
  final Color color;
  final double translateX;
  final double translateY;

  FlowerStagePainter(
    this.scale,
    this.color,
    this.translateX,
    this.translateY,
  );
  @override
  void paint(Canvas canvas, Size size) {
    Path flowerPath =
        GuanabanaMaker.makeFlower(canvas, scale, color, translateX, translateY);
    if (gi<ProgressState>().progressStep == 4 ||
        gi<ProgressState>().progressStep == 5) {
      gi<ProgressState>().setFruitPath(flowerPath);
    }
  }

  @override
  bool shouldRepaint(covariant FlowerStagePainter oldDelegate) {
    return oldDelegate.scale != scale || oldDelegate.translateY != translateY;
  }
}
