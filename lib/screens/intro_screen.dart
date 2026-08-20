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
            const SizedBox(height: 16),
            Text(
              sikoCase.intro,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 24),
            const Text(
              'MGA SUSPEK AT KANILANG TESTIMONYA',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFFD4A017)),
            ),
            const SizedBox(height: 12),
            ...sikoCase.suspects.map((s) => _SuspectCard(suspect: s)),
            const SizedBox(height: 8),
            const Text(
              'TIP: Bigyang-pansin ang mga hindi tugmang alibi, ang kilos ng bawat isa, at ang mga salitang pinipili nila.',
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
                child: Text('SIMULAN ANG INTERROGATION', style: TextStyle(fontSize: 15, letterSpacing: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuspectCard extends StatelessWidget {
  final Suspect suspect;

  const _SuspectCard({required this.suspect});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFD4A017).withValues(alpha: 0.15),
                  child: Text(
                    suspect.name.split(' ').first[0],
                    style: const TextStyle(color: Color(0xFFD4A017), fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(suspect.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Relasyon: ${suspect.relation}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('SINABI:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500])),
            const SizedBox(height: 4),
            Text(suspect.statement, style: const TextStyle(fontSize: 13, height: 1.5)),
            const SizedBox(height: 10),
            Text('ALIBI:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500])),
            const SizedBox(height: 4),
            Text(suspect.alibi, style: const TextStyle(fontSize: 13, height: 1.5)),
            const SizedBox(height: 10),
            Text('KILOS OBSERVED:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500])),
            const SizedBox(height: 4),
            Text(suspect.behavior, style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, height: 1.5)),
          ],
        ),
      ),
    );
  }
}