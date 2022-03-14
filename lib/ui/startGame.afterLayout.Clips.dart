import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:guanabana/state/home.state.dart';
import 'package:guanabana/state/progress.state.dart';
import 'package:guanabana/state/puzzle.state.dart';
import 'package:guanabana/zelpers/gi.dart';
import 'package:matrix2d/matrix2d.dart';
import 'package:screenshot/screenshot.dart';

import '../state/guanabar.state.dart';
import 'canvas/guanabana/guanabana.generator.dart';

class StartGameAfterLayoutClips extends StatefulWidget {
  const StartGameAfterLayoutClips({Key? key}) : super(key: key);

  @override
  _StartGameAfterLayoutClipsState createState() =>
      _StartGameAfterLayoutClipsState();
}

class _StartGameAfterLayoutClipsState extends State<StartGameAfterLayoutClips>
    with AfterLayoutMixin<StartGameAfterLayoutClips> {
  Widget guanabana = const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    gi<ProgressState>().setProgress(0);
    gi<GuanaBarState>().setGuanaBarStage(GuanaBarStage.playingGame);
    Widget _guanabana = const GuanabanaGenerator(key: Key('test'));
    if (mounted) {
      setState(() {
        guanabana = _guanabana;
      });
    }
    final PuzzleState puzzleModel = gi<PuzzleState>();
    puzzleModel.clearPuzzle();

    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    final ScreenshotController screenshotController = ScreenshotController();
    // final ScreenshotController screenshotController1 = ScreenshotController();

    gi<HomeState>().setShowNewGame(false);

    Matrix2d m2d = const Matrix2d();

    final double sideLen = puzzleModel.size.height;
    final double tileLen = sideLen / puzzleModel.puzzle.tilesSqrt;

    final int shapeSize = puzzleModel.puzzle.tilesSqrt.toInt();
    var newPuzzle = m2d.arange(puzzleModel.puzzle.tilesNum);
    newPuzzle[0].removeAt(0);
    newPuzzle[0].add(0);
    newPuzzle = newPuzzle.reshape(shapeSize, shapeSize);
    puzzleModel.puzzle.solution = m2d.arange(puzzleModel.puzzle.tilesNum);

    List tileSolution = m2d.arange(puzzleModel.puzzle.tilesNum);
    tileSolution[0].removeAt(0);
    tileSolution[0].add(0);

    puzzleModel.puzzle.tilesSolution =
        tileSolution.reshape(shapeSize, shapeSize);

    puzzleModel.puzzle.solution = puzzleModel.puzzle.solution[0];
    puzzleModel.puzzle.solution.removeAt(0);
    puzzleModel.puzzle.tiles = newPuzzle;

    screenshotController
        .captureFromWidget(_guanabana,
            pixelRatio: pixelRatio, delay: const Duration(seconds: 1))
        .then((capturedImage) {
      puzzleModel.setScreenshot(capturedImage);
      gi<HomeState>().setShowCountdown(true);
    });

    await Future.delayed(const Duration(milliseconds: 2000));

    if (puzzleModel.puzzle.screenshot.isNotEmpty) {
      for (var i = 0; i < puzzleModel.puzzle.tilesNum + 1; i++) {
        List matrix = m2d.arange(puzzleModel.puzzle.tilesNum);
        matrix = matrix.reshape(shapeSize, shapeSize);

        int x = 0;
        int y = 0;

        for (List row in matrix) {
          if (row.contains(i)) {
            x = row.indexOf(i);
            y = matrix.indexOf(row);
          }
        }

        puzzleModel.puzzle.tileWidgets.add(SizedBox(
          height: tileLen,
          width: tileLen,
          child: Stack(
            children: [
              Positioned(
                top: tileLen * -y,
                left: tileLen * -x,
                child: SizedBox(
                  height: puzzleModel.size.height,
                  child: Image.memory(
                    puzzleModel.puzzle.screenshot,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),
        ));
      }
    }

    puzzleModel.randomizeTiles();

    Future.delayed(const Duration(seconds: 1)).then((a) {
      gi<HomeState>().setShowGameStats(true);
    });

    gi<HomeState>().setStartGameClips(false);
  }
}
