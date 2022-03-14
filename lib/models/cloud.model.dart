import 'dart:ui';

class CloudModel {
  CloudModel({
    required this.id,
    required this.cloudLoc,
    required this.targetLoc,
    required this.scale,
    this.leftScreen = false,
    required this.randos,
  });
  int id;
  Offset cloudLoc;
  Offset targetLoc;
  double scale;
  bool leftScreen;
  List<double> randos;
}
