import 'dart:typed_data';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:guanabana/models/puzzle.model.dart';
import 'package:guanabana/state/guanabar.state.dart';
import 'package:guanabana/state/home.state.dart';
import 'package:guanabana/zelpers/gi.dart';

// ignore: implementation_imports
import 'package:matrix2d/src/extension/extension.dart';

import 'progress.state.dart';

class PuzzleState with ChangeNotifier {
  Size _size = const Size(600, 600);
  Size get size => _size;
  void setSize(Size value) {
    _size = value;
  }

  PuzzleModel _puzzle = PuzzleModel(
      tilesNum: 15,
      completed: false,
      movesNum: 0,
      tiles: [],
      correctTiles: [],
      solution: [],
      tilesSolution: [],
      tileHistory: <int>[],
      tileWidgets: <Widget>[],
      mascotTile: 0,
      mascotSightings: 0,
      mascotCaptured: false,
      timer: 0,
      showHints: true,
      screenshot: Uint8List.fromList([]));
  PuzzleModel get puzzle => _puzzle;

  void clearPuzzle() {
    _puzzle = PuzzleModel(
        tilesNum: _numberTiles,
        completed: false,
        movesNum: 0,
        tiles: [],
        correctTiles: [],
        solution: [],
        tilesSolution: [],
        tileHistory: <int>[],
        tileWidgets: <Widget>[],
        mascotTile: 0,
        mascotSightings: 0,
        mascotCaptured: false,
        timer: 0,
        showHints: true,
        screenshot: Uint8List.fromList([]));
    notifyListeners();
  }

  int _numberTiles = 15;
  int get numberTiles => _numberTiles;

  int hitTileY = 0;
  int hitTileX = 0;
  int zeroTileY = 0;
  int zeroTileX = 0;

  void setIndividualTileHint(int value) {
    _puzzle.individualTileHint = value;
    notifyListeners();
  }

  void setNumberTiles(int value) {
    _numberTiles = value;
    notifyListeners();
  }

  void setTileMoves(int value) {
    _puzzle.movesNum = value;
    notifyListeners();
  }

  void setMascotLocation(int value) {
    _puzzle.mascotTile = value;
    notifyListeners();
  }

  void setMascotSightings(int value) {
    _puzzle.mascotSightings = value;
    notifyListeners();
  }

  void setMascotCaptured(bool value) {
    _puzzle.mascotCaptured = value;
    notifyListeners();
  }

  void setShowPuzzleScreenshot(bool value) {
    _puzzle.showPuzzleScreenshot = value;
    notifyListeners();
  }

  void setShowHints(bool value) {
    _puzzle.showHints = value;
    notifyListeners();
  }

  void setCompleted(bool value) {
    _puzzle.completed = value;
    notifyListeners();
  }

  void setPlaying(bool value) {
    _puzzle.playing = value;
    notifyListeners();
  }

  void setPuzzle(PuzzleModel value) {
    _puzzle = value;
    notifyListeners();
  }

  void setScreenshot(Uint8List value) {
    _puzzle.screenshot = value;
    notifyListeners();
  }

  void setClips(List<Widget> clips) {
    _puzzle.tileWidgets = clips;
    notifyListeners();
  }

  void randomizeTiles() {
    final List<int> _history = [0, 0];
    for (var i = 0; i < (25 * _puzzle.tilesNum); i++) {
      // find eligible tiles
      List<int> eligible = [];
      for (List tileRow in puzzle.tiles) {
        for (int tile in tileRow) {
          if (tile == 0) {
            zeroTileY = puzzle.tiles.indexOf(tileRow);
            zeroTileX = tileRow.indexOf(tile);
          }
        }
      }
      try {
        eligible.add(puzzle.tiles[zeroTileY][zeroTileX - 1]);
      } catch (e) {
        // debugPrint(e.toString());
      }
      try {
        eligible.add(puzzle.tiles[zeroTileY][zeroTileX + 1]);
      } catch (e) {
        // debugPrint(e.toString());
      }
      try {
        eligible.add(puzzle.tiles[zeroTileY - 1][zeroTileX]);
      } catch (e) {
        // debugPrint(e.toString());
      }
      try {
        eligible.add(puzzle.tiles[zeroTileY + 1][zeroTileX]);
      } catch (e) {
        // debugPrint(e.toString());
      }

      // randomly choose next tile

      eligible.shuffle();
      try {
        if (_history.last != eligible.first &&
            _history[_history.length - 2] != eligible.first) {
          moveTile(eligible.first, true, false);
          _history.add(eligible.first);
        } else {
          moveTile(eligible.last, true, false);
          _history.add(eligible.last);
        }
      } catch (e) {
        // debugPrint(e.toString());
      }
    }
  }

