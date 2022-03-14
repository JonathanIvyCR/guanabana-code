import 'package:flutter/material.dart';
import 'package:guanabana/ui/canvas/puzzle.progress/cloud.maker.dart';

import 'package:provider/provider.dart';

import '../../../models/cloud.model.dart';
import '../../../state/progress.state.dart';
import 'cloud.widget.dart';

class CloudStack extends StatelessWidget {
  const CloudStack({
    Key? key,
  }) : super(key: key);

  List<Widget> _cloudWidgets(ProgressState progressState) {
    List<Widget> _clouds = [];

    for (final CloudModel cloud in progressState.clouds) {
      _clouds.add(CloudWidget(
        key: Key(cloud.id.toString()),
        cloud: cloud,
      ));
    }

    return _clouds;
  }

  @override
  Widget build(BuildContext context) {
    final ProgressState _progressState = Provider.of<ProgressState>(context);
    if (_progressState.clouds.isEmpty) {
      CloudMaker.makeClouds(MediaQuery.of(context).size);
    }
    return Stack(
      children: _cloudWidgets(_progressState),
    );
  }
}
