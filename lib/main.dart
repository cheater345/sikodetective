import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SikoDetectiveApp());
}

class SikoDetectiveApp extends StatelessWidget {
  const SikoDetectiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SikoDetective',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4A017),
          brightness: Brightness.dark,
          surface: const Color(0xFF121212),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        cardTheme: const CardThemeData(
          color: Color(0xFF1A1A1A),
          elevation: 0,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D0D0D),
          foregroundColor: Color(0xFFD4A017),
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'monospace', color: Color(0xFFE0E0E0)),
          bodyLarge: TextStyle(fontFamily: 'monospace', color: Color(0xFFE0E0E0)),
          titleLarge: TextStyle(fontFamily: 'monospace', color: Color(0xFFD4A017)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}