import 'package:flutter/material.dart';

import 'app.dart';
import 'zelpers/gi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupGI();
  runApp(const MyApp());
}
