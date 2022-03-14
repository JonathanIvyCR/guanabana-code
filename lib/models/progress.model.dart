import 'package:flutter/material.dart';

class ProgressLightModel {
  ProgressLightModel({
    required this.alignmentNew,
    required this.duration,
    required this.curve,
    required this.tag,
  });

  Alignment alignmentNew;
  Duration duration;
  Curve curve;
  String tag;
}

class ProgressStarModel {
  ProgressStarModel({
    required this.rotationCurrent,
    required this.rotationNew,
    required this.duration,
    required this.curve,
    required this.tag,
  });
  double rotationCurrent;
  double rotationNew;
  Duration duration;
  Curve curve;
  String tag;
}

class ProgressMoonModel {
  ProgressMoonModel({
    required this.rotationCurrent,
    required this.rotationNew,
    required this.duration,
    required this.curve,
    required this.tag,
  });
  double rotationCurrent;
  double rotationNew;
  Duration duration;
  Curve curve;
  String tag;
}

class ProgressCloudModel {
  ProgressCloudModel({
    required this.colorNewA,
    required this.colorNewB,
    required this.duration,
    required this.curve,
    required this.tag,
  });

  Color colorNewA;
  Color colorNewB;
  Duration duration;
  Curve curve;
  String tag;
}

class ProgressSkyModel {
  ProgressSkyModel({
    required this.colorNewA,
    required this.colorNewB,
    required this.duration,
    required this.curve,
    required this.tag,
  });

  Color colorNewA;
  Color colorNewB;
  Duration duration;
  Curve curve;
  String tag;
}

class ProgressFruitModel {
  ProgressFruitModel({
    required this.scale,
    required this.duration,
    required this.curve,
    required this.tag,
  });
  double scale;
  Duration duration;
  Curve curve;
  String tag;
}

class ProgressModel {
  ProgressModel({
    required this.step,
    required this.leaf,
    required this.branch,
  });
  int step;
  ProgressLeafModel leaf;
  ProgressBranchModel branch;
}

class ProgressFlowerModel {
  ProgressFlowerModel({
    required this.scale,
    required this.color,
    required this.fallY,
    required this.fallX,
    required this.duration,
    required this.curve,
    required this.tag,
  });
  double scale;
  Color color;
  double fallY;
  double fallX;
  Duration duration;
  Curve curve;
  String tag;
}

class ProgressLeafModel {
  ProgressLeafModel({
    required this.scale,
    required this.duration,
    required this.curve,
    required this.tag,
  });
  double scale;
  Duration duration;
  Curve curve;
  String tag;
}

class ProgressBranchModel {
  ProgressBranchModel({
    required this.branchX,
    required this.branchY,
    required this.duration,
    required this.curve,
    required this.tag,
  });
  double branchX;
  double branchY;
  Duration duration;
  Curve curve;
  String tag;
}
