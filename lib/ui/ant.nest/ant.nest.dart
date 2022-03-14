import 'package:flutter/material.dart';
import 'package:guanabana/state/ant.state.dart';
import 'package:provider/provider.dart';

import 'ant.widget.dart';

class AntNest extends StatelessWidget {
  const AntNest({
    Key? key,
  }) : super(key: key);

  List<Widget> _antWidgets(AntState antState) {
    List<Widget> _ants = [];

    for (final AntModel ant in antState.ants) {
      _ants.add(AntWidget(key: Key(ant.id.toString()), antId: ant.id));
    }

    return _ants;
  }

  @override
  Widget build(BuildContext context) {
    final AntState _antState = Provider.of<AntState>(context);

    return Stack(
      children: _antWidgets(_antState),
    );
  }
}
