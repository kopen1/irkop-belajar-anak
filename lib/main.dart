import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // kIsWeb guard (PRD A.2) — orientasi portrait hanya di Android
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  final progress = ProgressProvider();
  final theme = ThemeProvider();
  await progress.load();
  await theme.load();

  runApp(BelajarAnakApp(progress: progress, theme: theme));
}
