import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:provider/provider.dart';

import '../state/progress.state.dart';
import '../zelpers/app.consts.dart';
import '../zelpers/gi.dart';

class GuanabanaText extends StatefulWidget {
  const GuanabanaText({
    Key? key,
  }) : super(key: key);

  @override
  State<GuanabanaText> createState() => _GuanabanaTextState();
}

class _GuanabanaTextState extends State<GuanabanaText>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    _processAnimation();
  }

  Future<bool> setSA(SequenceAnimation value) async {
    if (mounted) {
      setState(() {
        sequenceAnimation = value;
      });
    }
    return Future.value(true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _processAnimation() async {
    // controller.reset();
    await setSA(SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 1, end: 1.1),
            from: const Duration(),
            to: const Duration(milliseconds: 600),
            tag: 'scale',
            curve: Curves.bounceOut)
        .addAnimatable(
            animatable: Tween<double>(begin: 1.1, end: 1.1),
            from: const Duration(milliseconds: 600),
            to: const Duration(milliseconds: 700),
            tag: 'scale',
            curve: Curves.linear)
        .addAnimatable(
            animatable: Tween<double>(begin: 1.1, end: 1),
            from: const Duration(milliseconds: 700),
            to: const Duration(milliseconds: 1000),
            tag: 'scale',
            curve: Curves.easeOut)
        .animate(controller));
    controller.addStatusListener((status) {
      switch (status) {
        // case AnimationStatus.dismissed:
        //   break;
        case AnimationStatus.completed:
          controller.reset();
          gi<ProgressState>().setSayingGuanabana(false);
          break;
        default:
      }
    });
    // controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final ps = Provider.of<ProgressState>(context);
    if (ps.signRect == Rect.zero) {
      return const SizedBox.shrink();
    }
    if (ps.sayingGuanabana && controller.isDismissed) {
      controller.forward();
    }
    return Positioned(
      top: ps.signRect.top + ps.signHeight * .1,
      left: ps.signRect.left,
      child: SizedBox(
          height: ps.signHeight,
          width: ps.signWidth,
          child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Align(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Transform.scale(
                      scale: sequenceAnimation['scale'].value,
                      child: AutoSizeText(
                        'GUANABANA',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.brown[200]!,
                          fontSize: 220,
                          fontFamily: 'LuckiestGuy',
                          shadows: AppConsts.boxShadows,
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
