import 'dart:math';
import 'siko_case.dart';

class CaseGenerator {
  final Random _rng;
  final int _caseId;

  CaseGenerator({int? caseId, int? seed})
      : _caseId = caseId ?? 1,
        _rng = Random(seed);

  // ------------------------- shared pools -------------------------
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
    'karpintero', 'mananahi', 'barbero', 'kondoktor ng bus', 'kusa sa sari-sari store',
    'pulis retirado', 'chef ng restaurant', 'mekaniko',
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
  static const List<String> titlesMurder = [
    'Lihim ng Gabi', 'Ang Pasan na Katotohanan', 'Mga Balot na Mukha',
    'Huling Mensahe', 'Anino sa Dilim', 'Ang Nakatagong Kadahilanan',
    'Pusong Bato', 'Alaala ng Biktima', 'Saksi sa Katahimikan', 'Bakas ng Kahapon',
  ];
  static const List<String> titlesMoral = [
    'Ang Pagpili', 'Sa Kabila ng Daan', 'Ang Pabigat na Desisyon',
    'Barya-barya lang', 'Ang Utang na Di Mamamatay', 'Panibagong Umaga',
    'Ang Nakatagong Kabutihan', 'Susi sa Pinto', 'Ang Mahabang Gabi', 'Huling Subok',
  ];
  static const List<String> titlesDeception = [
    'Puso ng Mambabasa', 'Salita ng Saksi', 'Ang Daya sa Detalye',
    'Huli sa Akto', 'Boses ng Katotohanan', 'Ang Ikatlong Kwento',
    'Mukha ng Kasinungalingan', 'Tunay na Salaysay', 'Tabbing ng Mata', 'Ang Sabay na Kwento',
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
    final type = CaseType.values[_rng.nextInt(4)];
    switch (type) {
      case CaseType.murder:
        return _generateMurder();
      case CaseType.morality:
        return _generateMoral();
      case CaseType.deception:
        return _generateDeception();
      case CaseType.riddle:
        return _generateRiddle();
    }
  }

  // ===================== MURDER =====================
  SikoCase _generateMurder() {
    final victim = _pickName(_rng.nextBool());
    final profession = _element(professions);
    final location = _element(locations);
    final time = _element(times);
    final weapon = _element(_murderWeapons);
    final motive = _element(_murderMotives);
    final killerBehavior = _element(behaviors);

    final suspectNames = <String>{victim};
    while (suspectNames.length < 5) {
      suspectNames.add(_pickName(_rng.nextBool()));
    }
    suspectNames.remove(victim);
    final suspectsList = suspectNames.toList();
    final killerIdx = _rng.nextInt(4);

    final relPool = List.of(_relations)..shuffle(_rng);
    final otherBehaviors = List.of(behaviors.where((b) => b != killerBehavior))
      ..shuffle(_rng);
    final suspects = <Suspect>[];
    for (int i = 0; i < 4; i++) {
      final isKiller = i == killerIdx;
      suspects.add(Suspect(
        name: suspectsList[i],
        relation: relPool[i],
        alibi: isKiller ? _brokenAlibi() : _solidAlibi(),
        behavior: isKiller ? killerBehavior : otherBehaviors[i],
        statement: isKiller
            ? _killerStatement(victim)
            : _innocentStatement(victim),
      ));
    }
    final killer = suspects[killerIdx];

    final story = StringBuffer()
      ..writeln('Si $victim, isang $profession, ay natagpuang walang buhay sa $location bandang $time.')
      ..writeln()
      ..writeln('Ang sugat ay mula sa $weapon. Apat na tao ang maaaring nasa lugar ng krimen noong mga oras na iyon, at lahat sila ay kinausap:')
      ..writeln();
    for (final s in suspects) {
      story.write('— ${s.name} (${s.relation}): ${s.statement}\n');
      story.write('   ALIBI: ${s.alibi}\n');
      story.write('   KILOS: ${s.behavior}\n\n');
    }
    story.write('Ang motibo ay pinaniniwalaang: $motive. Sinong pumatay kay $victim?');

    final questions = <CaseQuestion>[];

    // Q1 EASY — direktang nasa teksto
    final q1Opts = [
      location,
      'isang beach sa La Union',
      'isang mall sa Maynila',
      'isang palengke sa Baguio',
    ]..shuffle(_rng);
    questions.add(CaseQuestion(
      kind: QuestionKind.easy,
      prompt: 'Saan natagpuan ang biktima?',
      options: q1Opts,
      correctIndex: q1Opts.indexOf(location),
      explanation: 'Direkta itong nakasulat sa simula ng kwento: $location.',
    ));

    // Q2 DEDUCTION — sino ang pumatay
    final nameOptions = suspects.map((s) => s.name).toList()..shuffle(_rng);
    questions.add(CaseQuestion(
      kind: QuestionKind.deduction,
      prompt: 'Sino sa mga suspek ang pumatay kay $victim?',
      options: nameOptions,
      correctIndex: nameOptions.indexOf(killer.name),
      explanation:
          'Tanging si ${killer.name} ang may alibing may butas, at ang kilos niya (${killer.behavior}) ay naglantad ng panlilinlang. Kinuha ng behavior profiling ang huling patunay: ang isang sinungaling ay laging sobrang "ensayo" o kulang sa detalye — at si ${killer.name} ay may ALIBING OBRA NA DETALYE.',
    ));

    // Q3 PSYCH — cognitive trick: over-detail
    final psychOpts = [
      'Sobra-sobrang detalye na parang inensayo',
      'Mahina ang boses at kinakabahan',
      'Matagal bago sumagot',
      'Madalas tumingin sa kaliwang sulok',
    ]..shuffle(_rng);
    questions.add(CaseQuestion(
      kind: QuestionKind.psych,
      prompt: 'Ano ang PINAKA-MALAKAS na senyales ng pagsisinungaling sa isang alibi?',
      options: psychOpts,
      correctIndex: psychOpts.indexOf('Sobra-sobrang detalye na parang inensayo'),
      explanation:
          'Ayon sa cognitive psychology, ang sobrang detalye ang mas malakas na tanda — kasi ang totoong alaala ay may mga butas, habang ang inimbentong kwento ay inaayos "masyadong perpekto".',
    ));

    // Q4 MIND TRAP — ang "PAANO mo nasabi na si X ang pumatay" — reversal
    final innocent = suspects.firstWhere((s) => s.name != killer.name);
    final q4Opts = [
      'Si ${innocent.name} — kasi ang kaba ay hindi patunay ng pagkakasala',
      'Si ${killer.name} — kasi ang kilos ay patunay na agad',
      'Lahat ng suspek — kasi wala nang pag-asa',
      'Hindi malalaman — kasi ang kilos ay sapat na',
    ]..shuffle(_rng);
    questions.add(CaseQuestion(
      kind: QuestionKind.mind,
      prompt: 'Kung ang tanong ay BINALIGTAD — "Sino ang HINDI mo dapat i-areglo batay sa kilos LANG?" — ang sagot ay...?',
      options: q4Opts,
      correctIndex: q4Opts.indexOf('Si ${innocent.name} — kasi ang kaba ay hindi patunay ng pagkakasala'),
      explanation:
          'Mind trap ito! Madalas mong ituro ang kabado. Pero sabi ng psychology: ang nervousness sa imbestigasyon ay NORMAL at hindi ebidensya. Ang ebidensya (butas sa alibi + over-detail) ang mahalaga — hindi ang kaba.',
    ));

    return SikoCase(
      id: _caseId,
      type: CaseType.murder,
      title: _element(titlesMurder),
      story: story.toString(),
      resolution:
          'SI ${killer.name.toUpperCase()} ANG PUMATAY kay $victim.\n\n'
          'Motibo: $motive\nSandata: $weapon\n'
          'Ang kanyang alibi ay may butas, at ang kilos na "${killer.behavior}" ay nagtraydor sa kanya — kasama ang sobrang-detalyeng kwento na tanda ng inensayong kasinungalingan.',
      questions: questions,
    );
  }

