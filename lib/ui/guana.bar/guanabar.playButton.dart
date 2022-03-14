import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

import 'package:guanabana/zelpers/app.colors.dart';

import '../../state/home.state.dart';
import '../../zelpers/gi.dart';

class GuanaBarPlayButtom extends StatefulWidget {
  const GuanaBarPlayButtom({
    Key? key,
  }) : super(key: key);

  @override
  State<GuanaBarPlayButtom> createState() => _GuanaBarPlayButtomState();
}

class _GuanaBarPlayButtomState extends State<GuanaBarPlayButtom>
    with TickerProviderStateMixin {
  late AnimationController buttonController;
  late SequenceAnimation buttonSequenceAnimation;
  late AnimationController translateController;
  late SequenceAnimation translateSequenceAnimation;

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(vsync: this);
    translateController = AnimationController(vsync: this);

    translateSequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(
            begin: .5,
            end: -.75,
          ),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 2000),
          curve: Curves.fastLinearToSlowEaseIn,
          tag: 'alignment-x',
        )
        .addAnimatable(
          animatable: Tween<double>(
            begin: .3,
            end: .3,
          ),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 400),
          curve: Curves.linear,
          tag: 'alignment-y',
        )
        .addAnimatable(
          animatable: Tween<double>(
            begin: .3,
            end: .4,
          ),
          from: const Duration(milliseconds: 400),
          to: const Duration(milliseconds: 2000),
          curve: Curves.fastLinearToSlowEaseIn,
          tag: 'alignment-y',
        )
        .addAnimatable(
          animatable: Tween<double>(
            begin: .1,
            end: 1,
          ),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 800),
          curve: Curves.fastLinearToSlowEaseIn,
          tag: 'scaleInitial',
        )
        .animate(translateController);

    buttonSequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 1, end: 1.1),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          tag: 'scale',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 1, end: 1),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          tag: 'scalePlay',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 1, end: 1.1),
          from: const Duration(milliseconds: 500),
          to: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          tag: 'scalePlay',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 1.5, end: 1.5),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 750),
          curve: Curves.easeInOut,
          tag: 'scaleIcon',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 1.5, end: 2.5),
          from: const Duration(milliseconds: 750),
          to: const Duration(milliseconds: 1000),
          curve: Curves.easeOut,
          tag: 'scaleIcon',
        )
        .animate(buttonController);
    buttonController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.dismissed:
          buttonController.forward();
          break;
        case AnimationStatus.completed:
          buttonController.reverse();
          break;
        default:
      }
    });
    buttonController.forward();
    translateController.forward();
  }

  @override
  void dispose() {
    buttonController.dispose();
    translateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: translateController,
        builder: (context, child) {
          return Align(
            alignment: Alignment(
              translateSequenceAnimation['alignment-x'].value,
              translateSequenceAnimation['alignment-y'].value,
            ),
            child: Transform.scale(
              scale: translateSequenceAnimation['scaleInitial'].value,
              child: AnimatedBuilder(
                  animation: buttonController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: buttonSequenceAnimation['scale'].value,
                      child: GestureDetector(
                        onTap: () {
                          FlameAudio.play('click.mp3',
                              volume: gi<HomeState>().volume);
                          gi<HomeState>().setStartGameClips(true);
                        },
                        child: Tooltip(
                          message: 'Play Guanabana',
                          child: FractionallySizedBox(
                            heightFactor: .2,
                            widthFactor: .4,
                            child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [redDark, redLight],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Align(
                                        // alignment: const Alignment(0, .5),
                                        child: Transform.scale(
                                          scale: buttonSequenceAnimation[
                                                  'scalePlay']
                                              .value,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: AutoSizeText(
                                              'PLAY',
                                              style: TextStyle(
                                                  fontFamily: 'LuckiestGuy',
                                                  fontSize: 60,
                                                  color: Colors.brown[100]!),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
  }
}
