import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:flutter/material.dart';
import 'package:guanabana/state/home.state.dart';
import 'package:guanabana/zelpers/app.colors.dart';

import 'package:provider/provider.dart';

class MusicWidget extends StatelessWidget {
  const MusicWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeState _homeState = Provider.of<HomeState>(context);

    return Align(
      alignment: const Alignment(.8, 0),
      child: FractionallySizedBox(
        heightFactor: .2,
        child: AspectRatio(
          aspectRatio: 2,
          child: Card(
            color: redDark,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: AutoSizeText(
                      'volume',
                      maxLines: 1,
                    ),
                  ),
                  Align(
                    child: Slider(
                      value: _homeState.volume,
                      onChanged: (val) {
                        _homeState.setVolume(val);
                        _homeState.playerLyrics.setVolume(val);
                        _homeState.playerSong.setVolume(val);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: .2,
                      widthFactor: .5,
                      child: GestureDetector(
                        onTap: () {
                          FlameAudio.play('click.mp3',
                              volume: _homeState.volume);
                          if (_homeState.myPlayerStatus ==
                              MyPlayerStatus.playing) {
                            _homeState.stopMusic();
                          } else if (_homeState.myPlayerStatus ==
                              MyPlayerStatus.stopped) {
                            _homeState.startMusic();
                          }
                        },
                        child: Container(
                          alignment: const Alignment(0, 0),
                          child: _homeState.myPlayerStatus ==
                                  MyPlayerStatus.stopped
                              ? const Icon(Icons.play_arrow)
                              : const Icon(Icons.stop),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