  static const List<String> _murderWeapons = [
    'isang matalim na bolo', 'isang basag na bote', 'isang steel pipe',
    'isang martilyo', 'isang lubid na nylon', 'isang ice pick',
    'isang antigong ceramic vase', 'isang kusinang kutsilyo',
  ];
  static const List<String> _murderMotives = [
    'paghihiganti sa lumang alitan', 'pagnanakaw ng nakatagong kayamanan',
    'paninibugho sa relasyon', 'isang mabigat na utang na hindi nabayaran',
    'pagtakpan ang lihim na pakikipagsabwatan', 'isang away sa mana',
    'pagdamdam sa pagtaksil sa negosyo',
  ];
  static const List<String> _relations = [
    'kapitbahay', 'pinsan', 'kasamang boarder', 'dating katrabaho', 'bestfriend',
    'asawa ni dating kaibigan', 'kaklase sa seminary', 'suki sa tindahan',
    'kapitbahay na lagi nag-aaway', 'kakilala sa simbahan',
  ];

  // ===================== MORAL DILEMMA =====================
  SikoCase _generateMoral() {
    final dilemmas = [
      _MoralDilemma(
        tagline: 'May nakita kang pera na nahulog ng isang matanda sa jeep.',
        characters: 'Ikaw, isang matandang babae na may dalang grocery',
        setup: 'Nahulog ang 500-piso ng matandang babae sa sahig ng jeep nang hindi niya napansin. Tumingin ka sa paligid — walang ibang nakakita.',
        q1Prompt: 'Ayon sa kwento, ano ang nahulog ng matandang babae?',
        q1Options: [
          '500-piso na hindi niya napansing nahulog',
          '100-piso na kusang inilapag niya',
          'isang cellphone na luma',
          'isang susi ng bahay',
        ],
        q1Correct: 0,
        options: [
          'Kunin ang pera at ibigay sa kanya',
          'Kunin ang pera at itago',
          'Ituro sa kanya na may nahulog',
          'Iuli ang jeep kahit huli ka sa trabaho para habulin siya',
        ],
        correctIdx: 0,
        worstIdx: 1,
        psychTerm: 'Integrity',
        why: 'Ito ang pinaka-mabilis at makatao. Ibinabalik ang pera nang walang dagdag na gulo — walang kailangang maghabol, at malinaw ang intensyon.',
        worstWhy: 'Ang pagtago ng 500-piso ay pagnanakaw, kahit gaano pa kabilis ang pangyayari. Ang ganitong desisyon ay sinisira ang iyong integridad nang hindi mo namamalayan.',
      ),
      _MoralDilemma(
        tagline: 'Nalaman mo na ang bestfriend mo ay niloloko ang kanyang jowa.',
        characters: 'Ikaw, ang bestfriend, at ang jowa',
        setup: 'May ebidensya kang nakita: chats na nagpapakita na dalawang-timpalad ang bestfriend mo. Ang jowa niya ay mabait at nangunguliling kamusta sa iyo kahit magulo ang buhay niya.',
        q1Prompt: 'Ayon sa kwento, ano ang ebidensyang nakita mo tungkol sa bestfriend mo?',
        q1Options: [
          'Chats na nagpapakita na dalawang-timpalad siya',
          'Isang larawan na kasama ng iba',
          'Tumawag siyang may lasing na boses',
          'Isang balita sa kapitbahay',
        ],
        q1Correct: 0,
        options: [
          'Sabihin na agad sa jowa ang totoo',
          'Kausapin ang bestfriend at ibigay ang chance na siya mismo ang magsabi',
          'Manahimik — hindi mo ito laban',
          'I-post ang chats sa social media para mapahiya',
        ],
        correctIdx: 1,
        worstIdx: 3,
        psychTerm: 'Confrontation',
        why: 'Sa psychology ng "confrontation", ang pinaka-angkop ay bigyan ang kaibigan ng chance na i-correct — na may ultimatum. Pinapangalagaan nito ang hustisya nang hindi tinatapos ang tao bilang ang namamagitan.',
        worstWhy: 'Ang pag-post ng pribadong chats ay paninira ng dignidad — hindi hustisya. Ang pampublikong kahihiyan ay gumagawa ng pangalawang biktima at sinisira ang tiwala ng lahat sa iyo.',
      ),
      _MoralDilemma(
        tagline: 'Nakita mong nandadaya ang kaklase mo sa eksam.',
        characters: 'Ikaw, ang kaklase, at ang guro',
        setup: 'Malapit sa iyo ang kaklase mo na nagtitingin ng papel ng katabi. Hindi siya gumagawa ng ingay, at nakalusot siya ng dalawang beses.',
        q1Prompt: 'Ayon sa kwento, ilang beses nakalusot ang kaklase mong nandadaya?',
        q1Options: [
          'Dalawang beses',
          'Isang beses',
          'Tatlong beses',
          'Hindi siya nakalusot kahit isang beses',
        ],
        q1Correct: 0,
        options: [
          'Itaas ang kamay at iulat siya sa harap ng lahat',
          'Pumalakpak nang palihim para mabalik ang atensyon ng guro',
          'Sumbungin sa akin ang guro pagkatapos ng klase',
          'Wag pansinin — hindi ka responsable sa kanya',
        ],
        correctIdx: 2,
        worstIdx: 3,
        psychTerm: 'Responsibility',
        why: 'Ang psychological insight: ang pag-ulat ay mas mabisa at makatwiran kung PINAGKAKAIWANAN ang pampublikong kahihiyan. Pinapangalagaan nito ang entidad ng kaklase at binibigyan ng pagkakataong magbago.',
        worstWhy: 'Kapag may alam ka at nanahimik ka, kasabwat ka na. Ang "walang gusto kaguluhan" ay isa ring desisyon — ang hindi pagpili ay pagpili rin.',
      ),
      _MoralDilemma(
        tagline: 'May isang tao ang naghihingalo sa kalsada at ikaw lang ang tao.',
        characters: 'Ikaw, isang nasugatan, at ang paligid',
        setup: 'Sa hatinggabi, may nakita kang lalaking nadapa at hindi kumikibo sa kalsada. Wala kang load sa phone at walang tao sa paligid. May sari-sari store na dalawang bloke ang layo.',
        q1Prompt: 'Ayon sa kwento, bakit hindi ka agad makatawag ng tulong?',
        q1Options: [
          'Wala kang load sa phone at walang tao sa paligid',
          'Walang signal kahit saan',
          'Nawasak ang phone mo',
          'Takot kang makilala ng pulis',
        ],
        q1Correct: 0,
        options: [
          'Tumakbo sa sari-sari store at humingi ng tulong',
          'Iwanan siya — siguradong darating ang iba',
          'Ituloy ang paglalakad pero sabihin sa kapitbahay',
          'Kalmahin siya at antayin ang tulong na walang ginagawa',
        ],
        correctIdx: 0,
        worstIdx: 1,
        psychTerm: 'Bystander effect',
        why: 'Ito ang "bystander effect" — mas lalong HINDI tutulong ang tao kapag marami ang nasa paligid kasi iniisip nilang may ibang gagawa. Sa sitwasyong ito, ikaw ang tanging tao — ang responsibilidad ay nasa iyo, at ang mabilis na paghingi ng tulong ang nagliligtas ng buhay.',
        worstWhy: 'Kapag may nasugatan, ang bawat minuto ay mahalaga. Ang "una akong lalayo at hindi titingin" ay hindi kakulangan ng panahon — ito ay desisyon. Iwanan ang tao sa kalagitnaan ng daan ay mapapabayaan ang kanyang buhay.',
      ),
      _MoralDilemma(
        tagline: 'Nalaman mong may iligal na transaksyon ang pinsan mo.',
        characters: 'Ikaw, ang pinsan, at ang negosyo ng pamilya',
        setup: 'Pamilya ang negosyo ng iyong pinsan na ginagamit bilang front ng iligal na lending. Araw-araw kang nakakakita ng mga pamilya na nasisira dahil sa mataas na tubo. Mahal mo ang pinsan mo at tumutulong siya sa pamilya.',
        q1Prompt: 'Ayon sa kwento, ano ang ginagamit na front ng iligal na transaksyon ng pinsan mo?',
        q1Options: [
          'Ang negosyo ng pamilya',
          'Isang bodega sa probinsya',
          'Isang sasakyan na paupahan',
          'Isang bar sa kanto',
        ],
        q1Correct: 0,
        options: [
          'Iulat sa awtoridad',
          'Makipag-usap sa kanya at magbigay ng ultimatum',
          'Manahimik — nagsisilbi rin siya sa pamilya',
          'Mag-invest para palakihin ang negosyo',
        ],
        correctIdx: 1,
        worstIdx: 3,
        psychTerm: 'Moral courage',
        why: 'Ang tamang hakbang ay hindi palaging iulat kaagad. Una, bigyan siya ng pagkakataong magbago. Kung hindi siya makikinig at may ebidensya ka na, saka ka mag-ulat — ito ang pag-aagaw sa "grey zone" ng moralidad: pakikisama vs. responsibilidad.',
        worstWhy: 'Ang pag-invest sa ilegal na negosyo ay ginagawa kang ganap na kasabwat — hindi na lamang saksi. Ang perang kikitain ay mula sa biktima ng pag-aapuhap ay "maruming pera" na magpapaibig sa iyo sa sistema.',
      ),
    ];

    final d = dilemmas[_rng.nextInt(dilemmas.length)];

    final story = '${d.tagline}\n\n'
        'Sitwasyon: ${d.setup}\n\n'
        '${d.characters}.\n\n'
        'ANO ANG GAGAWIN MO? Pumili ng isang plano ng aksyon.';

    final questions = <CaseQuestion>[];

    // Q1 EASY — nagbabasang mabuti (nakabatay sa mismong dilemma)
    final q1Opts = List.of(d.q1Options)..shuffle(_rng);
    final q1Correct = d.q1Options[d.q1Correct];
    questions.add(CaseQuestion(
      kind: QuestionKind.easy,
      prompt: d.q1Prompt,
      options: q1Opts,
      correctIndex: q1Opts.indexOf(q1Correct),
      explanation:
          'Madaling tanong ito para i-ground ka sa mismong detalye ng kwento — may mga tao kasi na sumasagot batay sa palagay, hindi sa teksto.',
    ));

    // Q2 DEDUCTION — aling opsyon ang hindi makatao
    final humane = d.options[d.correctIdx];
    final humaneOpts = List.of(d.options)..shuffle(_rng);
    questions.add(CaseQuestion(
      kind: QuestionKind.deduction,
      prompt: 'Alin sa mga opsyon ang KINUKUHA ang mas makatao at mabilis na paraan?',
      options: humaneOpts,
      correctIndex: humaneOpts.indexOf(humane),
      explanation: d.why,
    ));

    // Q3 PSYCH — principle na naka-connect sa dilemma mismo
    final psychTerm = d.psychTerm;
    final psychOpts = [
      psychTerm,
      'Cognitive dissonance',
      'Halo effect',
      'Priming',
    ]..shuffle(_rng);
    questions.add(CaseQuestion(
      kind: QuestionKind.psych,
      prompt: 'Aling konsepto sa psychology ang pinag-uusapan sa desisyong ito?',
      options: psychOpts,
      correctIndex: psychOpts.indexOf(psychTerm),
      explanation:
          'Psychology insight: ${d.why} Ang prinsipyong ito ("$psychTerm") ang gumagabay sa pagpili ng mas makataong aksyon.',
    ));
    final worst = d.options[d.worstIdx];
    final worstOpts = List.of(d.options)..shuffle(_rng);
    questions.add(CaseQuestion(
      kind: QuestionKind.mind,
      prompt: 'Mind trap: Kung ang tanong ay binaligtad — "ANO ANG PINAKA-MALI NA DESISYON?" — alin ang pipiliin mo?',
      options: worstOpts,
      correctIndex: worstOpts.indexOf(worst),
      explanation:
          'Baligtarin ang pananaw! Minsan mas madaling alamin ang TAMANG desisyon kung iisipin mo kung alin ang malinaw na mali. Dito, ang pinakamali ay: $worst.\n\n${d.worstWhy}',
    ));

    return SikoCase(
      id: _caseId,
      type: CaseType.morality,
      title: _element(titlesMoral),
      story: story,
      resolution:
          'Ang pinaka-angkop na hakbang ay: $humane.\n\n${d.why}\n\n'
          'Sa mga moral dilemma, hindi laging may PERPEKTONG sagot — ngunit laging may sagot na mas makatao. Iyan ang sikolohiya ng mabuting desisyon.',
      questions: questions,
    );
  }

