import 'package:flutter/material.dart';
import 'package:guanabana/state/puzzle.state.dart';
import 'package:guanabana/zelpers/app.colors.dart';
import 'package:provider/provider.dart';

class TileZero extends StatefulWidget {
  const TileZero({Key? key, required this.size}) : super(key: key);
  final Size size;

  @override
  State<TileZero> createState() => _TileZeroState();
}

class _TileZeroState extends State<TileZero> {
  bool _isHovering = false;
  bool _isEntering = false;
  @override
  Widget build(BuildContext context) {
    final PuzzleState puzzleState = Provider.of<PuzzleState>(context);
    return MouseRegion(
      onEnter: (e) async {
        if (!_isEntering) {
          if (mounted) {
            setState(() {
              _isEntering = true;
            });
          }
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            if (_isEntering) {
              if (mounted) {
                setState(() {
                  _isHovering = true;
                });
              }
            }
          });
        }
      },
      onExit: (e) {
        if (mounted) {
          setState(() {
            _isEntering = false;
            _isHovering = false;
          });
        }
      },
      child: GestureDetector(
        key: const Key('zero'),
        onTapDown: (deets) {
          puzzleState.setShowPuzzleScreenshot(true);
        },
        onTapUp: (deets) {
          puzzleState.setShowPuzzleScreenshot(false);
        },
        onTapCancel: () {
          puzzleState.setShowPuzzleScreenshot(false);
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: _isHovering ? 1 : 0,
          child: Material(
            elevation: 10,
            color: redLight,
            child: SizedBox(
              width: widget.size.width / puzzleState.puzzle.tilesSqrt,
              child: AspectRatio(
                aspectRatio: 1,
                child: puzzleState.puzzle.screenshot.isEmpty
                    ? const SizedBox.shrink()
                    : Image.memory(puzzleState.puzzle.screenshot,
                        fit: BoxFit.fitWidth),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
