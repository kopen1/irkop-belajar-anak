import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'providers/providers.dart';
import 'screens/angka_screen.dart';
import 'screens/hewan_screen.dart';
import 'screens/home_screen.dart';
import 'screens/gambar_titik_screen.dart';
import 'screens/huruf_screen.dart';
import 'screens/kuis_screen.dart';
import 'screens/prestasi_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/warna_screen.dart';
import 'theme/app_theme.dart';

/// Router — PRD D.4
final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/huruf', builder: (_, __) => const HurufScreen()),
    GoRoute(path: '/angka', builder: (_, __) => const AngkaScreen()),
    GoRoute(path: '/warna', builder: (_, __) => const WarnaScreen()),
    GoRoute(path: '/hewan', builder: (_, __) => const HewanScreen()),
    GoRoute(path: '/kuis', builder: (_, __) => const KuisScreen()),
    GoRoute(path: '/gambar-titik', builder: (_,__) => const GambarTitikScreen()),
    GoRoute(path: '/prestasi', builder: (_, __) => const PrestasiScreen()),
  ],
);

class BelajarAnakApp extends StatelessWidget {
  final ProgressProvider progress;
  final ThemeProvider theme;
  const BelajarAnakApp({super.key, required this.progress, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: theme),
        ChangeNotifierProvider<ProgressProvider>.value(value: progress),
        ChangeNotifierProvider<AudioProvider>(create: (_) => AudioProvider()),
        ChangeNotifierProvider<KuisProvider>(create: (_) => KuisProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, t, _) => MaterialApp.router(
          title: 'Belajar Anak',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: t.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: router,
        ),
      ),
    );
  }
}
