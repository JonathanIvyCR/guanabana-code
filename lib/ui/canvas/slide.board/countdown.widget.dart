import 'package:after_layout/after_layout.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:guanabana/state/home.state.dart';
import 'package:guanabana/state/puzzle.state.dart';
import 'package:guanabana/zelpers/app.consts.dart';
import 'package:guanabana/zelpers/gi.dart';

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({Key? key}) : super(key: key);

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with AfterLayoutMixin<CountdownWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Text(
          _countdown,
          key: ValueKey<String>(_countdown),
          style: TextStyle(
              fontFamily: 'LuckiestGuy',
              fontSize: 200,
              shadows: AppConsts.boxShadows,
              color: Colors.brown[100]),
        ),
      ),
    );
  }

  String _countdown = '3';

  @override
  void afterFirstLayout(BuildContext context) async {
    final PuzzleState puzzleState = gi<PuzzleState>();
    FlameAudio.play('start.mp3', volume: gi<HomeState>().volume);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _countdown = '2';
      });
    }
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _countdown = '1';
      });
    }
    await Future.delayed(const Duration(seconds: 1));

    if (puzzleState.puzzle.tileWidgets.isNotEmpty) {
      puzzleState.setShowHints(true);
      puzzleState.setPlaying(true);
    }
    gi<HomeState>().setShowCountdown(false);
  }
}
