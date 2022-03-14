import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guanabana/state/puzzle.state.dart';

import 'package:guanabana/zelpers/rndIt.dart';
import 'package:guanabana/zelpers/app.colors.dart';
import 'package:guanabana/zelpers/app.consts.dart';
import 'package:guanabana/zelpers/gi.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:provider/provider.dart';

import '../../state/guanabar.state.dart';

class PuzzleTimer extends StatefulWidget {
  const PuzzleTimer({
    Key? key,
  }) : super(key: key);

  @override
  State<PuzzleTimer> createState() => _PuzzleTimerState();
}

class _PuzzleTimerState extends State<PuzzleTimer> {
  late PausableTimer timer;
  int countDown = 0;
  @override
  void initState() {
    super.initState();
    if (countDown == 0) {
      if (gi<PuzzleState>().puzzle.timer != 0) {
        countDown = gi<PuzzleState>().puzzle.timer;
      }
    }
    timer = PausableTimer(
      const Duration(milliseconds: 100),
      () {
        countDown = countDown + 100;
        gi<PuzzleState>().puzzle.timer = countDown;
        timer
          ..reset()
          ..start();

        if (mounted) {
          setState(() {});
        }
      },
    )..start();
  }

  final Matrix4 rotateTenthsY = Matrix4.identity()
    ..setEntry(3, 2, 0)
    ..rotateY(0 * (pi / 180));

  final Matrix4 rotateSecondsY = Matrix4.identity()
    ..setEntry(3, 2, 0)
    ..rotateY(0 * (pi / 180));

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GuanaBarState _guanaBarState = Provider.of<GuanaBarState>(context);

    if (_guanaBarState.stage != GuanaBarStage.playingGame) {
      const SizedBox.shrink();
    }

    const double _fontSize = 20;

    String _seconds = (countDown / 1000).toString().split('.').first;
    String _tenths =
        (countDown / 1000).toString().split('.').last.substring(0, 1);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [redLight, redDark, redLight],
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(-1, 0),
            child: FractionallySizedBox(
              widthFactor: .7,
              child: Container(
                alignment: const Alignment(.5, 0),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: AutoSizeText(
                      _seconds,
                      key: ValueKey<String>(_seconds),
                      style: TextStyle(
                          fontSize: RndIt.rndIt(_fontSize + 15, 0),
                          shadows: AppConsts.boxShadows),
                      maxLines: 1,
                      // textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: .34,
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(-.5, 0),
                    child: FractionallySizedBox(
                      widthFactor: .5,
                      child: AutoSizeText(
                        '.',
                        style: TextStyle(
                            fontSize: RndIt.rndIt(_fontSize, 0),
                            shadows: AppConsts.boxShadows),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(.5, 0),
                    child: FractionallySizedBox(
                      widthFactor: .5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 40),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                          child: AutoSizeText(
                            _tenths,
                            key: ValueKey<String>(_tenths),
                            style: TextStyle(
                                fontSize: RndIt.rndIt(_fontSize, 0),
                                shadows: AppConsts.boxShadows),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
