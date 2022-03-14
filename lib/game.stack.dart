import 'package:flutter/material.dart';

import 'package:guanabana/state/guanabar.state.dart';
import 'package:provider/provider.dart';
import 'package:sprung/sprung.dart';

import 'state/home.state.dart';
import 'state/progress.state.dart';
import 'state/puzzle.state.dart';
import 'ui/canvas/slide.board/slide.board.dart';
import 'ui/guana.bar/guana.bar.dart';
import 'ui/winner.afterLayout.dart';
import 'zelpers/gi.dart';

class GameStack extends StatelessWidget {
  const GameStack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GuanaBarState _guanaBarState = Provider.of<GuanaBarState>(context);
    final PuzzleState _puzzleState = Provider.of<PuzzleState>(context);
    final Size screenSize = MediaQuery.of(context).size;
    gi<HomeState>().setScreenSize(screenSize);

    return Align(
      alignment: const Alignment(1, 0),
      child: FittedBox(
        child: SizedBox(
          width: screenSize.width * .9,
          height: screenSize.height * .95,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, .8),
                child: FractionallySizedBox(
                  heightFactor: .64,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return AspectRatio(
                      aspectRatio: 1,
                      child: FittedBox(
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: CustomPaint(
                            size: constraints.biggest,
                            painter: MainBoardPainter(),
                            child: Stack(
                              children: [
                                const Align(
                                  alignment: Alignment(0, 1.03),
                                  child: FractionallySizedBox(
                                    heightFactor: .95,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: SlideBoard(),
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedAlign(
                                  duration: const Duration(milliseconds: 1500),
                                  alignment: _guanaBarState.stage !=
                                          GuanaBarStage.playingGame
                                      ? Alignment.center
                                      : const Alignment(0, -1.01),
                                  curve: Sprung(),
                                  child: const GuanaBar(),
                                ),
                                if (_puzzleState.puzzle.completed)
                                  const WinnerWidgetTop(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawCircle(
    //     Offset(size.width * .5, size.height), 20, Paint()..color = greenDark);
    Path path = Path();
    Paint paint = Paint()..color = Colors.brown[700]!;
    path.addRRect(RRect.fromRectXY(
        Rect.fromPoints(Offset.zero, Offset(size.width, size.height)), 25, 25));
    canvas.drawShadow(path, Colors.black, 20, false);
    canvas.drawPath(path, paint);
    gi<ProgressState>().setBoard(path);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
