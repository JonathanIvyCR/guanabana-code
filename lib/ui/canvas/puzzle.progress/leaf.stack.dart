import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:guanabana/ui/canvas/puzzle.progress/leaf.maker.dart';

import 'package:provider/provider.dart';
import 'package:sprung/sprung.dart';

import '../../../models/leaf.model.dart';
import '../../../models/progress.model.dart';
import '../../../state/progress.state.dart';
import '../../../state/puzzle.state.dart';
import '../../../zelpers/gi.dart';
import 'leaf.widget.dart';

class LeafStack extends StatefulWidget {
  const LeafStack({
    Key? key,
    required this.isFront,
  }) : super(key: key);
  final bool isFront;

  @override
  State<LeafStack> createState() => _LeafStackState();
}

class _LeafStackState extends State<LeafStack> with TickerProviderStateMixin {
  late AnimationController scaleController;
  late SequenceAnimation scaleSequenceAnimation;
  late AnimationController fallController;
  late SequenceAnimation fallSequenceAnimation;
  int _currentStep = 0;
  List<ProgressLeafModel> progressSteps = [];
  @override
  void initState() {
    super.initState();

    fallController = AnimationController(vsync: this);
    _processFallAnimation();
    scaleController = AnimationController(vsync: this);
    _setScaleSteps();
  }

  Future<bool> setFallSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        fallSequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  Future<bool> setScaleSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        scaleSequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  double _currentScale = 1;

  void _setScaleSteps() {
    if (progressSteps.isEmpty) {
      int numOfSteps = gi<PuzzleState>().puzzle.tilesNum + 1;
      for (var i = 0; i < numOfSteps; i++) {
        double _newScale = 1.2;

        switch (i) {
          case 0:
            _newScale = 0;
            break;
          case 1:
            _newScale = .1;
            break;
          case 2:
            _newScale = .5;
            break;
          case 3:
            _newScale = .7;
            break;
          case 4:
            _newScale = 1;
            break;
        }

        progressSteps.add(
          ProgressLeafModel(
            scale: _newScale,
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeInOut,
            tag: 'scale',
          ),
        );
      }
    }
  }

  Future<void> _procesScaleAnimation(int progressStep) async {
    if ((_currentStep != progressStep || _currentStep == 0)) {
      scaleController.reset();
      await setScaleSA(SequenceAnimationBuilder()
          .addAnimatable(
              animatable: Tween<double>(
                  begin: _currentScale, end: progressSteps[progressStep].scale),
              from: const Duration(),
              to: progressSteps[progressStep].duration,
              tag: 'scale',
              curve: progressSteps[progressStep].curve)
          .animate(scaleController));
      scaleController.forward();

      _currentStep = progressStep;
      _currentScale = progressSteps[progressStep].scale;
    }
  }

  Future<void> _processFallAnimation() async {
    await setFallSA(SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 3000),
            from: const Duration(),
            to: const Duration(milliseconds: 4500),
            tag: 'fall',
            curve: Sprung())
        .animate(fallController));
  }

  @override
  void dispose() {
    scaleController.dispose();
    fallController.dispose();
    super.dispose();
  }

  List<Widget> _leafWidgets(
      ProgressState progressState, double scale, double fallY) {
    List<Widget> _leaves = [];
    if (widget.isFront) {
      for (final LeafModel leaf in progressState.leavesFront) {
        _leaves.add(LeafWidget(
          key: Key(leaf.id.toString()),
          leaf: leaf,
          scale: scale,
          fallY: fallY,
        ));
      }
    } else {
      for (final LeafModel leaf in progressState.leavesBehind) {
        _leaves.add(LeafWidget(
          key: Key(leaf.id.toString()),
          leaf: leaf,
          scale: scale,
          fallY: fallY,
        ));
      }
    }

    return _leaves;
  }

  @override
  Widget build(BuildContext context) {
    final ProgressState _progressState = Provider.of<ProgressState>(context);
    if (_progressState.leavesFront.isEmpty && widget.isFront) {
      LeafMaker.makeLeavesNew();
    }
    if (_progressState.leavesFront.first.shouldFall &&
        fallController.status == AnimationStatus.dismissed) {
      fallController.forward();
    } else if (!_progressState.leavesFront.first.shouldFall &&
        fallController.status != AnimationStatus.dismissed) {
      fallController.reset();
    }

    _procesScaleAnimation(_progressState.progressStep);
    return AnimatedBuilder(
        animation: fallController,
        builder: (context, child) {
          return AnimatedBuilder(
              animation: scaleController,
              builder: (context, child) {
                _currentScale = scaleSequenceAnimation['scale'].value;
                return Stack(
                    children: _leafWidgets(
                  _progressState,
                  _currentScale,
                  fallSequenceAnimation['fall'].value,
                ));
              });
        });
  }
}
