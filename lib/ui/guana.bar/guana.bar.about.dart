import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:guanabana/state/progress.state.dart';
import 'package:guanabana/zelpers/app.colors.dart';
import 'package:guanabana/zelpers/gi.dart';

import 'package:simple_animations/simple_animations.dart';

import '../../state/guanabar.state.dart';
import '../../state/home.state.dart';
import '../../state/puzzle.state.dart';
import '../canvas/guanabana/guanabana.get.dart';

class GuanaBarAbout extends StatelessWidget {
  const GuanaBarAbout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, child, value) {
        return Stack(
          children: [
            const Align(
              alignment: Alignment(-.9, .8),
              child: FractionallySizedBox(
                heightFactor: .45,
                child: GuanabanaGet(),
              ),
            ),
            Transform.scale(
              scale: value,
              origin: const Offset(0, 0),
              child: Opacity(
                opacity: value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: const Alignment(.4, -.35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            AutoSizeText('noted guanabana (soursop) fan',
                                maxLines: 1, style: TextStyle(fontSize: 20)),
                            AutoSizeText('coding in Flutter since 2019',
                                maxLines: 1, style: TextStyle(fontSize: 20)),
                            AutoSizeText('available for projects',
                                maxLines: 1, style: TextStyle(fontSize: 20)),
                            AutoSizeText('jonathanivy@ymail.com',
                                maxLines: 1, style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      Align(
                        alignment: const Alignment(.8, .65),
                        child: GestureDetector(
                          onTap: () {
                            gi<ProgressState>().setProgress(4);
                            gi<HomeState>().setShowNewGame(true);
                            gi<HomeState>().setShowGameStats(false);

                            gi<GuanaBarState>()
                                .setGuanaBarStage(GuanaBarStage.startGame);
                            gi<PuzzleState>().clearPuzzle();
                            FlameAudio.play('click.mp3',
                                volume: gi<HomeState>().volume);
                          },
                          child: const FractionallySizedBox(
                            heightFactor: .1,
                            child: AspectRatio(
                              aspectRatio: 3,
                              child: Card(
                                color: redDark,
                                elevation: 10,
                                child: Center(
                                  child: AutoSizeText(
                                    'Home',
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, -.9),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            AutoSizeText(
                              'about the dev',
                              maxLines: 1,
                              style: TextStyle(fontSize: 60),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
