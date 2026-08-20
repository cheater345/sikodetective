import 'dart:io';
import '../lib/models/case_generator.dart';
import '../lib/models/siko_case.dart';

const _stop = {'ang', 'ng', 'na', 'sa', 'ay', 'at', 'ko', 'si', 'ni', 'nang', 'may', 'mo', 'sya'};

bool _storyMentions(String story, String option) {
  final s = story.toLowerCase();
  final words = option.toLowerCase().split(RegExp(r'[^a-z0-9à-ÿñ]+')).where((w) => w.length >= 3 && !_stop.contains(w)).toSet();
  if (words.isEmpty) return false;
  return words.where((w) => s.contains(w)).length >= 1;
}

void main() {
  final failures = <String>[];
  final counts = <String, int>{};

  for (int i = 0; i < 300; i++) {
    final c = CaseGenerator(caseId: i, seed: i).generate();
    counts[c.type.name] = (counts[c.type.name] ?? 0) + 1;

    if (c.questions.length != 4) {
      failures.add('[$i] ${c.type} may ${c.questions.length} questions');
      continue;
    }

    for (final q in c.questions) {
      if (q.correctIndex < 0 || q.correctIndex >= q.options.length) {
        failures.add('[$i] ${c.type} | ${q.kind}: correctIndex ${q.correctIndex} out of range (${q.options.length})');
      }
      final seen = <String>{};
      for (final o in q.options) {
        if (!seen.add(o)) {
          failures.add('[$i] ${c.type} | ${q.kind}: duplicate option "$o"');
        }
      }
    }

    // Q1 (easy) — dapat naka-connect sa kwento: ang tamang sagot ay dapat nasa kwento
    final q1 = c.questions[0];
    final correct1 = q1.options[q1.correctIndex];
    if (!_storyMentions(c.story, correct1) && c.type != CaseType.murder) {
      failures.add('[$i] ${c.type}: Q1 correct answer "$correct1" NOT in story');
    }

    // Deception: Q2 (sino ang sinungaling) — dapat nasa kwento ang tamang pangalan
    if (c.type == CaseType.deception) {
      final q2 = c.questions[1];
      final correct2 = q2.options[q2.correctIndex];
      if (!c.story.contains(correct2)) {
        failures.add('[$i] deception: Q2 correct "$correct2" NOT in story');
      }
    }

    // Murder: Q2 (sino ang pumatay) — dapat nasa kwento
    if (c.type == CaseType.murder) {
      final q2 = c.questions[1];
      final correct2 = q2.options[q2.correctIndex];
      if (!c.story.contains(correct2)) {
        failures.add('[$i] murder: Q2 correct "$correct2" NOT in story');
      }
    }
  }

  print('Generated: $counts');
  if (failures.isEmpty) {
    print('ALL VALID');
  } else {
    print('FAILURES (${failures.length}):');
    for (final f in failures.take(30)) {
      print('  $f');
    }
  }

  // Print sample cases for visual inspection
  for (final t in CaseType.values) {
    for (int i = 0; i < 300; i++) {
      final c = CaseGenerator(caseId: i, seed: i).generate();
      if (c.type == t) {
        print('\n===== SAMPLE ${t.name} =====');
        print(c.story);
        print('\n--- QUESTIONS ---');
        for (final q in c.questions) {
          print('${q.kind}: ${q.prompt}');
          for (int j = 0; j < q.options.length; j++) {
            print('  [${j == q.correctIndex ? "CORRECT" : "      "}] ${q.options[j]}');
          }
        }
        break;
      }
    }
  }
}