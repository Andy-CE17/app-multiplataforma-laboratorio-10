import 'package:flutter/material.dart';

import 'data/movie_repository.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'theme/app_theme.dart';

class LaboratoryApp extends StatefulWidget {
  const LaboratoryApp({super.key});

  @override
  State<LaboratoryApp> createState() => _LaboratoryAppState();
}

class _LaboratoryAppState extends State<LaboratoryApp> {
  @override
  void initState() {
    super.initState();
    MovieRepository.instance.loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    final repository = MovieRepository.instance;
    return AnimatedBuilder(
      animation: repository,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NOVA STREAM',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: repository.darkMode ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/browse': (context) => const MainShell(),
        },
      ),
    );
  }
}