  // ===================== DECEPTION =====================
  SikoCase _generateDeception() {
    final scenes = [
      _DeceptionScene(
        event: 'pagnanakaw ng pera sa tindahan',
        places: [
          'isang sari-sari store sa Pampanga',
          'isang tindahan ng mga de-asiso sa Cavite',
          'isang mini-grocery sa Quezon City',
          'isang palengke sa Batangas',
        ],
        whoInformed: 'may-ari ng tindahan',
        trueDetail: 'ang tindahan ay SARADO at NAKA-LOCK buong araw, nang walang kahit isang nasirang kandado',
        liarClaim: 'bukas ang pinto ng tindahan nang dumating siya at nakita niyang may pumasok',
        q1Wrongs: [
          'bukas pa ang tindahan nang mga oras na iyon',
          'may CCTV ang tindahan na malinaw ang rekord',
          'may pumasok sa tindahan at walang nasira',
        ],
      ),
      _DeceptionScene(
        event: 'pagbasag ng isang malaking bintana sa apartment',
        places: [
          'isang apartment sa Quezon City',
          'isang tenement sa Tondo',
          'isang boarding house sa Baguio',
          'isang condo unit sa Makati',
        ],
        whoInformed: 'kasero ng apartment',
        trueDetail: 'ang bintana ay nabasag mula SA LOOB ng unit — kumalat sa loob ang mga piraso ng baso',
        liarClaim: 'nabasag ang bintana mula sa labas ng isang inihagis na bato',
        q1Wrongs: [
          'nabasag ang bintana mula sa labas ng malakas na hangin',
          'tumalon sa bintana ang isang magnanakaw',
          'basag na ang bintana bago pa dumating ang nanitira',
        ],
      ),
      _DeceptionScene(
        event: 'pagnanakaw ng isang sasakyan sa parking lot',
        places: [
          'isang mall parking sa Maynila',
          'isang parking ng ospital sa Parañaque',
          'isang resident parking sa Mandaluyong',
          'isang parking ng paliparan sa Pasay',
        ],
        whoInformed: 'guwardya ng parking lot',
        trueDetail: 'Kumpleto ang CCTV ng parking at WALANG sasakyan ang lumabas ng gate nang mga oras na iyon',
        liarClaim: 'nakita niyang lumabas ng gate ang sasakyan nang mga oras na iyon',
        q1Wrongs: [
          'may CCTV ang parking ngunit sira ang lahat ng camera',
          'maraming sasakyan ang lumabas ng gate nang mga oras na iyon',
          'walang CCTV sa parking kaya walang rekord',
        ],
      ),
    ];
    final scene = scenes[_rng.nextInt(scenes.length)];
    final place = _element(scene.places);
    final time = _element(times);

    final people = <String>{};
    while (people.length < 4) {
      people.add(_pickName(_rng.nextBool()));
    }
    final pList = people.toList();
    final liarIdx = _rng.nextInt(4);
    final liarBehavior = _element(behaviors);
    final otherBehaviors = List.of(behaviors.where((b) => b != liarBehavior))
      ..shuffle(_rng);

    final witnesses = <Suspect>[];
    for (int i = 0; i < 4; i++) {
      final isLiar = i == liarIdx;
      witnesses.add(Suspect(
        name: pList[i],
        relation: 'saksi',
        alibi: isLiar ? scene.liarClaim : scene.trueDetail,
        behavior: isLiar ? liarBehavior : otherBehaviors[i],
        statement: isLiar
            ? 'Pahayag: "${scene.liarClaim[0].toUpperCase()}${scene.liarClaim.substring(1)}."'
            : (_rng.nextBool()
                ? 'Pahayag: "Hindi ko masyadong nakita — madilim at gulo-gulo na noon."'
                : 'Pahayag: "Narinig ko ang ingay, pero nakasara ang pinto ng bahay ko."'),
      ));
    }
    final liar = witnesses[liarIdx];

    final story = StringBuffer()
      ..writeln('Nangyari ang ${scene.event} sa $place bandang $time.')
      ..writeln('Isang mahalagang detalye ang inilabas ng ${scene.whoInformed}: ${scene.trueDetail}.')
      ..writeln('Apat na saksi ang kinausap:')
      ..writeln();
    for (final w in witnesses) {
      story.write('— ${w.name}: ${w.statement}\n');
      story.write('   DETALYE: ${w.alibi}\n');
      story.write('   KILOS: ${w.behavior}\n\n');
    }
    story.write('Sino ang nagsisinungaling?');

    final questions = <CaseQuestion>[];

    // Q1 EASY — tungkol sa mismong scene
    final q1Opts = [scene.trueDetail, ...scene.q1Wrongs]..shuffle(_rng);
    questions.add(CaseQuestion(
      kind: QuestionKind.easy,
      prompt: 'Ano ang mahalagang detalye na inilabas ng ${scene.whoInformed}?',
      options: q1Opts,
      correctIndex: q1Opts.indexOf(scene.trueDetail),
      explanation: 'Nakasulat mismo sa teksto: ${scene.trueDetail}.',
    ));

    // Q2 DEDUCTION — sino ang sinungaling
    final nameOpts = witnesses.map((w) => w.name).toList()..shuffle(_rng);
    questions.add(CaseQuestion(
      kind: QuestionKind.deduction,
      prompt: 'Sino sa mga saksi ang nagsisinungaling?',
      options: nameOpts,
      correctIndex: nameOpts.indexOf(liar.name),
      explanation:
          'Si ${liar.name} lang ang nagsabing "${liar.alibi}" — pero napatunayan ng ${scene.whoInformed} na ${scene.trueDetail}! Direktang sumasalungat ito sa facts. Ang kilos niya ay: ${liar.behavior}.',
    ));

    // Q3 PSYCH
    questions.add(CaseQuestion(
      kind: QuestionKind.psych,
      prompt: 'Ano ang mas malakas na ebidensya — ang kaba ng saksi o ang CONTRADICTION sa detalye?',
      options: [
        'Ang contradiction — dahil ang kaba ay hindi patunay',
        'Ang kaba — dahil laging totoo ang takot',
        'Parehong mahalaga — hinding masusukat',
        'Ang boses — dahil naririnig mo',
      ],
      correctIndex: 0,
      explanation:
          'Ang kaba ay hindi ebidensya; normal lang na kabahan ang sinuman habang kinakausap ng pulis. Ang contradiction ng STATEMENT laban sa FACT ay ebidensya. Yan ang principle na "behavior" vs "consistency".',
    ));

    // Q4 MIND TRAP
    final truthTeller = witnesses.firstWhere((w) => w.name != liar.name);
    questions.add(CaseQuestion(
      kind: QuestionKind.mind,
      prompt: 'Mind trap: Kung sabihin mo na "ang makulit na saksi ay si ${truthTeller.name} kasi wala siyang nakita" — anong logical error ang ginagawa mo?',
      options: [
        'Hasty generalization — mali ang konklusyon sa kawalan ng detalye',
        'Confirmation bias — hanap ang patunay ng hinala',
        'Sunk cost — hindi bitawan ang nasabing teorya',
        'Appeal to authority — naniniwala sa pulis',
      ],
      correctIndex: 0,
      explanation:
          'Mind trap: ang "pagod na walang detalye" ay NORMAL (madilim, nakasara ang pinto). Ang pag-aakalang walang detalye = may itinatago ay generalization. Ang ebidensya lang ang dapat magpatunay — hindi ang absent ng detalye.',
    ));

    return SikoCase(
      id: _caseId,
      type: CaseType.deception,
      title: _element(titlesDeception),
      story: story.toString(),
      resolution:
          'SI ${liar.name.toUpperCase()} ANG NAGSINUNGALING.\n\n'
          'Ang kanyang pahayag ("${liar.alibi}") ay direktang sumasalungat sa napatunayang detalye (${scene.trueDetail}). Ang kilos niya — ${liar.behavior} — ay suportado lamang, HINDI ang pangunahing ebidensya. Sa totoong investigation, ang say against the record ang bumubulag sa mga pulis.',
      questions: questions,
    );
  }

