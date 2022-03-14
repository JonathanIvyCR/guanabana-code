import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/guanabar.state.dart';
import '../../state/puzzle.state.dart';
import 'guana.bar.about.dart';
import 'guana.bar.playing.dart';
import 'guana.bar.menu.dart';
import 'guana.bar.start.dart';

class GuanaBar extends StatelessWidget {
  const GuanaBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PuzzleState _puzzleState = Provider.of<PuzzleState>(context);

    final GuanaBarState _guanaBarState = Provider.of<GuanaBarState>(context);

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 5,
              borderRadius: _guanaBarState.stage != GuanaBarStage.playingGame
                  ? BorderRadius.circular(25)
                  : const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
              child: AnimatedContainer(
                duration: Duration(
                    milliseconds:
                        _guanaBarState.stage != GuanaBarStage.playingGame
                            ? 800
                            : 500),
                alignment: Alignment.topCenter,
                curve: Curves.easeInOut,
                height: _guanaBarState.stage != GuanaBarStage.playingGame
                    ? constraints.maxHeight * .95
                    : constraints.maxHeight * .05,
                width: _puzzleState.size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.brown[400]!, Colors.brown[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      _guanaBarState.stage != GuanaBarStage.playingGame
                          ? BorderRadius.circular(25)
                          : const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                ),
                child: Stack(
                  children: [
                    if (_guanaBarState.stage == GuanaBarStage.startGame)
                      const GuanaBarStartGame(),
                    if (_guanaBarState.stage == GuanaBarStage.playingGame)
                      const GuanaBarPlayingGame(),
                    if (_guanaBarState.stage == GuanaBarStage.settings)
                      const GuanaBarMenu(),
                    if (_guanaBarState.stage == GuanaBarStage.about)
                      const GuanaBarAbout(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
