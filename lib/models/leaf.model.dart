import 'package:flutter/material.dart';

class LeafModel {
  LeafModel({
    required this.id,
    required this.stemBase,
    required this.leafBase,
    required this.leafTip,
    this.shouldFall = false,
    required this.isFront,
    required this.randos,
  });
  int id;
  Offset stemBase;
  Offset leafBase;
  Offset leafTip;
  bool shouldFall;
  bool isFront;
  List<double> randos;
}
