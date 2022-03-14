import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:guanabana/ui/canvas/guanabana/guanabana.get.dart';
import 'package:simple_animations/simple_animations.dart';

import 'zelpers/app.colors.dart';
import 'zelpers/app.consts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
    required this.setSplashOver,
  }) : super(key: key);

  final Function setSplashOver;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _guanabanas = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [blue, blueLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Stack(
            children: _guanabanas,
          ),
          Stack(
            children: [
              Align(
                alignment: const Alignment(0, .9),
                child: PlayAnimation<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: 1,
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    builder: (context, child, value) {
                      return Transform.scale(
                        scale: value,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 50, right: 50),
                          child: FractionallySizedBox(
                            heightFactor: .15,
                            child: AutoSizeText(
                              '(TOUCH ANYWHERE)',
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'LuckiestGuy',
                                fontSize: 120,
                                shadows: AppConsts.boxShadows,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Align(
                child: FractionallySizedBox(
                  heightFactor: .4,
                  child: Container(
                    decoration: const BoxDecoration(
                      // color: Colors.black12,
                      gradient: LinearGradient(
                          colors: [
                            redLight,
                            redDark,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
                ),
              ),
              Align(
                child: MirrorAnimation<double>(
                    tween: Tween<double>(
                      begin: .95,
                      end: 1,
                    ),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    builder: (context, child, value) {
                      return Transform.scale(
                        scale: value,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 50, right: 50),
                          child: FractionallySizedBox(
                            heightFactor: .3,
                            child: AutoSizeText(
                              'GUANABANA',
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'LuckiestGuy',
                                fontSize: 220,
                                shadows: AppConsts.boxShadows,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Align(
                alignment: const Alignment(0, .35),
                child: PlayAnimation<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: 1,
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    builder: (context, child, value) {
                      return Transform.scale(
                        scale: value,
                        child: const FractionallySizedBox(
                          heightFactor: .2,
                          child: AutoSizeText(
                            'THE GAME',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 80,
                                shadows: AppConsts.boxShadows),
                            maxLines: 1,
                          ),
                        ),
                      );
                    }),
              ),
              GestureDetector(
                onTap: () {
                  widget.setSplashOver();
                },
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.transparent,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (_guanabanas.isEmpty) {
      for (var i = 0; i < 10; i++) {
        _guanabanas.insert(0, GuanabanaLauncher(key: Key(i.toString())));

        if (mounted) {
          setState(() {});
        }
        await Future.delayed(const Duration(milliseconds: 400));
      }
    }
  }
}

class GuanabanaLauncher extends StatelessWidget {
  const GuanabanaLauncher({
    Key? key,
  }) : super(key: key);
  Offset _getEnd(Size screenSize) {
    Offset _toReturn = Offset.zero;
    int ran = Random().nextInt(4);
    switch (ran) {
      case 0:
        return Offset(
          -screenSize.width / 2 * Random().nextDouble(),
          -screenSize.height / 2 * Random().nextDouble(),
        );
      case 1:
        return Offset(
          screenSize.width / 2 * Random().nextDouble(),
          screenSize.height / 2 * Random().nextDouble(),
        );
      case 2:
        return Offset(
          screenSize.width / 2 * Random().nextDouble(),
          -screenSize.height / 2 * Random().nextDouble(),
        );
      case 3:
        return Offset(
          -screenSize.width / 2 * Random().nextDouble(),
          screenSize.height / 2 * Random().nextDouble(),
        );
      default:
    }
    if (Random().nextBool()) {
      _toReturn = Offset(
        -screenSize.width * Random().nextDouble(),
        -screenSize.height * Random().nextDouble(),
      );
    }
    return _toReturn;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double sizeMod = Random().nextDouble();
    final int rotation = Random().nextInt(360);
    return Align(
      child: PlayAnimation<Offset>(
          tween: Tween<Offset>(
            begin: Offset.zero,
            end: _getEnd(screenSize),
          ),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          builder: (context, child, value) {
            return Transform.translate(
              offset: value,
              child: Transform.rotate(
                angle: rotation * (pi / 180),
                child: SizedBox(
                  height: screenSize.height * sizeMod,
                  child: const AspectRatio(
                    aspectRatio: 1,
                    child: GuanabanaGet(fade: false),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
