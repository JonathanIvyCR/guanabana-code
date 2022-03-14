import 'package:flutter/material.dart';
import 'package:guanabana/state/home.state.dart';
import 'package:guanabana/state/puzzle.state.dart';

import 'package:guanabana/ui/canvas/slide.board/countdown.widget.dart';
import 'package:guanabana/ui/canvas/slide.board/slide.tiles.dart';
import 'package:guanabana/ui/startGame.afterLayout.Clips.dart';
import 'package:guanabana/zelpers/gi.dart';
import 'package:provider/provider.dart';

import '../../../state/guanabar.state.dart';

class SlideBoard extends StatelessWidget {
  const SlideBoard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeState _homeState = Provider.of<HomeState>(context);
    final GuanaBarState _guanaBarState = Provider.of<GuanaBarState>(context);
    final PuzzleState _puzzleState = Provider.of<PuzzleState>(context);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        opacity: _guanaBarState.stage == GuanaBarStage.playingGame ? 1 : 0,
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(builder: (context, constraints) {
            gi<PuzzleState>().setSize(constraints.biggest);

            return FittedBox(
              child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      if (_homeState.startGameClips)
                        const StartGameAfterLayoutClips(
                            key: Key('startGameClips')),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        opacity: _puzzleState.puzzle.playing ? 1 : 0,
                        child: const SlideTiles(),
                      ),
                      if (_homeState.showCountdown)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          opacity: _puzzleState.puzzle.playing ? 0 : 1,
                          child: const CountdownWidget(),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