  // ===================== RIDDLE / BRAIN TEASER =====================
  SikoCase _generateRiddle() {
    final riddles = _riddles;
    final r = riddles[_rng.nextInt(riddles.length)];

    final questions = <CaseQuestion>[];

    // Q1 EASY — naka-connect sa kwento
    final q1Opts = List.of(r.q1Options)..shuffle(_rng);
    final q1Correct = r.q1Options[r.q1Correct];
    questions.add(CaseQuestion(
      kind: QuestionKind.easy,
      prompt: r.q1Prompt,
      options: q1Opts,
      correctIndex: q1Opts.indexOf(q1Correct),
      explanation: 'Nakasulat mismo sa teksto: $q1Correct.',
    ));

    // Q2 DEDUCTION — ang aktwal na sagot
    final mainOpts = List.of(r.options)..shuffle(_rng);
    final mainCorrect = r.options[r.correctIdx];
    questions.add(CaseQuestion(
      kind: QuestionKind.deduction,
      prompt: r.prompt,
      options: mainOpts,
      correctIndex: mainOpts.indexOf(mainCorrect),
      explanation: r.answerExplanation,
    ));

    // Q3 PSYCH — ang prinsipyong sikolohikal
    final psychOpts = List.of(r.psychOptions)..shuffle(_rng);
    final psychCorrect = r.psychOptions[r.psychCorrect];
    questions.add(CaseQuestion(
      kind: QuestionKind.psych,
      prompt: r.psychPrompt,
      options: psychOpts,
      correctIndex: psychOpts.indexOf(psychCorrect),
      explanation: r.psychExplain,
    ));

    // Q4 MIND TRAP — ang tunay na bitag
    final q4Opts = List.of(r.q4Options)..shuffle(_rng);
    final q4Correct = r.q4Options[r.q4Correct];
    questions.add(CaseQuestion(
      kind: QuestionKind.mind,
      prompt: r.q4Prompt,
      options: q4Opts,
      correctIndex: q4Opts.indexOf(q4Correct),
      explanation: r.q4Explain,
    ));

    return SikoCase(
      id: _caseId,
      type: CaseType.riddle,
      title: r.title,
      story: r.story.trim().endsWith('?')
          ? r.story
          : '${r.story}\n\n${r.prompt}',
      resolution: '$mainCorrect\n\n${r.answerExplanation}',
      questions: questions,
    );
  }

