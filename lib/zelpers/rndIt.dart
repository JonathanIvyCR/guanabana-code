// ignore: file_names
import '../state/puzzle.state.dart';
import 'gi.dart';
import 'dart:math';

class RndIt {
  static List<double> getRandos(int i) {
    return List.generate(
      9,
      (index) {
        int o = 1;
        if (Random().nextBool()) {
          o = -o;
        }
        return o * Random((index * (i + 1)) + (i + 2) * 33).nextDouble();
      },
    );
  }

  static double getNegPosDouble(int base, int range, double chanceNegative) {
    double num = base + Random().nextInt(range).toDouble();
    if (Random(num ~/ 1).nextDouble() >= chanceNegative) {
      num = -num;
    }
    return num;
  }

  static double pnIt(int target) {
    if (Random().nextBool()) {
      return -target.toDouble();
    }
    return target.toDouble();
  }

  static double rndIt(num target, int range) {
    final double sideSize = gi<PuzzleState>().size.height;
    final double sideScale = sideSize / 1000;

    /// Takes in a target number and a range and returns plus/minus the range as a double
    if (range == 0) {
      return target * sideScale;
    } else if (Random(DateTime.now().microsecondsSinceEpoch).nextBool()) {
      return (target +
              Random(DateTime.now().microsecondsSinceEpoch)
                  .nextInt(range ~/ 2)
                  .toDouble()) *
          sideScale;
    } else {
      return (target -
              Random(DateTime.now().microsecondsSinceEpoch)
                  .nextInt(range ~/ 2)
                  .toDouble()) *
          sideScale;
    }
  }
}
