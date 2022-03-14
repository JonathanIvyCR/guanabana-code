import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guanabana/models/cloud.model.dart';

import '../../../state/progress.state.dart';
import '../../../zelpers/gi.dart';
import '../../../zelpers/rndIt.dart';

class CloudMaker {
  static void makeClouds(Size screenSize) {
    final ProgressState _ps = gi<ProgressState>();

    for (var i = 0; i < 3; i++) {
      double ran = Random(i + 2).nextDouble() / 4;
      _ps.clouds.add(
        CloudModel(
          id: i,
          cloudLoc: Offset(
            -200,
            screenSize.height * (.1 + ((i / 10)) + ran),
          ),
          targetLoc: Offset(
            screenSize.width + 200,
            screenSize.height * (.1 + ((i / 10)) + ran),
          ),
          scale: 1.5 - (ran * (2 * (i + 1))),
          randos: RndIt.getRandos(i),
        ),
      );
    }
  }
}
