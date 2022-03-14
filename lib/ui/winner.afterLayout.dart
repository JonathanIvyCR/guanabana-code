import 'package:after_layout/after_layout.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'package:guanabana/state/home.state.dart';
import 'package:guanabana/state/puzzle.state.dart';
import 'package:guanabana/zelpers/app.colors.dart';
import 'package:guanabana/zelpers/app.consts.dart';
import 'package:guanabana/zelpers/gi.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:sprung/sprung.dart';

import '../state/guanabar.state.dart';

class WinnerWidgetTop extends StatefulWidget {
  const WinnerWidgetTop({Key? key}) : super(key: key);

  @override
  _WinnerWidgetTopState createState() => _WinnerWidgetTopState();
}

class _WinnerWidgetTopState extends State<WinnerWidgetTop>
    with AfterLayoutMixin<WinnerWidgetTop> {
  bool _finishedWaiting = false;

  @override
  Widget build(BuildContext context) {
    if (!_finishedWaiting) {
      return const SizedBox.shrink();
    }
    return PlayAnimation<double>(
        tween: Tween<double>(begin: .1, end: 1),
        duration: const Duration(milliseconds: 1200),
        curve: Sprung(),
        builder: (context, child, value) {
          return Transform.scale(
            scale: value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Align(
                    child: Image.memory(gi<PuzzleState>().puzzle.screenshot),
                  ),
                  Align(
                    alignment: const Alignment(0, -.5),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: AutoSizeText(
                        'NICE JOB!! ',
                        style: TextStyle(
                            fontFamily: 'LuckiestGuy',
                            fontSize: 100,
                            shadows: AppConsts.boxShadows,
                            color: brownLightest),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, .5),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: AutoSizeText(
                        'TIME: ${gi<PuzzleState>().puzzle.timer / 1000}',
                        style: TextStyle(
                            fontFamily: 'LuckiestGuy',
                            fontSize: 70,
                            shadows: AppConsts.boxShadows,
                            color: brownLightest),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                gi<HomeState>().setShowNewGame(true);
                                gi<HomeState>().setShowGameStats(false);

                                gi<PuzzleState>().clearPuzzle();
                                gi<GuanaBarState>()
                                    .setGuanaBarStage(GuanaBarStage.startGame);
                                FlameAudio.play('click.mp3',
                                    volume: gi<HomeState>().volume);
                              },
                              tooltip: 'Home',
                              icon: Icon(Icons.home, color: brownLightest)),
                          const SizedBox(width: 15),
                          IconButton(
                            onPressed: () {
                              FlameAudio.play('click.mp3',
                                  volume: gi<HomeState>().volume);
                              gi<HomeState>().setStartGameClips(true);
                            },
                            tooltip: 'Play again',
                            icon: Icon(Icons.play_circle_outline,
                                color: brownLightest),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (mounted) {
      setState(() {
        _finishedWaiting = true;
      });
    }
  }
}
