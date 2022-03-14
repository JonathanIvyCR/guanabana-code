import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:guanabana/state/progress.state.dart';
import 'package:guanabana/zelpers/app.colors.dart';
import 'package:guanabana/zelpers/gi.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../state/guanabar.state.dart';
import '../../state/home.state.dart';
import '../../state/puzzle.state.dart';
import '../canvas/guanabana/guanabana.get.dart';
import 'music.widget.dart';
import 'tileNumber.dropdown.dart';

class GuanaBarMenu extends StatelessWidget {
  const GuanaBarMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeState _homeState = Provider.of<HomeState>(context);

    return PlayAnimation<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
                child: Stack(
                  children: [
                    const Align(
                      alignment: Alignment(.8, .4),
                      child: TileNumberDropdown(),
                    ),
                    if (!_homeState.showNewGame)
                      Align(
                        alignment: const Alignment(.8, .9),
                        child: GestureDetector(
                          onTap: () {
                            gi<GuanaBarState>()
                                .setGuanaBarStage(GuanaBarStage.playingGame);
                            FlameAudio.play('click.mp3',
                                volume: gi<HomeState>().volume);
                          },
                          child: const Card(
                            color: redDark,
                            child: FractionallySizedBox(
                              heightFactor: .1,
                              child: AspectRatio(
                                aspectRatio: 3,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: AutoSizeText('RESUME',
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 30)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    const MusicWidget(),
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
                      alignment: const Alignment(0, -.8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          AutoSizeText(
                            'settings',
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
          ],
        );
      },
    );
  }
}