  static final List<_Riddle> _riddles = [
    _Riddle(
      title: 'Ang Tatlong Pinto',
      story: 'Isang lalaki ang nakatakas sa presinto at may tatlong pinto siyang pagpipilian para makaiwas sa mga humahabol. Ang laman ng unang pinto ay mga retiradong sundalo. Ang laman ng ikalawang pinto ay mga pulis. Ang ikatlong pinto naman ay puno ng mga tigre na hindi pa kumakain sa loob ng tatlong taon.',
      q1Prompt: 'Ayon sa kwento, ano ang nasa ikatlong pinto?',
      q1Options: [
        'mga tigre na hindi pa kumakain ng tatlong taon',
        'mga retiradong sundalo',
        'mga pulis',
        'mga asong labanan',
      ],
      q1Correct: 0,
      prompt: 'Saan dapat pumasok at magtago ang nakatakas na lalaki?',
      options: [
        'Sa ikatlong pinto — patay na ang tigre dahil 3 taon nang walang makain',
        'Sa unang pinto — matamlay na ang mga retiradong sundalo',
        'Sa ikalawang pinto — pulis ang humahabol kaya ligtas siya',
        'Wala sa tatlo — dapat lumabas na lang siya at tumakbo',
      ],
      correctIdx: 0,
      answerExplanation:
          'Ang mahalagang linya ay "mga tigre na hindi pa kumakain sa loob ng tatlong taon" — walang tigre ang makakaligtas nang 3 taon nang walang pagkain, kaya PATAY na sila. Ang ikatlong pinto ang pinakaligtas. Ang nagliligaw sa karamihan ay ang takot sa salitang "tigre" bago pa man isipin ang lohika ng detalye.',
      psychPrompt: 'Aling psychological reaction ang nagpapadulas sa tao na piliin agad ang isa pang pinto nang hindi iniisip ang mga salita?',
      psychOptions: [
        'Emotional response — agad na takot sa salitang "tigre"',
        'Confirmation bias — hanap lang ng patunay sa unang hinala',
        'Sunk cost — hindi kayang bitiwan ang nasabing plano',
        'Halo effect — tingin sa tao bilang mabuti dahil sa itsura',
      ],
      psychCorrect: 0,
      psychExplain:
          'Ang salitang "tigre" ay nagti-trigger ng takot bago pa man magtrabaho ang lohika. Iyan ang emosyonal na tugon — ang gut reaction na siyang dahilan kung bakit marami ang nagkakamali: kumikilos sila sa takot, hindi sa pagbabasa ng bawat detalye.',
      q4Prompt: 'Ang tunay na BITAG sa palaisipang ito ay...',
      q4Options: [
        'Ang magmadali at paniwalaan ang unang naiisip',
        'Ang sobrang pag-iisip sa mga salita',
        'Ang pagtatanong sa mga humahabol',
        'Ang pag-aatubiling pumili',
      ],
      q4Correct: 0,
      q4Explain:
          'Ang bitag ay ang UNANG reaksyon: kapag narinig mo ang "tigre," agad kang natatakot at walang nang iniisip pang iba. Kung titigil ka at babasahin mo nang mabuti ang buong detalye ("tatlong taong hindi kumain"), malalaman mong ang ikatlong pinto ay walang panganib. Ang pagmamadali ang pumapatay ng lohika.',
    ),
    _Riddle(
      title: 'Ang Posporo sa Dilim',
      story: 'Madilim ang isang silid. Meron lamang kandila, isang lamparang de-langis, at isang gas stove. Mayroon kang ISANG posporo lang. Ano ang KAUNANG-una mong sisindihan upang makakita ka sa dilim?',
      q1Prompt: 'Ayon sa kwento, ano ang mga nakikita mo sa madilim na silid?',
      q1Options: [
        'kandila, lamparang de-langis, at gas stove',
        'posporo at flashlight',
        'mga kandila at flashlight',
        'gas stove at kalan',
      ],
      q1Correct: 0,
      prompt: 'Ano ang unang dapat mong sisindihan?',
      options: [
        'Ang posporo — dahil wala kang ibang apoy para sisindihin ang iba',
        'Ang gas stove — para maliwanagan agad',
        'Ang lamparang de-langis — para buo ang ilaw',
        'Ang kandila — para maliit lang ang apoy',
      ],
      correctIdx: 0,
      answerExplanation:
          'Ang sagot: ang posporo mismo ang unang sisindihin — dahil yan ang PINAGMULAN ng apoy. Hindi mo masisindihan ang kandila, lampara, o stove kung hindi mo muna sisindihin ang posporo. Susundan mo ang sunod-sunod na hakbang: posporo → apoy → ilaw. Ang trick dito ay hindi ka tumatalon agad sa "ilaw" kundi iniisip mo kung paano ka dadating doon.',
      psychPrompt: 'Anong mindset ang hinahanap sa palaisipang ito?',
      psychOptions: [
        'Paatras na pag-iisip — simulan ang pinagmulan ng apoy bago ang resulta',
        'Madaling pag-iisip — kunin agad ang pinakamaliwanag',
        'Pag-iisip na pang-takot — matakot sa dilim bago pa man mag-isip',
        'Pagtulad sa nakagawian — parang laging kandila ang unang sisindihin',
      ],
      psychCorrect: 0,
      psychExplain:
          'Ang palaisipang ito ay tungkol sa sequential thinking — sinisimulan mo sa pinagmulan ng apoy (ang posporo) bago ang layunin (ilaw). Ang mga taong naiipit ay tumatalon agad sa "ilaw" (resulta) nang hindi iniisip ang maliit na hakbang bago nito.',
      q4Prompt: 'Ang bitag dito ay ang pag-aakalang…',
      q4Options: [
        'may iba pang mapagkukunan ng apoy bukod sa posporo',
        'ang kandila ang pinakamaliit na sisindihin',
        'ang gas stove ang pinakamabilis umilaw',
        'laging mas madilim sa gabi kaysa sa umaga',
      ],
      q4Correct: 0,
      q4Explain:
          'Ang bitag: karamihan ay sinasagot ang "kandila" o "lampara" dahil iniisip nila ang layunin (ilaw) imbes na ang hakbang. Ang TOTOONG unang hakbang ay ang pinagmulan ng apoy — ang posporo. Kapag wala kang sisindihang posporo, wala kang magagamit na apoy para sa lahat ng iba.',
    ),
    _Riddle(
      title: 'Ang Tandang sa Bubong',
      story: 'Isang tandang (lalaking manok) ang nakatayo sa tuktok ng isang bubong na nakaharap sa kanluran. Nangitlog ito. Saang direksyon babagsak ang itlog?',
      q1Prompt: 'Ayon sa kwento, saan nakaharap ang tandang?',
      q1Options: [
        'sa kanluran',
        'sa silangan',
        'sa hilaga',
        'sa timog',
      ],
      q1Correct: 0,
      prompt: 'Saang direksyon babagsak ang itlog?',
      options: [
        'Hindi ito babagsak — walang nangitlog dahil lalaki ang tandang',
        'Sa kanluran — kung saan nakaharap siya',
        'Sa silangan — kabaligtaran ng kanyang harapan',
        'Pababa — papunta sa lupa',
      ],
      correctIdx: 0,
      answerExplanation:
          'Ang trick ay nasa isang salita: "tandang" ay lalaking manok — HINDI ito pwedeng mangitlog. Ang mga taong nagmamadali ay sumasagot agad ng direksyon habang iniisip ang itlog nang hindi napapansin na ang tandang ay lalaki.',
      psychPrompt: 'Ano ang dahilan kung bakit marami ang nakakaligtaan ang sagot?',
      psychOptions: [
        'Assumption — hindi nila iniisip na ang tandang ay lalaki',
        'Confirmation bias — hanap lang ng direksyon',
        'Halo effect — tingin sa manok ay pangkalahatan',
        'Priming — naaalala lang ang mga normal na pangingitlog',
      ],
      psychCorrect: 0,
      psychExplain:
          'Ang assumption error: tinatanong mo ang iyong sarili ng "saang direksyon babagsak" habang hindi mo ini-check kung "pwede bang mangitlog ang tandang?" Ang epektibong pag-solve ay ang pagtigil at pagtawag sa bawat premise bago sumagot.',
      q4Prompt: 'Ang bitag dito ay ang biglang pag-focus sa...',
      q4Options: [
        'direksyon imbes na sa posibilidad ng pangyayari',
        'tandang, imbes na sa ibang mga manok',
        'bubong, imbes na sa loob ng bahay',
        'kanluran, imbes na sa silangan',
      ],
      q4Correct: 0,
      q4Explain:
        'Ang bitag: ang kwento ay nilagyan ng "nakaharap sa kanluran" para sabihin sa iyo kung saan ang pwesto — para ma-focus ang isip mo sa direksyon at kumalimot ka sa mas mahalagang detalye: ang tandang ay hindi nangingitlog. Ang layunin ng naka-coding na detalye ay iligaw ka sa lohikal na impossibility.',
    ),
    _Riddle(
      title: 'Ang Lalaki sa Elevator',
      story: 'Isang lalaki ang nakatira sa ika-10 palapag ng isang building. Tuwing umaga, sumasakay siya ng elevator papunta sa ground floor para magtrabaho. Tuwing gabi, sumasakay siya ng elevator pero bumababa siya sa ika-7 na palapag at nilalakad niya ang 3 palapag papunta sa kanyang apartment. Bakit hindi siya sumakay hanggang sa ika-10?',
      q1Prompt: 'Saang palapag nakatira ang lalaki?',
      q1Options: [
        'ika-10 palapag',
        'ika-7 palapag',
        'ika-3 palapag',
        'ground floor',
      ],
      q1Correct: 0,
      prompt: 'Bakit laging sa ika-7 palapag siya bumababa patungong bahay?',
      options: [
        'Pandak siya — hindi niya maabot ang pindutan ng ika-10',
        'Mahina ang elevator sa itaas ng ika-7',
        'Madilim ang hallway sa ika-8 pataas',
        'Tumatakas siya sa katabi sa ika-8',
      ],
      correctIdx: 0,
      answerExplanation:
          'Ang sagot: pandak ang lalaki at hindi niya maabot ang pindutan ng ika-10 palapag sa elevator. Pwede niya itong maabot nang umaga kapag bababa siya (ground floor button ay nasa baba at naaabot), pero hindi niya maabot ang ika-10 sa gabi. Ang palaisipang ito ay test ng observasyon sa mga limitasyon ng pisikal na mundo.',
      psychPrompt: 'Anong uri ng pag-iisip ang hinahanap dito?',
      psychOptions: [
        'Batas ng pisikal na limitasyon — hindi lahat ay tungkol sa sikolohikal na lalim',
        'Malalim na conspiracy — may nakatagong balak',
        'Teknikal na sira ng elevator',
        'Sosyal na takot sa kapitbahay',
      ],
      psychCorrect: 0,
      psychExplain:
          'Ang palaisipang ito ay tungkol sa Occam\'s razor — ang pinaka-simpleng paliwanag na akma sa lahat ng detalye ay ang pinakamalamang. Ang pandak na lalaki ay isang simpleng pisikal na katotohanan na hindi natin iniisip dahil hindi natin ito "nakikita" sa kwento.',
      q4Prompt: 'Ang bitag dito ay ang pag-aakalang...',
      q4Options: [
        'ang dahilan ay kailangang sikolohikal o teknikal na kumplikado',
        'laging sira ang elevator',
        'may kasama siya sa elevator tuwing gabi',
        'ang ground floor button ay mas mahirap abutin',
      ],
      q4Correct: 0,
      q4Explain:
        'Ang bitag: kapag nakakita tayo ng misteryo, naghahanap tayo ng komplikadong dahilan — pero para sa palaisipang ito, ang sagot ay simple at pisikal. Ang paghanap ng "lalim" kung saan walang lalim ay ang tunay na hadlang sa pag-solve.',
    ),
    _Riddle(
      title: 'Ang Tatlong Switch',
      story: 'Sa isang kwarto ay may tatlong bumbilya. Sa labas ay may tatlong switch na nakakonekta sa mga ito. Makakapasok ka lang sa kwarto ng ISANG beses. Paano mo matutuklasan kung aling switch ang kumokontrol sa aling bumbilya?',
      q1Prompt: 'Ilang beses ka lang makakapasok sa kwarto?',
      q1Options: [
        'Isang beses',
        'Dalawang beses',
        'Tatlong beses',
        'Hindi ka makakapasok',
      ],
      q1Correct: 0,
      prompt: 'Paano mo malalaman kung aling switch ang para sa aling bumbilya?',
      options: [
        'Buksan ang Switch 1 nang ilang minuto, patayin ito, buksan ang Switch 2, saka pumasok — mainit ang bumulbula sa Switch 1',
        'Isa-isahin ang switch habang nakapasok sa kwarto',
        'Tulungan para ibukas ang pinto at may kabit na camera',
        'Hulaan na lang kasi pareho-todo ang lahat ng bumbilya',
      ],
      correctIdx: 0,
      answerExplanation:
          'Ang solution: i-on ang Switch 1 sa loob ng ilang minuto, saka patayin. I-on ang Switch 2 at pumasok sa kwarto. Ang bumbilyang NAKAON ay Switch 2. Ang bumbilyang PATAY pero MAINIT ay Switch 1. Ang bumbilyang PATAY at MALAMIG ay Switch 3. Ginagamit nito ang init ng bumbilya bilang dagdag na impormasyon balyong ang simpleng ilaw.',
      psychPrompt: 'Ano ang dagdag na mapagkukunan ng impormasyon na hindi mo iniisip?',
      psychOptions: [
        'Ang init ng bumbilya — hindi lang ang ilaw ang senyales',
        'Ang tunog ng switch — pandinig ang gamit',
        'Ang amoy ng kwarto — pandama ang gamit',
        'Ang timbang ng switch — dama ang presyon',
      ],
      psychCorrect: 0,
      psychExplain:
          'Ang trick ay ang pag-iisip "sa labas ng kahon": hindi lang ang ON/OFF ng ilaw ang itinuring na signal — pati ang INIT ng bumbilya ay isa pang dimensyon ng impormasyon. Ang mga lunas ay lumalawak kapag tumingin ka ng lampas sa pinaka-halatang senyales.',
      q4Prompt: 'Ang bitag dito ay ang pag-aakalang ang sagot ay…',
      q4Options: [
        'nakasalalay lang sa pag-ON/OFF ng ilaw kasi hindi mo iniisip ang init',
        'nakasalalay sa bilis ng pagtakbo papuntang kwarto',
        'kailangan ng dalawang tao para masilip',
        'imposible gawin kasi babasagin ang bombilya',
      ],
      q4Correct: 0,
      q4Explain:
        'Ang bitag: iniisip natin na ang "ilaw" lang ang signal na magagamit, kaya akala natin imposible o kailangan ng maraming pasok. Ang tunay na sagot ay nasa paggamit ng init bilang karagdagang signal — isang bagay na hindi natin agad napapansin.',
    ),
    _Riddle(
      title: 'Ang Isda sa Tangke',
      story: 'May 10 isda sa isang tangke. Dalawa ang lumubog, apat ang lumangoy palayo, at tatlo ang namatay. Ilan ang isda ang natira sa tangke?',
      q1Prompt: 'Ayon sa kwento, ilan ang isda sa tangke noong simula?',
      q1Options: [
        '10 isda',
        '8 isda',
        '6 isda',
        '3 isda',
      ],
      q1Correct: 0,
      prompt: 'Ilan ang isda ang natira sa tangke?',
      options: [
        'Lahat ng 10 — ang isda ay nasa tangke pa rin kahit lumubog o namatay',
        '5 isda — kasi ang mga lumangoy palay ay wala na',
        '7 isda — kasi 3 ang namatay',
        '2 isda — kasi kakaunti lang ang natakwil',
      ],
      correctIdx: 0,
      answerExplanation:
          'Ang sagot ay 10. Ang lahat ng isda ay nasa tangke pa rin — ang paglubog at pagkamatay ay hindi pwedeng magtanggal sa kanila sa tangke. Ang mga lumangoy "palayo" sa isang tangke ay hindi naman talaga makakaalis. Ang trick ay ang pagbibigay ng mga numerong "lubog, lumangoy, namatay" para ipagalaw ang iyong atensyon sa pagtangal.',
      psychPrompt: 'Bakit tayo nalinlang ng mga bilang na "lumubog, lumangoy palayo, namatay"?',
      psychOptions: [
        'Dahil sinasabi nating "lubog/lumangoy/namatay" para ipagbilang mo ang inalis sa halip na magbilang ng natitira',
        'Dahil lahat tayo ay hindi marunong magbilang',
        'Dahil mahal ang isda sa tindahan',
        'Dahil ang tangke ay walang tubig',
      ],
      psychCorrect: 0,
      psychExplain:
        'Ang epekto ay sa pag-frame: inilalayo ng kwento ang focus sa "pagtangal" (lubog/lumangoy/namatay) kaya imbes na manatili sa "ilang lahat ang nasa tangke," nagbibilang tayo ng ibinawas. Ang reframing ng problema ay mas mahalaga pa sa bilang.',
      q4Prompt: 'Ang tunay na bitag dito ay…',
      q4Options: [
        'ang pagtatanong na "ilan ang natira" imbes na "lahat ba ay nasa tangke pa rin?"',
        'ang paggamit ng malaking tangke na may kasamang mga bato',
        'ang pagsagot ng bilis sa halip na tama',
        'ang paghanap ng pangalan ng isda',
      ],
      q4Correct: 0,
      q4Explain:
        'Ang bitag: nagtatanong tayo ng "ilan ang NATIRA" kaya nagbibilang tayo ng bawas. Kung tatanungin mo ang tamang tanong ("lahat ba ay nasa tangke pa rin?"), makikita mo na walang nakaalis sa tangke. Ang tamang tanong ay kalahati na ng tamang sagot.',
    ),
  ];

