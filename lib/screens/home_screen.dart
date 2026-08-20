import 'package:flutter/material.dart';
import '../models/case_generator.dart';
import '../models/game_stats.dart';
import '../models/siko_case.dart';
import 'intro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GameStats _stats = GameStats();
  int _caseId = 1;
  int _streak = 0;

  void _startNewCase() {
    final sikoCase = CaseGenerator(caseId: _caseId).generate();
    setState(() => _caseId++);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CaseIntroScreen(
          sikoCase: sikoCase,
          stats: _stats,
          onCaseResult: (bool solved, int points, int streak) {
            setState(() {
              if (solved) {
                _stats.casesSolved++;
                _stats.totalPoints += points;
                _streak++;
                if (_streak > _stats.bestStreak) {
                  _stats.bestStreak = _streak;
                }
              } else {
                _streak = 0;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.psychology_alt, size: 72, color: Color(0xFFD4A017)),
              const SizedBox(height: 12),
              const Text(
                'SIKODETECTIVE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Color(0xFFD4A017),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Psychology Case Game — walang nauubos na kaso',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('NALUTAS NA KASO', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      const SizedBox(height: 4),
                      Text('${_stats.casesSolved}', style: const TextStyle(fontSize: 32, color: Color(0xFFD4A017))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatBox(label: 'PINAKAMATAAS NA STREAK', value: '${_stats.bestStreak}'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatBox(label: 'TOTAL POINTS', value: '${_stats.totalPoints}'),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _startNewCase,
                icon: const Icon(Icons.search),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('BAGONG KASO', style: TextStyle(fontSize: 16, letterSpacing: 2)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A017),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Basahin ang mga testimonya, suriin ang behavior ng bawat suspek, at tukuyin ang pumatay.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 24, color: Color(0xFFD4A017))),
          ],
        ),
      ),
    );
  }
}