  Future<void> skipTile(int tileHit) async {
    // _tileHit = tileHit;
    List<num> _toMoves = [];

    for (List tileRow in puzzle.tiles) {
      for (int tile in tileRow) {
        if (tile == 0) {
          zeroTileY = puzzle.tiles.indexOf(tileRow);
          zeroTileX = tileRow.indexOf(tile);
        }
        if (tile == tileHit) {
          hitTileY = puzzle.tiles.indexOf(tileRow);
          hitTileX = tileRow.indexOf(tile);
        }
      }
    }
    final List<int> hitOffset = [0, 0];
    hitOffset[0] = hitTileX - zeroTileX;
    hitOffset[1] = hitTileY - zeroTileY;
    if ((hitOffset[0] * hitOffset[1]).abs() == 2) {
      if (listEquals(hitOffset, [-2, -1])) {
        List _rowAbove = puzzle.tiles[zeroTileY - 1];
        List _rowOf = puzzle.tiles[zeroTileY];

        _toMoves.add(_rowAbove[zeroTileX]); // 1
        _toMoves.add(_rowAbove[zeroTileX - 1]); // 8
        _toMoves.add(_rowAbove[zeroTileX - 2]); // 21
        _toMoves.add(_rowOf[zeroTileX - 2]); // 5
        _toMoves.add(_rowOf[zeroTileX - 1]); // 3
        _toMoves.add(_rowAbove[zeroTileX - 2]); // 21
        _toMoves.add(_rowAbove[zeroTileX - 1]); // 8
        _toMoves.add(_rowAbove[zeroTileX]); // 1
        _toMoves.add(_rowAbove[zeroTileX - 2]); // 21
        _toMoves.add(_rowOf[zeroTileX - 1]); // 3
        _toMoves.add(_rowOf[zeroTileX - 2]); // 5

      } else if (listEquals(hitOffset, [2, 1])) {
        List _rowBelow = puzzle.tiles[zeroTileY + 1];
        List _rowOf = puzzle.tiles[zeroTileY];

        _toMoves.add(_rowBelow[zeroTileX]); // 1
        _toMoves.add(_rowBelow[zeroTileX + 1]); // 8
        _toMoves.add(_rowBelow[zeroTileX + 2]); // 21
        _toMoves.add(_rowOf[zeroTileX + 2]); // 5
        _toMoves.add(_rowOf[zeroTileX + 1]); // 3
        _toMoves.add(_rowBelow[zeroTileX + 2]); // 21
        _toMoves.add(_rowBelow[zeroTileX + 1]); // 8
        _toMoves.add(_rowBelow[zeroTileX]); // 1
        _toMoves.add(_rowBelow[zeroTileX + 2]); // 21
        _toMoves.add(_rowOf[zeroTileX + 1]); // 3
        _toMoves.add(_rowOf[zeroTileX + 2]); // 5

      } else if (listEquals(hitOffset, [-2, 1])) {
        List _rowBelow = puzzle.tiles[zeroTileY + 1];
        List _rowOf = puzzle.tiles[zeroTileY];

        _toMoves.add(_rowBelow[zeroTileX]); // 1
        _toMoves.add(_rowBelow[zeroTileX - 1]); // 8
        _toMoves.add(_rowBelow[zeroTileX - 2]); // 21
        _toMoves.add(_rowOf[zeroTileX - 2]); // 5
        _toMoves.add(_rowOf[zeroTileX - 1]); // 3
        _toMoves.add(_rowBelow[zeroTileX - 2]); // 21
        _toMoves.add(_rowBelow[zeroTileX - 1]); // 8
        _toMoves.add(_rowBelow[zeroTileX]); // 1
        _toMoves.add(_rowBelow[zeroTileX - 2]); // 21
        _toMoves.add(_rowOf[zeroTileX - 1]); // 3
        _toMoves.add(_rowOf[zeroTileX - 2]); // 5

      } else if (listEquals(hitOffset, [2, -1])) {
        List _rowBelow = puzzle.tiles[zeroTileY - 1];
        List _rowOf = puzzle.tiles[zeroTileY];

        _toMoves.add(_rowBelow[zeroTileX]); // 1
        _toMoves.add(_rowBelow[zeroTileX + 1]); // 8
        _toMoves.add(_rowBelow[zeroTileX + 2]); // 21
        _toMoves.add(_rowOf[zeroTileX + 2]); // 5
        _toMoves.add(_rowOf[zeroTileX + 1]); // 3
        _toMoves.add(_rowBelow[zeroTileX + 2]); // 21
        _toMoves.add(_rowBelow[zeroTileX + 1]); // 8
        _toMoves.add(_rowBelow[zeroTileX]); // 1
        _toMoves.add(_rowBelow[zeroTileX + 2]); // 21
        _toMoves.add(_rowOf[zeroTileX + 1]); // 3
        _toMoves.add(_rowOf[zeroTileX + 2]); // 5

      } else if (listEquals(hitOffset, [1, 2])) {
        List _rowOff1 = puzzle.tiles[zeroTileY + 1];
        List _rowOff2 = puzzle.tiles[zeroTileY + 2];
        List _rowOf = puzzle.tiles[zeroTileY];

        _toMoves.add(_rowOf[zeroTileX + 1]); // 4
        _toMoves.add(_rowOff1[zeroTileX + 1]); // 19
        _toMoves.add(_rowOff2[zeroTileX + 1]); // 6
        _toMoves.add(_rowOff2[zeroTileX]); // 9
        _toMoves.add(_rowOff1[zeroTileX]); // 1
        _toMoves.add(_rowOff2[zeroTileX + 1]); // 6
        _toMoves.add(_rowOff1[zeroTileX + 1]); // 19
        _toMoves.add(_rowOf[zeroTileX + 1]); // 4
        _toMoves.add(_rowOff2[zeroTileX + 1]); // 6
        _toMoves.add(_rowOff1[zeroTileX]); // 1
        _toMoves.add(_rowOff2[zeroTileX]); // 9

      } else if (listEquals(hitOffset, [-1, 2])) {
        List _rowOff1 = puzzle.tiles[zeroTileY + 1];
        List _rowOff2 = puzzle.tiles[zeroTileY + 2];
        List _rowOf = puzzle.tiles[zeroTileY];

        _toMoves.add(_rowOf[zeroTileX - 1]); // 4
        _toMoves.add(_rowOff1[zeroTileX - 1]); // 19
        _toMoves.add(_rowOff2[zeroTileX - 1]); // 6
        _toMoves.add(_rowOff2[zeroTileX]); // 9
        _toMoves.add(_rowOff1[zeroTileX]); // 1
        _toMoves.add(_rowOff2[zeroTileX - 1]); // 6
        _toMoves.add(_rowOff1[zeroTileX - 1]); // 19
        _toMoves.add(_rowOf[zeroTileX - 1]); // 4
        _toMoves.add(_rowOff2[zeroTileX - 1]); // 6
        _toMoves.add(_rowOff1[zeroTileX]); // 1
        _toMoves.add(_rowOff2[zeroTileX]); // 9

      } else if (listEquals(hitOffset, [1, -2])) {
        List _rowOff1 = puzzle.tiles[zeroTileY - 1];
        List _rowOff2 = puzzle.tiles[zeroTileY - 2];
        List _rowOf = puzzle.tiles[zeroTileY];

        _toMoves.add(_rowOf[zeroTileX + 1]); // 4
        _toMoves.add(_rowOff1[zeroTileX + 1]); // 19
        _toMoves.add(_rowOff2[zeroTileX + 1]); // 6
        _toMoves.add(_rowOff2[zeroTileX]); // 9
        _toMoves.add(_rowOff1[zeroTileX]); // 1
        _toMoves.add(_rowOff2[zeroTileX + 1]); // 6
        _toMoves.add(_rowOff1[zeroTileX + 1]); // 19
        _toMoves.add(_rowOf[zeroTileX + 1]); // 4
        _toMoves.add(_rowOff2[zeroTileX + 1]); // 6
        _toMoves.add(_rowOff1[zeroTileX]); // 1
        _toMoves.add(_rowOff2[zeroTileX]); // 9

      } else if (listEquals(hitOffset, [-1, -2])) {
        List _rowOff1 = puzzle.tiles[zeroTileY - 1];
        List _rowOff2 = puzzle.tiles[zeroTileY - 2];
        List _rowOf = puzzle.tiles[zeroTileY];

        _toMoves.add(_rowOf[zeroTileX - 1]);
        _toMoves.add(_rowOff1[zeroTileX - 1]);
        _toMoves.add(_rowOff2[zeroTileX - 1]);
        _toMoves.add(_rowOff2[zeroTileX]);
        _toMoves.add(_rowOff1[zeroTileX]);
        _toMoves.add(_rowOff2[zeroTileX - 1]);
        _toMoves.add(_rowOff1[zeroTileX - 1]);
        _toMoves.add(_rowOf[zeroTileX - 1]);
        _toMoves.add(_rowOff2[zeroTileX - 1]);
        _toMoves.add(_rowOff1[zeroTileX]);
        _toMoves.add(_rowOff2[zeroTileX]);
      }
    }

    if (_toMoves.isNotEmpty) {
      for (num t in _toMoves) {
        if (!puzzle.completed) {
          moveTile(t.toInt(), false, true);
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
    }
  }

  Future<void> moveTile(int tileHit, bool countMove, bool checkWin) async {
    for (List tileRow in puzzle.tiles) {
      for (int tile in tileRow) {
        if (tile == 0) {
          zeroTileY = puzzle.tiles.indexOf(tileRow);
          zeroTileX = tileRow.indexOf(tile);
        }
        if (tile == tileHit) {
          hitTileY = puzzle.tiles.indexOf(tileRow);
          hitTileX = tileRow.indexOf(tile);
        }
      }
    }
    List activeRow = puzzle.tiles[zeroTileY];
    List activeCol = [];
    for (List tileRow in puzzle.tiles) {
      final int colVal = tileRow[zeroTileX];
      activeCol.add(colVal);
    }
    if (hitTileX == zeroTileX) {
      if (checkWin) {
        FlameAudio.play('move.mp3', volume: gi<HomeState>().volume);
      }

      List tempColumn = [];
      // remove each int into new list,
      for (var i = 0; i < puzzle.tiles.length; i++) {
        List tempRow = puzzle.tiles[i];
        final int tempVal = tempRow.removeAt(zeroTileX);
        tempColumn.add(tempVal);
      }
      // modify new list
      final int zero = tempColumn.removeAt(zeroTileY);
      tempColumn.insert(hitTileY, zero);
      // insert each into back into each row
      for (var i = 0; i < puzzle.tiles.length; i++) {
        List tempRow = puzzle.tiles[i];
        tempRow.insert(hitTileX, tempColumn[i]);
      }
      if (checkWin) {
        puzzle.tileHistory.add(tileHit);
        if (!countMove) {
          setTileMoves(_puzzle.movesNum + 1);
        }
      }
    } else if (hitTileY == zeroTileY) {
      if (checkWin) {
        FlameAudio.play('move.mp3', volume: gi<HomeState>().volume);
      }
      final int zero = activeRow.removeAt(zeroTileX);
      activeRow.insert(hitTileX, zero);
      if (checkWin) {
        if (puzzle.mascotTile == tileHit) {
          setMascotLocation(0);
        }
        puzzle.tileHistory.add(tileHit);
        if (!countMove) {
          setTileMoves(_puzzle.movesNum + 1);
        }
      }
    }

    if (checkWin) {
      var answer =
          puzzle.tiles.flatten.sublist(0, puzzle.tiles.flatten.length - 1);
      final num numCorrect = puzzle.correctTiles.length.toDouble();
      puzzle.correctTiles.clear();
      bool _unMatchedFound = false;
      for (var i = 0; i < answer.length; i++) {
        if (!_unMatchedFound) {
          final int t = answer[i];
          final int c = puzzle.solution[i];
          if (t == c) {
            puzzle.correctTiles.add(c);
          } else {
            _unMatchedFound = true;
          }
        }
      }

      gi<ProgressState>().setProgress(puzzle.correctTiles.length);
      if (puzzle.correctTiles.length > numCorrect && checkWin) {
        FlameAudio.play('correct.mp3', volume: gi<HomeState>().volume);
      } else if (puzzle.correctTiles.length < numCorrect && checkWin) {
        FlameAudio.play('incorrect.mp3', volume: gi<HomeState>().volume);
      }
      if (listEquals(puzzle.solution, answer)) {
        // WINNER
        FlameAudio.play('winner.mp3', volume: gi<HomeState>().volume);

        setCompleted(true);
        setPlaying(false);

        gi<GuanaBarState>().setGuanaBarStage(GuanaBarStage.winner);
      }
    }
  }
}
