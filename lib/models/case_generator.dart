import 'dart:math';
import 'siko_case.dart';

class CaseGenerator {
  final Random _rng;
  final int _caseId;

  CaseGenerator({int? caseId, int? seed})
      : _caseId = caseId ?? 1,
        _rng = Random(seed);

  static const List<String> firstNameM = [
    'Ramon', 'Miguel', 'Andres', 'Marco', 'Carlos', 'Tomas', 'Luis',
    'Paolo', 'Diego', 'Jerome', 'Aldrin', 'Vicente', 'Nestor', 'Rafael', 'Edgar',
  ];
  static const List<String> firstNameF = [
    'Maria', 'Isabel', 'Rosario', 'Luzviminda', 'Teresa', 'Carmen', 'Elena',
    'Sofia', 'Cecilia', 'Lara', 'Jasmine', 'Angela', 'Cristina', 'Marilou', 'Beatriz',
  ];
  static const List<String> surname = [
    'Santos', 'Reyes', 'Cruz', 'Bautista', 'Dela Cruz', 'Garcia', 'Mendoza',
    'Flores', 'Torres', 'Ramos', 'Aquino', 'Gonzales', 'Navarro', 'Salvador', 'Villar',
  ];
  static const List<String> professions = [
    'guro sa haiskul', 'seguridad guwardya', 'nars sa ospital', 'driver ng jeepney',
    'karpintero', 'mananahi', 'barbero', 'kondoktor ng bus', 'kusa ng sari-sari store',
    'pulis retirado', 'chef ng restaurant', 'mekaniko',
  ];
  static const List<String> relations = [
    'kapitbahay', 'pinsan', 'kasamang boarder', 'dating katrabaho', 'bestfriend',
    'asawa ni dating kaibigan', 'kaklase sa seminary', 'suki sa tindahan',
    'kapitbahay na lagi nag-aaway', 'kakilala sa simbahan',
  ];
  static const List<String> locations = [
    'isang lumang bahay sa Sampaloc, Maynila',
    'isang abandonadong warehouse sa Binondo',
    'isang apartment sa Quezon City',
    'ang likuran ng sari-sari store sa Pampanga',
    'isang resort sa Batangas',
    'ang stairs ng tenement sa Tondo',
    'isang cafe sa Makati',
    'isang boarding house sa Baguio',
  ];
  static const List<String> times = [
    'alas-diyes ng gabi', 'alas-tres ng madaling araw', 'alas-singko ng hapon',
    'alas-onse ng umaga', 'alas-otso ng gabi', 'alas-dose ng hatinggabi',
  ];
  static const List<String> weapons = [
    'isang matalim na bolo', 'isang basag na bote', 'isang steel pipe',
    'isang martilyo', 'isang lubid na nylon', 'isang ice pick',
    'isang antigo na ceramic vase', 'isang kusina na kutsilyo',
  ];
  static const List<String> motives = [
    'paghihiganti sa lumang alitan',
    'pagnanakaw ng nakatagong kayamanan',
    'paninibugho sa relasyon',
    'isang mabigat na utang na hindi nabayaran',
    'pagtakpan ang lihim na pakikipagsabwatan',
    'isang away sa mana',
    'pagdamdam sa pagtaksil sa negosyo',
  ];

  static const List<String> behaviors = [
    'napapansing pinagpapawisan at paulit-ulit na tinitignan ang orasan',
    'hindi makatingin nang diretso sa mata ng nagtatanong',
    'nanlalamig ang kamay at mahina ang boses habang sumasagot',
    'palaging ngumingiti nang pigil — parang alam na ang eksaktong mangyayari',
    'mabilis na nagpalit ng kwento nang mahuli sa sablay',
    'kabado ngunit pilit na nagmumukhang kalmado',
  ];

