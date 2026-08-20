import 'package:flutter/material.dart';
import '../models/siko_case.dart';

class VerdictScreen extends StatelessWidget {
  final SikoCase sikoCase;
  final int points;
  final bool solved;

  const VerdictScreen({
    super.key,
    required this.sikoCase,
    required this.points,
    required this.solved,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VERDICT')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                solved ? Icons.gavel : Icons.location_off,
                size: 80,
                color: solved ? const Color(0xFFD4A017) : const Color(0xFF8B0000),
              ),
              const SizedBox(height: 16),
              Text(
                solved ? 'NALUTAS MO ANG KASO!' : 'NAGSARA ANG KASO...',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD4A017)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'POINTS: $points / 400',
                style: const TextStyle(fontSize: 16, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ANG TUNAY NA NANGYARI:',
                        style: TextStyle(fontSize: 12, letterSpacing: 1.5, color: Color(0xFF9E9E9E)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'SI ${sikoCase.killerName.toUpperCase()} ANG PUMATAY.',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD4A017)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Ang motibo ay ${sikoCase.motive}, at ang sandata ay ${sikoCase.weapon}.\n\n'
                        'Ang kanyang alibi ay may butas, at ang kanyang kilos — '
                        '${sikoCase.suspects.firstWhere((s) => s.name == sikoCase.killerName).behavior} — '
                        'ang nagtraydor sa kanya sa harap ng mga imbestigador.',
                        style: const TextStyle(fontSize: 14, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                icon: const Icon(Icons.home),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('BUMALIK SA HOMEPAGE', style: TextStyle(fontSize: 15, letterSpacing: 1.2)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A017),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}