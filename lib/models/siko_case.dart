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

  CaseQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class SikoCase {
  final int id;
  final String title;
  final String victimName;
  final String victimAge;
  final String victimProfession;
  final String location;
  final String time;
  final String weapon;
  final String motive;
  final String intro;
  final List<Suspect> suspects;
  final String killerName;
  final List<CaseQuestion> questions;

  SikoCase({
    required this.id,
    required this.title,
    required this.victimName,
    required this.victimAge,
    required this.victimProfession,
    required this.location,
    required this.time,
    required this.weapon,
    required this.motive,
    required this.intro,
    required this.suspects,
    required this.killerName,
    required this.questions,
  });

  String get caseCode =>
      'CASE-${id.toString().padLeft(4, '0')} · ${title.toUpperCase()}';
}