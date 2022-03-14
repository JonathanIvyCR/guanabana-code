import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import 'guanabana.generator.dart';

class GuanabanaGet extends StatefulWidget {
  const GuanabanaGet({Key? key, this.fade = true}) : super(key: key);
  final bool fade;

  @override
  State<GuanabanaGet> createState() => _GuanabanaGetState();
}

class _GuanabanaGetState extends State<GuanabanaGet> {
  late Uint8List image;
  bool imageReady = false;
  @override
  void initState() {
    super.initState();
    _getG();
  }

  Future<void> _getG() async {
    final ScreenshotController screenshotController = ScreenshotController();
    screenshotController
        .captureFromWidget(const GuanabanaGenerator(),
            delay: const Duration(milliseconds: 1))
        .then((capturedImage) {
      image = capturedImage;
      imageReady = true;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (imageReady && !widget.fade) {
      return Image.memory(image);
    }
    return AnimatedOpacity(
      opacity: imageReady ? 1 : 0,
      duration: const Duration(milliseconds: 250),
      child: imageReady ? Image.memory(image) : Container(),
    );
  }
}
