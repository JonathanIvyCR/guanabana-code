import 'package:flutter/material.dart';
import 'package:guanabana/state/puzzle.state.dart';

import 'package:guanabana/zelpers/gi.dart';

import 'guanabana.front.painter.dart';
import 'guanabana.whole.painter.dart';

class GuanabanaGenerator extends StatefulWidget {
  const GuanabanaGenerator({Key? key}) : super(key: key);

  @override
  _GuanabanaGeneratorState createState() => _GuanabanaGeneratorState();
}

class _GuanabanaGeneratorState extends State<GuanabanaGenerator> {
  final List<CustomPainter> _painters = [
    GuanabanaWholePainter(),
    GuanabanaFrontPainter(),
  ];

  List<Widget> _widgets() {
    _painters.shuffle();
    List<Widget> _toReturn = [];
    for (CustomPainter cp in _painters) {
      if (_toReturn.isEmpty) {
        _toReturn.add(
          CustomPaint(
            painter: cp,
            child: Container(key: UniqueKey()),
          ),
        );
      }
    }

    return _toReturn;
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        height: gi<PuzzleState>().size.height,
        width: gi<PuzzleState>().size.height,
        child: Stack(
          children: _widgets(),
        ),
      ),
    );
  }
}
