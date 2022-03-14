import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:guanabana/state/ant.state.dart';
import 'package:guanabana/zelpers/gi.dart';
import 'package:provider/provider.dart';
import 'game.stack.dart';
import 'splash.screen.dart';
import 'state/home.state.dart';
import 'ui/ant.nest/ant.nest.dart';
import 'ui/canvas/puzzle.progress/puzzle.progress.indicator.dart';
import 'ui/guanabana.text.dart';

class BackgroundWidget extends StatefulWidget {
  const BackgroundWidget({Key? key}) : super(key: key);

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  bool _appWasOff = true;

  void setSplashOver() {
    if (mounted) {
      _appWasOff = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_appWasOff) {
      return SplashScreen(
        setSplashOver: setSplashOver,
      );
    }

    final HomeState _homeState = Provider.of<HomeState>(context);

    return Stack(
      children: [
        const InitAfterLayoutWidget(),
        const PuzzleProgressIndicator(),
        const GuanabanaText(),
        if (_homeState.showGameStack) const GameStack(),
        const AntNest(),
      ],
    );
  }
}

class InitAfterLayoutWidget extends StatefulWidget {
  const InitAfterLayoutWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<InitAfterLayoutWidget> createState() => _InitAfterLayoutWidgetState();
}

class _InitAfterLayoutWidgetState extends State<InitAfterLayoutWidget>
    with AfterLayoutMixin<InitAfterLayoutWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return const SizedBox.shrink();
    });
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    gi<HomeState>().startMusic();
    for (var i = 0; i < 6; i++) {
      gi<AntState>().addAnt();
      await Future.delayed(Duration(seconds: Random().nextInt(5) + 2));
    }
  }
}
