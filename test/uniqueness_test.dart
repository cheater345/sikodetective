import '../lib/models/case_generator.dart';
import '../lib/models/siko_case.dart';

void main() {
  // Simulate the app: generate 40 consecutive cases (like a real play session)
  final stories = <String>[];
  final types = <String>[];
  var immediateTypeRepeats = 0;
  var duplicateStories = 0;

  for (int i = 0; i < 40; i++) {
    final c = CaseGenerator(caseId: i).generate();

    types.add(c.type.name);
    if (stories.contains(c.story)) duplicateStories++;
    stories.add(c.story);
  }

  for (int i = 1; i < types.length; i++) {
    if (types[i] == types[i - 1]) immediateTypeRepeats++;
  }

  print('40 cases generated:');
  print(types.join(' → '));
  print('Parehong type nang sunod-sunod: $immediateTypeRepeats');
  print('Ulit na kwento sa buong session: $duplicateStories');

  // Check pool sizes
  final r1 = CaseGenerator(caseId: 1).generate();
  final r2 = CaseGenerator(caseId: 2).generate();
  final r3 = CaseGenerator(caseId: 3).generate();
  final r4 = CaseGenerator(caseId: 4).generate();
  print('Types sa 4 tests: ${[r1.type.name, r2.type.name, r3.type.name, r4.type.name].join(", ")}');

  if (immediateTypeRepeats <= 1 && duplicateStories <= 3) {
    print('UNIQUENESS OK');
  } else {
    print('KELANGAN PANG AYUSIN');
  }
}