import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:guanabana/state/puzzle.state.dart';
import 'package:guanabana/ui/canvas/slide.board/tile.zero.dart';
import 'package:guanabana/zelpers/app.consts.dart';
import 'package:provider/provider.dart';

class SlideTiles extends StatelessWidget {
  const SlideTiles({Key? key}) : super(key: key);

  Widget _getTile(int tileId, PuzzleState puzzleState, double yPos, double xPos,
      Size size) {
    if (puzzleState.puzzle.tileWidgets.isEmpty) {
      return const SizedBox.shrink();
    }

    bool manyTiles = puzzleState.puzzle.tilesNum > 50;
    double tileHeight = size.height / puzzleState.puzzle.tilesSqrt;

    return AnimatedPositioned(
      key: Key(tileId.toString()),
      duration:
          manyTiles ? const Duration() : const Duration(milliseconds: 500),
      curve: Curves.decelerate,
      top: size.height * (yPos),
      left: size.width * (xPos),
      child: tileId != 0
          ? GestureDetector(
              onTap: () => puzzleState.moveTile(tileId, false, true),
              onDoubleTap: () => puzzleState.skipTile(tileId),
              onSecondaryTapDown: (deets) {
                puzzleState.setIndividualTileHint(tileId);
              },
              onSecondaryTapUp: (deets) {
                puzzleState.setIndividualTileHint(-1);
              },
              onSecondaryTapCancel: () {
                puzzleState.setIndividualTileHint(-1);
              },
              child: SizedBox(
                width: size.width / puzzleState.puzzle.tilesSqrt,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                            colors: [Colors.brown[400]!, Colors.brown[500]!],
                            radius: .9),
                      ),
                      child: Stack(
                        children: [
                          puzzleState.puzzle.tileWidgets[tileId - 1],
                          Align(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 150),
                              opacity: puzzleState.puzzle.showHints ||
                                      puzzleState.puzzle.individualTileHint ==
                                          tileId
                                  ? 1
                                  : 0,
                              child: Padding(
                                padding: EdgeInsets.only(top: tileHeight * .2),
                                child: AutoSizeText(
                                  tileId.toString(),
                                  maxLines: 1,
                                  minFontSize: 3,
                                  style: TextStyle(
                                      fontFamily: 'LuckiestGuy',
                                      fontSize: 70,
                                      shadows: AppConsts.boxShadows,
                                      color: Colors.brown[100]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            )
          : TileZero(
              size: size,
            ),
    );
  }

  List<Widget> _getTiles(PuzzleState puzzleState, Size size) {
    List<Widget> _toReturn = [];
    for (List tileRow in puzzleState.puzzle.tiles) {
      final int y = puzzleState.puzzle.tiles.indexOf(tileRow);
      final double yPos = y / puzzleState.puzzle.tiles.length;
      for (int tileId in tileRow) {
        final int x = tileRow.indexOf(tileId);
        final double xPos = x / tileRow.length;
        _toReturn.add(
          _getTile(tileId, puzzleState, yPos, xPos, size),
        );
      }
    }
    return _toReturn;
  }

  List<Widget> _getTilesCorrect(PuzzleState puzzleState, Size size) {
    List<Widget> _toReturn = [];
    for (List tileRow in puzzleState.puzzle.tilesSolution) {
      final int y = puzzleState.puzzle.tilesSolution.indexOf(tileRow);
      final double yPos = y / puzzleState.puzzle.tilesSolution.length;
      for (int tileId in tileRow) {
        final int x = tileRow.indexOf(tileId);
        final double xPos = x / tileRow.length;
        _toReturn.add(
          _getTile(tileId, puzzleState, yPos, xPos, size),
        );
      }
    }
    return _toReturn;
  }

  @override
  Widget build(BuildContext context) {
    final PuzzleState puzzleState = Provider.of<PuzzleState>(context);
    if (puzzleState.puzzle.tiles.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(builder: (context, constraints) {
      if (puzzleState.puzzle.showPuzzleScreenshot) {
        return Stack(
            children: _getTilesCorrect(puzzleState, constraints.biggest));
      }
      return Stack(
        children: _getTiles(puzzleState, constraints.biggest),
      );
    });
  }
}
