import 'package:get_it/get_it.dart';
import 'package:guanabana/state/home.state.dart';
import 'package:guanabana/state/progress.state.dart';
import 'package:guanabana/state/puzzle.state.dart';

import '../state/ant.state.dart';

import '../state/guanabar.state.dart';

GetIt gi = GetIt.instance;

void setupGI() {
  gi.registerLazySingleton<HomeState>(() => HomeState());

  gi.registerLazySingleton<PuzzleState>(() => PuzzleState());
  gi.registerLazySingleton<ProgressState>(() => ProgressState());
  gi.registerLazySingleton<GuanaBarState>(() => GuanaBarState());
  gi.registerLazySingleton<AntState>(() => AntState());
}
