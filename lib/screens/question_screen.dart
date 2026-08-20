import 'package:flutter/material.dart';
import '../models/game_stats.dart';
import '../models/siko_case.dart';
import 'verdict_screen.dart';

class QuestionScreen extends StatefulWidget {
  final SikoCase sikoCase;
  final GameStats stats;
  final void Function(bool solved, int points, int streak) onCaseResult;

  const QuestionScreen({
    super.key,
    required this.sikoCase,
    required this.stats,
    required this.onCaseResult,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _qIdx = 0;
  int? _selected;
  bool _answered = false;
  int _points = 0;

  CaseQuestion get _question => widget.sikoCase.questions[_qIdx];

  void _choose(int idx) {
    if (_answered) return;
    setState(() {
      _selected = idx;
      _answered = true;
      if (idx == _question.correctIndex) _points += 100;
    });
  }

  void _next() {
    if (_qIdx < widget.sikoCase.questions.length - 1) {
      setState(() {
        _qIdx++;
        _selected = null;
        _answered = false;
      });
    } else {
      final solved = _points >= 300;
      widget.onCaseResult(solved, _points, 0);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => VerdictScreen(
            sikoCase: widget.sikoCase,
            points: _points,
            solved: solved,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _question;
    final total = widget.sikoCase.questions.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('${_qIdx + 1} / $total — ${widget.sikoCase.title.toUpperCase()}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_qIdx + 1) / total,
            backgroundColor: const Color(0xFF1A1A1A),
            color: const Color(0xFFD4A017),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFD4A017).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'TANONG ${_qIdx + 1} · ${q.kind.label}',
                style: const TextStyle(fontSize: 11, letterSpacing: 1, color: Color(0xFFD4A017)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              q.prompt,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
            ),
            const SizedBox(height: 20),
            ...List.generate(q.options.length, (i) {
              final isCorrect = i == q.correctIndex;
              final isSelected = i == _selected;
              Color? bg = const Color(0xFF1A1A1A);
              IconData? icon;
              if (_answered) {
                if (isCorrect) {
                  bg = const Color(0xFF1B5E20);
                  icon = Icons.check_circle;
                } else if (isSelected) {
                  bg = const Color(0xFF8B0000);
                  icon = Icons.cancel;
                }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _choose(i),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(child: Text(q.options[i], style: const TextStyle(fontSize: 14))),
                          if (icon != null) Icon(icon, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (_answered) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.4)),
                ),
                child: Text(q.explanation, style: const TextStyle(fontSize: 13, height: 1.5)),
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: _answered ? _next : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  _qIdx < total - 1 ? 'SUSUNOD NA TANONG' : 'IPAKITA ANG VERDICT',
                  style: const TextStyle(fontSize: 15, letterSpacing: 1.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}