  // ------------------------- helpers -------------------------
  String _pickName(bool female) {
    final f = female ? firstNameF : firstNameM;
    return '${f[_rng.nextInt(f.length)]} ${surname[_rng.nextInt(surname.length)]}';
  }

  String _element(List<String> l) => l[_rng.nextInt(l.length)];

  String _brokenAlibi() {
    final breaks = [
      'Umalis daw siya ng bahay para bumili ng mira, pero sarado pa ang tindahan at kinumpirma ng kapitbahay na sarado pa noon.',
      'Sabi niya nakaupo lang daw siya sa sala buong gabi, pero dalawa ang nakakita sa kanya na lumabas nang nakasumbrero.',
      'Nagkwento siyang tumulong siya sa pagluluto, pero sinabi ng kasambahay na wala siya sa kusina sa oras na iyon.',
      'Sabi niyang nanood siya ng TV buong gabi, ngunit walang signal ang TV noong oras na iyon.',
      'Ang detalye ng kanyang alibi ay SOBRA-sobra — nakuha niyang banggitin pa kung anong kulay ng medyas suot niya. Walang tao ang naaalala ang ganun kalaking detalye nang walang ensayo.',
    ];
    return breaks[_rng.nextInt(breaks.length)];
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

  String _killerStatement(String victim) {
    final st = [
      '"Medyo matigas ang ulo ng biktima, pero hindi ko kayang makita siyang ganun," sabi niya habang umiiwas ng tingin.',
      '"Huling beses kaming nag-usap ni $victim ay noong Monday, pero normal pa noon," ani niya — at agad dinagdag, "Alam mo, ang kantina ay may bagong mantel, at ang tindahan ay bagong pintura, at ang sasakyan ng kapitbahay ay may bagong gulong..." Sobrang layo ng sigla sa tanong.',
      '"Alam ko ang nararamdaman niya tungkol sa mga nangyari sa nakaraan," malamig na sabi niya, ngunit hindi niya maalala ang huling ngiti ng biktima.',
      '"Kung ako ang nasa labas, hindi ko hahayaang mangyari iyan kay $victim," sabi niya, ngunit nang tanungin tungkol sa ginawa niya, bigla siyang nanahimik.',
    ];
    return st[_rng.nextInt(st.length)];
  }

  String _innocentStatement(String victim) {
    final st = [
      '"Si $victim ay may pambihirang pagmamahal sa pamilya, hindi ko maipapaliwanag kung sino ang may kakayahang gawin ito," sabi niyang may halong hinagpis.',
      '"Narinig ko ang sigaw ni $victim mula sa labas, pero laging may mga ingay sa lugar na ito," aniya nang may pangamba.',
      '"Siyempre, alam kong may mga taong may sama ng loob. Pero hindi ko akalain na ganito kalalim," sambit niyang nakayuko.',
      '"Nag-usap kami ni $victim tungkol sa mga plano, nakangiti pa siya noong umaga," sabi niyang mapait.',
    ];
    return st[_rng.nextInt(st.length)];
  }
}

class _MoralDilemma {
  final String tagline;
  final String characters;
  final String setup;
  final String q1Prompt;
  final List<String> q1Options;
  final int q1Correct;
  final List<String> options;
  final int correctIdx;
  final int worstIdx;
  final String psychTerm;
  final String why;
  final String worstWhy;

