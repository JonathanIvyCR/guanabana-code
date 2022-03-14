import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:guanabana/zelpers/gi.dart';
import 'package:guanabana/zelpers/rndIt.dart';
import 'package:provider/provider.dart';

import '../../state/ant.state.dart';
import '../../state/home.state.dart';
import '../../state/progress.state.dart';
import 'ant.painter.dart';

class AntWidget extends StatefulWidget {
  const AntWidget({
    Key? key,
    required this.antId,
  }) : super(key: key);

  final int antId;

  @override
  State<AntWidget> createState() => _AntWidgetState();
}

class _AntWidgetState extends State<AntWidget> with TickerProviderStateMixin {
  late AnimationController movementController;
  late SequenceAnimation movementSequenceAnimation;
  late AnimationController fallController;
  late SequenceAnimation fallSequenceAnimation;
  @override
  void initState() {
    super.initState();
    movementController = AnimationController(vsync: this);
    fallController = AnimationController(vsync: this);
    _processFall();
    movementController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          gi<AntState>().setWalkCompleted(widget.antId);
          break;
        default:
      }
    });
  }

  Future<bool> setSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        movementSequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  Future<bool> setFallSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        fallSequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  @override
  void dispose() {
    movementController.dispose();
    fallController.dispose();
    super.dispose();
  }

  // late Tangent tangent;
  // late PathMetric pathMetric;
  // Path nextPath = Path();
  bool _paintAnt = false;

  Future<void> _processFall() async {
    await setFallSA(SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(
                begin: 0, end: gi<HomeState>().screenSize.height * 3),
            from: const Duration(),
            to: const Duration(milliseconds: 2500),
            tag: 'fallY',
            curve: Curves.bounceOut)
        .addAnimatable(
            animatable: Tween<double>(
                begin: 0, end: (Random().nextBool() ? -100 : 100) * (pi / 180)),
            from: const Duration(),
            to: const Duration(milliseconds: 150),
            tag: 'rot',
            curve: Curves.easeInOut)
        .animate(fallController));
  }

  Future<void> _processAnimation(int antId) async {
    final AntModel _ant = gi<AntState>().ants[antId];
    if (_ant.walkCompleted) {
      if (ant.zone == AntZone.fruit && !ant.fall) {
        if (gi<ProgressState>().progressStep <= 3) {
          ant.fall = true;
          fallController.forward();
          gi<AntState>().clearAnt(ant.id);
          FlameAudio.play('scream.mp3', volume: gi<HomeState>().volume / 1.5);
          // Future.delayed(const Duration(seconds: 3)).then((value) {
          //   print('ant leng ${gi<AntState>().ants.length}');
          //   if (gi<AntState>().ants.length <= 5) gi<AntState>().addAnt();
          // });
        } else if (!gi<ProgressState>().fruitPath.contains(ant.locCur)) {
          switch (ant.problemCounter) {
            case 4:
              ant.fall = true;
              fallController.forward();
              gi<AntState>().clearAnt(ant.id);
              FlameAudio.play('scream.mp3',
                  volume: gi<HomeState>().volume / 1.5);

              break;
            default:
              ant.problemCounter++;
              break;
          }
        }
      }
      gi<AntState>().setWalkCompletedFalse(antId);
      movementController.reset();

      int duration = 1000;
      if (_ant.distance > 0) {
        double _mod = _ant.distance / _ant.totalPossibleDistance;
        // print(_mod);
        if (_mod < .5) {
          duration = 500 + Random().nextInt(500);
        } else if (_mod > .7 && _mod < 1) {
          duration = 2000 + Random().nextInt(1000);
        } else {
          duration = 2000 + Random().nextInt(2000);
        }
      }

      await setSA(SequenceAnimationBuilder()
          .addAnimatable(
              animatable:
                  Tween<double>(begin: _ant.locCur.dx, end: _ant.locCur.dx),
              from: const Duration(),
              to: const Duration(milliseconds: 50),
              tag: 'locX',
              curve: Curves.linear)
          .addAnimatable(
              animatable:
                  Tween<double>(begin: _ant.locCur.dx, end: _ant.locNew.dx),
              from: const Duration(milliseconds: 50),
              to: Duration(milliseconds: duration),
              tag: 'locX',
              curve: Curves.linear)
          .addAnimatable(
              animatable:
                  Tween<double>(begin: _ant.locCur.dy, end: _ant.locCur.dy),
              from: const Duration(),
              to: const Duration(milliseconds: 50),
              tag: 'locY',
              curve: Curves.linear)
          .addAnimatable(
              animatable:
                  Tween<double>(begin: _ant.locCur.dy, end: _ant.locNew.dy),
              from: const Duration(milliseconds: 50),
              to: Duration(milliseconds: duration),
              tag: 'locY',
              curve: Curves.linear)
          .addAnimatable(
              animatable:
                  Tween<double>(begin: _ant.angleCurrent, end: _ant.angleNew),
              from: const Duration(),
              to: const Duration(milliseconds: 500),
              tag: 'angle',
              curve: Curves.linear)
          .addAnimatable(
              animatable: Tween<double>(begin: 0, end: 10),
              from: const Duration(),
              to: Duration(milliseconds: (duration * .1).toInt()),
              tag: 'legs',
              curve: Curves.linear)
          .addAnimatable(
              animatable: Tween<double>(begin: 10, end: 0),
              from: Duration(milliseconds: (duration * .1).toInt()),
              to: Duration(milliseconds: (duration * .2).toInt()),
              tag: 'legs',
              curve: Curves.linear)
          .addAnimatable(
              animatable: Tween<double>(begin: 0, end: 10),
              from: Duration(milliseconds: (duration * .2).toInt()),
              to: Duration(milliseconds: (duration * .3).toInt()),
              tag: 'legs',
              curve: Curves.linear)
          .addAnimatable(
              animatable: Tween<double>(begin: 10, end: 0),
              from: Duration(milliseconds: (duration * .3).toInt()),
              to: Duration(milliseconds: (duration * .4).toInt()),
              tag: 'legs',
              curve: Curves.linear)
          .addAnimatable(
              animatable: Tween<double>(begin: 0, end: 10),
              from: Duration(milliseconds: (duration * .4).toInt()),
              to: Duration(milliseconds: (duration * .5).toInt()),
              tag: 'legs',
              curve: Curves.linear)
          .addAnimatable(
              animatable: Tween<double>(begin: 10, end: 0),
              from: Duration(milliseconds: (duration * .5).toInt()),
              to: Duration(milliseconds: (duration * .6).toInt()),
              tag: 'legs',
              curve: Curves.linear)
          .addAnimatable(
              animatable: Tween<double>(begin: 0, end: 10),
              from: Duration(milliseconds: (duration * .6).toInt()),
              to: Duration(milliseconds: (duration * .7).toInt()),
              tag: 'legs',
              curve: Curves.linear)
          .addAnimatable(
              animatable: Tween<double>(begin: 10, end: 0),
              from: Duration(milliseconds: (duration * .7).toInt()),
              to: Duration(milliseconds: (duration * .8).toInt()),
              tag: 'legs',
              curve: Curves.linear)
          .addAnimatable(
              animatable: Tween<double>(begin: 0, end: 10),
              from: Duration(milliseconds: (duration * .8).toInt()),
              to: Duration(milliseconds: (duration * .9).toInt()),
              tag: 'legs',
              curve: Curves.linear)
          .addAnimatable(
              animatable: Tween<double>(begin: 10, end: 0),
              from: Duration(milliseconds: (duration * .9).toInt()),
              to: Duration(milliseconds: duration),
              tag: 'legs',
              curve: Curves.linear)
          .animate(movementController));
      _paintAnt = true;
      movementController.forward();



      await Future.delayed(const Duration(milliseconds: 300)).then((value) {
        _ant.angleCurrent = _ant.angleNew;
      });

      _handled = false;
    }
  }


  bool _handled = false;
  late AntModel ant;

  @override
  Widget build(BuildContext context) {
    final AntState _antState = Provider.of<AntState>(context);
    ant = _antState.ants[widget.antId];
    if (ant.walkCompleted && !_handled) {
      _handled = true;
      _processAnimation(ant.id);
    }

    if (!_paintAnt) return const SizedBox.shrink();

    return Stack(
      children: [
        AnimatedBuilder(
            animation: fallController,
            builder: (context, child) {
              return AnimatedBuilder(
                  animation: movementController,
                  builder: (context, child) {
                    return Positioned(
                      left: movementSequenceAnimation['locX'].value -
                          (ant.size.width * .5),
                      top: movementSequenceAnimation['locY'].value -
                          (ant.size.height * .5) +
                          fallSequenceAnimation['fallY'].value,
                      child: Transform.rotate(
                        angle: movementSequenceAnimation['angle'].value +
                            fallSequenceAnimation['rot'].value,
                        // angle: 0,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                 
                            FlameAudio.play('scream.mp3',
                                volume: gi<HomeState>().volume / 1.5);

                            fallController.forward();
                            _antState.clearAnt(ant.id);
                          },
                          child: SizedBox(
                            height: RndIt.rndIt(70 * ant.scale, 0),
                            child: AspectRatio(
                              aspectRatio: 3 / 5.5,
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                ant.size = constraints.biggest;
                                return FittedBox(
                                  child: SizedBox(
                                    height: ant.size.height,
                                    width: ant.size.width,
                                    child: CustomPaint(
                                      painter: AntPainter(
                                        ant: ant,
                                        legAnim:
                                            movementSequenceAnimation['legs']
                                                .value,
                                      ),
                                      child: Container(),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ],
    );
  }
}
