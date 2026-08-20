import 'package:flutter/material.dart';
import '../models/game_stats.dart';
import '../models/siko_case.dart';
import 'question_screen.dart';

class CaseIntroScreen extends StatelessWidget {
  final SikoCase sikoCase;
  final GameStats stats;
  final void Function(bool solved, int points, int streak) onCaseResult;

  const CaseIntroScreen({
    super.key,
    required this.sikoCase,
    required this.stats,
    required this.onCaseResult,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sikoCase.caseCode, style: const TextStyle(fontSize: 14)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              sikoCase.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFD4A017)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD4A017).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.5)),
              ),
              child: Text(
                sikoCase.type.label,
                style: const TextStyle(fontSize: 12, letterSpacing: 1, color: Color(0xFFD4A017)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sikoCase.type.description,
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            Text(
              sikoCase.story,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 8),
            const Text(
              'TIP: Basahin nang mabuti ang bawat detalye. Ang mga "madaling" tanong ay may bitag din.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF9E9E9E)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QuestionScreen(
                      sikoCase: sikoCase,
                      stats: stats,
                      onCaseResult: onCaseResult,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A017),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('SIMULAN ANG PAGSUSURI', style: TextStyle(fontSize: 15, letterSpacing: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}