  SikoCase generate() {
    final useF = _rng.nextBool();
    final victimFull = _pickName(useF);

    final suspectNames = <String>{};
    while (suspectNames.length < 4) {
      suspectNames.add(_pickName(_rng.nextBool()));
    }
    final suspectsList = suspectNames.toList();
    final killerIdx = _rng.nextInt(4);

    final profession = _element(professions);
    final location = _element(locations);
    final time = _element(times);
    final weapon = _element(weapons);
    final motive = _element(motives);
    final killerBehavior = _element(behaviors);

    final relPool = List.of(relations)..shuffle(_rng);
    final witnessesNote = _rng.nextBool();

    final suspects = <Suspect>[];
    final otherBehaviors = List.of(behaviors.where((b) => b != killerBehavior))
      ..shuffle(_rng);
    for (int i = 0; i < 4; i++) {
      final isKiller = i == killerIdx;
      suspects.add(Suspect(
        name: suspectsList[i],
        relation: relPool[i],
        alibi: isKiller ? _brokenAlibi(time) : _solidAlibi(),
        behavior: isKiller ? killerBehavior : otherBehaviors[i],
        statement: isKiller
            ? _killerStatement(victimFull, motive, location)
            : _innocentStatement(victimFull, location, witnessesNote),
      ));
    }

    final killer = suspects[killerIdx];

    final intro = _buildIntro(
      victim: victimFull,
      profession: profession,
      location: location,
      time: time,
      weapon: weapon,
    );

    final questions = _buildQuestions(
      suspects: suspects,
      killer: killer,
      motive: motive,
      weapon: weapon,
    );

    return SikoCase(
      id: _caseId,
      title: _titlePicker(),
      victimName: victimFull,
      victimAge: '(${28 + _rng.nextInt(35)} anyos)',
      victimProfession: profession,
      location: location,
      time: time,
      weapon: weapon,
      motive: motive,
      intro: intro,
      suspects: suspects,
      killerName: killer.name,
      questions: questions,
    );
  }

  String _pickName(bool female) {
    final f = female ? firstNameF : firstNameM;
    return '${f[_rng.nextInt(f.length)]} ${surname[_rng.nextInt(surname.length)]}';
  }

  String _element(List<String> l) => l[_rng.nextInt(l.length)];

  String _brokenAlibi(String time) {
    final breaks = [
      'Umalis daw siya ng bahay bandang $time para bumili ng mira, pero sarado pa ang tindahan at kinumpirma ng kapitbahay na sarado pa noon.',
      'Sabi niya nakaupo lang daw siya sa sala buong gabi, pero dalawa ang nakakita sa kanya na lumabas nang nakasumbrero.',
      'Nagkwento siyang tumulong siya sa pagluluto, pero sinabi ng kasambahay na wala siya sa kusina sa oras na iyon.',
      'Sabi niya nanood daw siya ng TV buong gabi, ngunit walang signal ang TV nang oras na iyon — patunay ng isang nagtayong residente.',
    ];
    var t = breaks[_rng.nextInt(breaks.length)];
    if (!t.contains('$time')) {
      t = 'Umalis daw siya nang $time para sa lakad, pero may dalawang nakakita sa kanya na dumaang ibang direksyon papasok sa lugar ng krimen.';
    }
    return t;
  }

  String _solidAlibi() {
    const solids = [
      'May resibo ng pamasahe sa dyip at mga saksi na kasama siya sa kapitbahay',
      'May CCTV mula sa kalapit na tindahan na kita siyang mag-isa sa mga oras ng krimen',
      'Kasama niya ang buong pamilya niya nang kumakain sa hapag noong oras ng krimen',
      'Tinawagan niya ang kanyang kaibigan sa telepono nang eksaktong oras ng krimen',
      'Kinumpirma ng isang kasamahan sa trabaho na kasama siya mag-review buong gabi',
    ];
    return solids[_rng.nextInt(solids.length)];
  }

String _killerStatement(String victim, String motive, String location) {
    final st = [
      '"Medyo matigas ang ulo ng biktima, pero hindi ko kayang makita siyang ganun," sabi niya habang umiiwas ng tingin.',
      '"Huling beses naming nag-usap ni $victim ay noong Monday pa, pero normal pa noon," ani niya, bago biglang madagdag, "Nawalan na nga ng saysay ang lahat sa $location noon."',
      '"Alam ko ang nararamdaman niya tungkol sa mga nangyari sa nakaraan," malamig na sabi niya, ngunit hindi niya maalala ang huling ngiti ng biktima.',
      '"Kung ako ang nasa labas, hindi ko hahayaang mangyari iyan kay $victim," sabi niya, ngunit nang tanungin tungkol sa ginawa niya, bigla siyang nanahimik.',
    ];
    return st[_rng.nextInt(st.length)];
  }

