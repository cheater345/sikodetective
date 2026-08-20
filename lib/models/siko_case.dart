enum CaseType {
  murder(
    'PAGTITIPUNAN NG KASO',
    'Isang krimen ang naganap. Tukuyin ang pumatay batay sa ebidensya.',
  ),
  morality(
    'MORAL DILEMMA',
    'Isang sitwasyong walang madaling sagot. Ano ang GAGAWIN MO?',
  ),
  deception(
    'PAGTETESTIYA NG SINUNGALING',
    'May sinungaling sa mga saksi. Huliin sila gamit ang ebidensya.',
  );

  final String label;
  final String description;

  const CaseType(this.label, this.description);
}

enum QuestionKind {
  easy('MADALI — Nasa teksto ang sagot'),
  deduction('DEDUCTION — Pagsamahin ang mga pahiwatig'),
  psych('PSYCHOLOGY TEST — Pag-isipan ang tao'),
  mind('MIND TRAP — Hindi ito kung ano ang tila'),
  action('ANO ANG GAGAWIN MO? — Ikaw ang nasa sitwasyon');

  final String label;

  const QuestionKind(this.label);
}

class Suspect {
  final String name;
  final String relation;
  final String alibi;
  final String behavior;
  final String statement;

  Suspect({
    required this.name,
    required this.relation,
    required this.alibi,
    required this.behavior,
    required this.statement,
  });
}

class CaseQuestion {
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final QuestionKind kind;

  CaseQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.kind = QuestionKind.easy,
  });
}

class SikoCase {
  final int id;
  final CaseType type;
  final String title;
  final String story;
  final String resolution;
  final List<CaseQuestion> questions;

  SikoCase({
    required this.id,
    required this.type,
    required this.title,
    required this.story,
    required this.resolution,
    required this.questions,
  });

  String get caseCode =>
      'CASE-${id.toString().padLeft(4, '0')} · ${title.toUpperCase()}';
}