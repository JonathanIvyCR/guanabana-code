import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:guanabana/state/puzzle.state.dart';
import 'package:guanabana/zelpers/app.colors.dart';
import 'package:provider/provider.dart';

import '../../state/home.state.dart';
import '../../zelpers/gi.dart';

class TileNumberDropdown extends StatefulWidget {
  const TileNumberDropdown({
    Key? key,
  }) : super(key: key);

  @override
  State<TileNumberDropdown> createState() => _TileNumberDropdownState();
}

class _TileNumberDropdownState extends State<TileNumberDropdown> {
  @override
  Widget build(BuildContext context) {
    final PuzzleState puzzleModel = Provider.of<PuzzleState>(context);

    return FractionallySizedBox(
      heightFactor: .15,
      child: AspectRatio(
        aspectRatio: 2.2,
        child: Card(
          color: redDark,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AutoSizeText(
                        'Tiles: ',
                        style: TextStyle(fontSize: 25),
                        maxLines: 1,
                      ),
                      PopupMenuButton<int>(
                        offset: const Offset(30, 0),
                        elevation: 10,
                        tooltip: 'Choose number of tiles',
                        color: blue,
                        onSelected: (int result) async {
                          puzzleModel.setNumberTiles(result);
                          FlameAudio.play('click.mp3',
                              volume: gi<HomeState>().volume);
                        },
                        child: AutoSizeText(
                          puzzleModel.numberTiles.toString(),
                          style: const TextStyle(fontSize: 25),
                          maxLines: 1,
                        ),
                        itemBuilder: (BuildContext context) {
                          List<PopupMenuEntry<int>> _toReturn = [];
                          List<int> _options = [
                            8,
                            15,
                            24,
                            35,
                            48,
                            63,
                            80,
                            99,
                            120,
                            143,
                            168,
                            195,
                            224,
                            255,
                            288,
                            323,
                            360
                          ];
                          for (int i in _options) {
                            _toReturn.add(PopupMenuItem<int>(
                              value: i,
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                  child: Text(i.toString(),
                                      style: const TextStyle(fontSize: 30))),
                            ));
                          }
                          return _toReturn;
                        },
                      )
                    ],
                  ),
                  const AutoSizeText(
                    'recommended: 15',
                    maxLines: 1,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
