import 'package:auto_size_text/auto_size_text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:guanabana/ui/canvas/guanabana/guanabana.get.dart';
import 'package:guanabana/zelpers/gi.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../state/guanabar.state.dart';
import '../../state/home.state.dart';
import '../../zelpers/app.colors.dart';
import 'guanabar.playButton.dart';

class GuanaBarStartGame extends StatelessWidget {
  const GuanaBarStartGame({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, -.9),
          child: PlayAnimation<double>(
              tween: Tween<double>(begin: 1, end: 0),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              builder: (context, child, value) {
                return Opacity(
                  opacity: 1 - value,
                  child: Transform.scale(
                    scale: 1 - value,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText(
                            'FLUTTER PUZZLE HACK',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 40,
                              color: brownLightest,
                            ),
                          ),
                          AutoSizeText('by Jonathan Ivy',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 25,
                                color: brownLightest,
                              )),
                          const Divider(),
                          AutoSizeText('flutter: true',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: brownLightest,
                              )),
                          AutoSizeText('slide_puzzle: true',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: brownLightest,
                              )),
                          AutoSizeText('hack: .abs()',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                color: brownLightest,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        const GuanaBarPlayButtom(),
        const Align(
          alignment: Alignment(1, .8),
          child: FractionallySizedBox(
            heightFactor: .45,
            child: GuanabanaGet(),
          ),
        ),
        Align(
          alignment: const Alignment(-.8, .9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  gi<GuanaBarState>().setGuanaBarStage(GuanaBarStage.settings);
                  FlameAudio.play('click.mp3', volume: gi<HomeState>().volume);
                },
                icon: const Icon(Icons.settings),
                color: Colors.brown[100],
                tooltip: 'Settings',
              ),
              IconButton(
                onPressed: () {
                  gi<GuanaBarState>().setGuanaBarStage(GuanaBarStage.about);
                  FlameAudio.play('click.mp3', volume: gi<HomeState>().volume);
                },
                icon: const Icon(Icons.info),
                color: Colors.brown[100],
                tooltip: 'Info',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