  String _innocentStatement(String victim, String location, bool witnessesNote) {
    final st = [
      '"Si $victim ay may pambihirang pagmamahal sa pamilya, hindi ko maipapaliwanag kung sino ang may kakayahang gawin ito," sabi niyang may halong hinagpis.',
      '"Narinig ko ang sigaw ni $victim mula sa labas, pero laging may mga ingay sa $location," aniya nang may pangamba.',
      '"Siyempre, alam kong may mga taong may sama ng loob. Pero hindi ko akalain na ganito kalalim," sambit niyang nakayuko.',
      '"Nag-usap kami ni $victim tungkol sa mga plano, nakangiti pa siya noong umaga," sabi niyang mapait.',
    ];
    var s = st[_rng.nextInt(st.length)];
    if (witnessesNote) {
      s += ' Nakita siyang naglalakad na malayo sa lugar ng krimen nang oras na iyon.';
    }
    return s;
  }

  String _buildIntro({
    required String victim,
    required String profession,
    required String location,
    required String time,
    required String weapon,
  }) {
    return 'Si $victim, isang $profession, ay natagpuang walang buhay sa $location bandang $time.\n\n'
        'Ang kanyang katawan ay may sugat mula sa $weapon, at bukas pa ang imbestigasyon.\n\n'
        'Apat na tao ang maaaring nasa lugar ng krimen noong mga oras na iyon.\n\n'
        'Narito ang kanilang mga testimonya. Suriin ang bawat isa — ang kanilang alibi, kilos, at mga sinabi — at tukuyin kung sino ang pumatay.';
  }

  List<CaseQuestion> _buildQuestions({
    required List<Suspect> suspects,
    required Suspect killer,
    required String motive,
    required String weapon,
  }) {
    final q = <CaseQuestion>[];

    final nameOptions = suspects.map((s) => s.name).toList()..shuffle(_rng);
    q.add(CaseQuestion(
      prompt: 'Sino sa mga suspek ang pumatay sa biktima?',
      options: nameOptions,
      correctIndex: nameOptions.indexOf(killer.name),
      explanation:
          'Ang alibi ni ${killer.name} ay may butas, at ang kanyang kilos — ${killer.behavior} — ay nagpapakita ng panlilinlang. Siya ang pumatay.',
    ));

    final wrongMotives =
        List.of(motives.where((m) => m != motive))..shuffle(_rng);
    final mOpts = (wrongMotives.take(3).toList()..add(motive))..shuffle(_rng);
    q.add(CaseQuestion(
      prompt: 'Ano ang pinaka-plausibleng motibo sa likod ng krimen?',
      options: mOpts,
      correctIndex: mOpts.indexOf(motive),
      explanation: 'Ang mga pahayag at ebidensya ay tumuturo sa motibong "$motive".',
    ));

    final wrongWeapons =
        List.of(weapons.where((w) => w != weapon))..shuffle(_rng);
    final wOpts = (wrongWeapons.take(3).toList()..add(weapon))..shuffle(_rng);
    q.add(CaseQuestion(
      prompt: 'Anong uri ng armas ang ginamit batay sa ebidensya?',
      options: wOpts,
      correctIndex: wOpts.indexOf(weapon),
      explanation: 'Ang sugat at mga nakitang bakas ay tumutugma sa $weapon.',
    ));

    final behOpts = suspects.map((s) => s.behavior).toList()..shuffle(_rng);
    q.add(CaseQuestion(
      prompt: 'Alin sa mga palatandaan ng kilos ang pinaka-nagpapahiwatig ng pagsisinungaling?',
      options: behOpts,
      correctIndex: behOpts.indexOf(killer.behavior),
      explanation:
          'Ang pattern na "${killer.behavior}" ay tipikal na tugon ng isang taong may alam o nagkasala.',
    ));

    return q;
  }

  String _titlePicker() {
    const t = [
      'Lihim ng Gabi',
      'Ang Pasan na Katotohanan',
      'Mga Balot na Mukha',
      'Huling Mensahe',
      'Anino sa Dilim',
      'Ang Nakatagong Kadahilanan',
      'Pusong Bato',
      'Alaala ng Biktima',
      'Saksi sa Katahimikan',
      'Bakas ng Kahapon',
    ];
    return t[_rng.nextInt(t.length)];
  }
}