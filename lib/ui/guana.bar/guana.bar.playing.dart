import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:guanabana/state/puzzle.state.dart';
import 'package:guanabana/zelpers/gi.dart';
import 'package:provider/provider.dart';

import '../../state/guanabar.state.dart';
import '../../state/home.state.dart';
import '../../zelpers/app.colors.dart';
import 'puzzle.timer.dart';

class GuanaBarPlayingGame extends StatelessWidget {
  const GuanaBarPlayingGame({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PuzzleState _puzzleState = Provider.of<PuzzleState>(context);
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: .3,
            heightFactor: 1,
            child: Center(
              child: Tooltip(
                message: 'Show numbers',
                child: TextButton(
                  onPressed: () {
                    _puzzleState.setShowHints(!_puzzleState.puzzle.showHints);
                    FlameAudio.play('click.mp3',
                        volume: gi<HomeState>().volume);
                  },
                  child: AutoSizeText(
                    '#',
                    style: TextStyle(
                      color: brownLightest,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 0),
          child: FractionallySizedBox(
            widthFactor: .15,
            heightFactor: 1,
            child: !_puzzleState.puzzle.playing
                ? const SizedBox.shrink()
                : const PuzzleTimer(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: .3,
            heightFactor: 1,
            child: Center(
              child: Tooltip(
                message: 'Settings',
                child: TextButton(
                  onPressed: () {
                    gi<GuanaBarState>()
                        .setGuanaBarStage(GuanaBarStage.settings);
                    FlameAudio.play('click.mp3',
                        volume: gi<HomeState>().volume);
                  },
                  child: Icon(Icons.settings, color: brownLightest),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