  _MoralDilemma({
    required this.tagline,
    required this.characters,
    required this.setup,
    required this.q1Prompt,
    required this.q1Options,
    required this.q1Correct,
    required this.options,
    required this.correctIdx,
    required this.worstIdx,
    required this.psychTerm,
    required this.why,
    required this.worstWhy,
  });
}

class _DeceptionScene {
  final String event;
  final List<String> places;
  final String whoInformed; // e.g. 'may-ari ng tindahan'
  final String trueDetail; // ang TOTOONG napatunayan
  final String liarClaim; // ang sinabi ng sinungaling na sumasalungat
  final List<String> q1Wrongs; // maling options para sa Q1

  _DeceptionScene({
    required this.event,
    required this.places,
    required this.whoInformed,
    required this.trueDetail,
    required this.liarClaim,
    required this.q1Wrongs,
  });
}

class _Riddle {
  final String title;
  final String story;
  final String q1Prompt;
  final List<String> q1Options;
  final int q1Correct;
  final String prompt;
  final List<String> options;
  final int correctIdx;
  final String answerExplanation;
  final String psychPrompt;
  final List<String> psychOptions;
  final int psychCorrect;
  final String psychExplain;
  final String q4Prompt;
  final List<String> q4Options;
  final int q4Correct;
  final String q4Explain;

  const _Riddle({
    required this.title,
    required this.story,
    required this.q1Prompt,
    required this.q1Options,
    required this.q1Correct,
    required this.prompt,
    required this.options,
    required this.correctIdx,
    required this.answerExplanation,
    required this.psychPrompt,
    required this.psychOptions,
    required this.psychCorrect,
    required this.psychExplain,
    required this.q4Prompt,
    required this.q4Options,
    required this.q4Correct,
    required this.q4Explain,
  });
}