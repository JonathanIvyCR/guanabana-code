import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'background.widget.dart';
import 'state/ant.state.dart';

import 'state/guanabar.state.dart';
import 'state/home.state.dart';

import 'state/progress.state.dart';
import 'state/puzzle.state.dart';
import 'zelpers/gi.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ScaffoldWidget(),
    );
  }
}

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: ProviderWidget(),
    );
  }
}

class ProviderWidget extends StatefulWidget {
  const ProviderWidget({Key? key}) : super(key: key);

  @override
  _ProviderWidgetState createState() => _ProviderWidgetState();
}

class _ProviderWidgetState extends State<ProviderWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeState>.value(value: gi<HomeState>()),
        ChangeNotifierProvider<PuzzleState>.value(value: gi<PuzzleState>()),
        ChangeNotifierProvider<ProgressState>.value(value: gi<ProgressState>()),
        ChangeNotifierProvider<GuanaBarState>.value(value: gi<GuanaBarState>()),
        ChangeNotifierProvider<AntState>.value(value: gi<AntState>()),
      ],
      child: const BackgroundWidget(),
    );
  }
}
