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
    final type = CaseType.values[_rng.nextInt(3)];
    switch (type) {
      case CaseType.murder:
        return _generateMurder();
      case CaseType.morality:
        return _generateMoral();
      case CaseType.deception:
        return _generateDeception();
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
    questions.add(CaseQuestion(
      kind: QuestionKind.psych,
      prompt: 'Ano ang PINAKA-MALAKAS na senyales ng pagsisinungaling sa isang alibi?',
      options: [
        'Sobra-sobrang detalye na parang inensayo',
        'Mahina ang boses at kinakabahan',
        'Matagal bago sumagot',
        'Madalas tumingin sa kaliwang sulok',
      ],
      correctIndex: 0,
      explanation:
          'Ayon sa cognitive psychology, ang sobrang detalye ang mas malakas na tanda — kasi ang totoong alaala ay may mga butas, habang ang inimbentong kwento ay inaayos "masyadong perpekto".',
    ));

    // Q4 MIND TRAP — ang "PAANO mo nasabi na si X ang pumatay" — reversal
    final innocent = suspects.firstWhere((s) => s.name != killer.name);
    questions.add(CaseQuestion(
      kind: QuestionKind.mind,
      prompt: 'Kung ang tanong ay BINALIGTAD — "Sino ang HINDI mo dapat i-areglo batay sa kilos LANG?" — ang sagot ay...?',
      options: [
        'Si ${innocent.name} — kasi ang kaba ay hindi patunay ng pagkakasala',
        'Si ${killer.name} — kasi ang kilos ay patunay na agad',
        'Lahat ng suspek — kasi wala nang pag-asa',
        'Hindi malalaman — kasi ang kilos ay sapat na',
      ],
      correctIndex: 0,
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
        options: [
          'Kunin ang pera at ibigay sa kanya',
          'Kunin ang pera at itago',
          'Ituro sa kanya na may nahulog',
          'Iuli ang jeep kahit huli ka sa trabaho para habulin siya',
        ],
        correctIdx: 0,
        worstIdx: 1,
        why: 'Ito ang pinaka-mabilis at makatao. Ibinabalik ang pera nang walang dagdag na gulo — walang kailangang maghabol, at malinaw ang intensyon.',
        worstWhy: 'Ang pagtago ng 500-piso ay pagnanakaw, kahit gaano pa kabilis ang pangyayari. Ang ganitong desisyon ay sinisira ang iyong integridad nang hindi mo namamalayan.',
      ),
      _MoralDilemma(
        tagline: 'Nalaman mo na ang bestfriend mo ay niloloko ang kanyang jowa.',
        characters: 'Ikaw, ang bestfriend, at ang jowa',
        setup: 'May ebidensya kang nakita: chats na nagpapakita na dalawang-timpalad ang bestfriend mo. Ang jowa niya ay mabait at nangunguliling kamusta sa iyo kahit magulo ang buhay niya.',
        options: [
          'Sabihin na agad sa jowa ang totoo',
          'Kausapin ang bestfriend at ibigay ang chance na siya mismo ang magsabi',
          'Manahimik — hindi mo ito laban',
          'I-post ang chats sa social media para mapahiya',
        ],
        correctIdx: 1,
        worstIdx: 3,
        why: 'Sa psychology ng "confrontation", ang pinaka-angkop ay bigyan ang kaibigan ng chance na i-correct — na may ultimatum. Pinapangalagaan nito ang hustisya nang hindi tinatapos ang tao bilang ang namamagitan.',
        worstWhy: 'Ang pag-post ng pribadong chats ay paninira ng dignidad — hindi hustisya. Ang pampublikong kahihiyan ay gumagawa ng pangalawang biktima at sinisira ang tiwala ng lahat sa iyo.',
      ),
      _MoralDilemma(
        tagline: 'Nakita mong nandadaya ang kaklase mo sa eksam.',
        characters: 'Ikaw, ang kaklase, at ang guro',
        setup: 'Malapit sa iyo ang kaklase mo na nagtitingin ng papel ng katabi. Hindi siya gumagawa ng ingay, at nakalusot siya ng dalawang beses.',
        options: [
          'Itaas ang kamay at iulat siya sa harap ng lahat',
          'Pumalakpak nang palihim para mabalik ang atensyon ng guro',
          'Sumbungin sa akin ang guro pagkatapos ng klase',
          'Wag pansinin — hindi ka responsable sa kanya',
        ],
        correctIdx: 2,
        worstIdx: 3,
        why: 'Ang psychological insight: ang pag-ulat ay mas mabisa at makatwiran kung PINAGKAKAIWANAN ang pampublikong kahihiyan. Pinapangalagaan nito ang entidad ng kaklase at binibigyan ng pagkakataong magbago.',
        worstWhy: 'Kapag may alam ka at nanahimik ka, kasabwat ka na. Ang "walang gusto kaguluhan" ay isa ring desisyon — ang hindi pagpili ay pagpili rin.',
      ),
      _MoralDilemma(
        tagline: 'May isang tao ang naghihingalo sa kalsada at ikaw lang ang tao.',
        characters: 'Ikaw, isang nasugatan, at ang paligid',
        setup: 'Sa hatinggabi, may nakita kang lalaking nadapa at hindi kumikibo sa kalsada. Wala kang load sa phone at walang tao sa paligid. May sari-sari store na dalawang bloke ang layo.',
        options: [
          'Tumakbo sa sari-sari store at humingi ng tulong',
          'Iwanan siya — siguradong darating ang iba',
          'Ituloy ang paglalakad pero sabihin sa kapitbahay',
          'Kalmahin siya at antayin ang tulong na walang ginagawa',
        ],
        correctIdx: 0,
        worstIdx: 1,
        why: 'Ito ang "bystander effect" — mas lalong HINDI tutulong ang tao kapag marami ang nasa paligid kasi iniisip nilang may ibang gagawa. Sa sitwasyong ito, ikaw ang tanging tao — ang responsibilidad ay nasa iyo, at ang mabilis na paghingi ng tulong ang nagliligtas ng buhay.',
        worstWhy: 'Kapag may nasugatan, ang bawat minuto ay mahalaga. Ang "una akong lalayo at hindi titingin" ay hindi kakulangan ng panahon — ito ay desisyon. Iwanan ang tao sa kalagitnaan ng daan ay mapapabayaan ang kanyang buhay.',
      ),
      _MoralDilemma(
        tagline: 'Nalaman mong may iligal na transaksyon ang pinsan mo.',
        characters: 'Ikaw, ang pinsan, at ang negosyo ng pamilya',
        setup: 'Pamilya ang negosyo ng iyong pinsan na ginagamit bilang front ng iligal na lending. Araw-araw kang nakakakita ng mga pamilya na nasisira dahil sa mataas na tubo. Mahal mo ang pinsan mo at tumutulong siya sa pamilya.',
        options: [
          'Iulat sa awtoridad',
          'Makipag-usap sa kanya at magbigay ng ultimatum',
          'Manahimik — nagsisilbi rin siya sa pamilya',
          'Mag-invest para palakihin ang negosyo',
        ],
        correctIdx: 1,
        worstIdx: 3,
        why: 'Ang tamang hakbang ay hindi palaging iulat kaagad. Una, bigyan siya ng pagkakataong magbago. Kung hindi siya makikinig at may ebidensya ka na, saka ka mag-ulat — ito ang pag-aagaw sa "grey zone" ng moralidad: pakikisama vs. responsibilidad.',
        worstWhy: 'Ang pag-invest sa ilegal na negosyo ay ginagawa kang ganap na kasabwat — hindi na lamang saksi. Ang perang kikitain ay mula sa biktima ng pag-aapuhap ay "maruming pera" na magpapaibig sa iyo sa sistema.',
      ),
    ];

    final d = dilemmas[_rng.nextInt(dilemmas.length)];
    final place = _element(locations);
    final time = _element(times);
    final situationExtra = _rng.nextBool()
        ? ' Kakaalis pa lang ng driver, at kailangan mong magdesisyon kaagad.'
        : ' Ang oras ay $time, at walang tumutulong na awtoridad na malapit.';

    final story = '${d.tagline}\n\n'
        'Sitwasyon: ${d.setup} Nangyayari ito sa $place.$situationExtra\n\n'
        '${d.characters}.\n\n'
        'ANO ANG GAGAWIN MO? Pumili ng isang plano ng aksyon.';

    final questions = <CaseQuestion>[];

    // Q1 EASY — nagbabasang mabuti
    questions.add(CaseQuestion(
      kind: QuestionKind.easy,
      prompt: 'Ayon sa kwento, ano ang dahilan kung bakit hindi ka agad maka-tawag ng tulong (kung applicable)?',
      options: [
        'Walang signal at walang tao sa paligid',
        'Hindi mo alam ang address',
        'Takot kang mapagalitan ng pulis',
        'Nakalimutan mo ang phone',
      ],
      correctIndex: 0,
      explanation:
          'Madaling tanong ito para i-ground ka sa detalye ng sitwasyon — may mga tao kasi na sumasagot batay sa palagay, hindi sa teksto.',
    ));

    // Q2 DEDUCTION — aling opsyon ang hindi makatao
    final humane = d.options[d.correctIdx];
    questions.add(CaseQuestion(
      kind: QuestionKind.deduction,
      prompt: 'Alin sa mga opsyon ang KINUKUHA ang mas makatao at mabilis na paraan?',
      options: d.options,
      correctIndex: d.correctIdx,
      explanation: d.why,
    ));

    // Q3 PSYCH — principle behind it
    final psychPairs = [
      ['Ano ang tawag sa phenomenon na hindi ka tumutulong dahil inaakala mong may iba na tutulong?', 'Bystander effect', 'Cognitive dissonance', 'FOMO', 'Halo effect'],
      ['Aling konsepto sa psychology ang tumutukoy sa paggawa ng tama kahit mahirap dahil sa sentido commun?', 'Moral courage', 'Gaslighting', 'Anchoring', 'Priming'],
      ['Anong defense mechanism ang pagbibigay-katwiran ng maling desisyon?', 'Rationalization', 'Projection', 'Sublimation', 'Repression'],
      ['Ano ang tawag kapag ang tao ay sumusunod sa karamihan kahit mali?', 'Conformity', 'Rebellion', 'Introspection', 'Altruism'],
    ];
    final p = psychPairs[_rng.nextInt(psychPairs.length)];
    questions.add(CaseQuestion(
      kind: QuestionKind.psych,
      prompt: p[0],
      options: [p[1], p[2], p[3], 'Serendipity'],
      correctIndex: 0,
      explanation: 'Psychology insight: ${p[1]} ang tamang termino para sa konseptong ito.',
    ));

    // Q4 MIND TRAP — reversal: alin ang PINAKA-MALI
    final worst = d.options[d.worstIdx];
    questions.add(CaseQuestion(
      kind: QuestionKind.mind,
      prompt: 'Mind trap: Kung ang tanong ay binaligtad — "ANO ANG PINAKA-MALI NA DESISYON?" — alin ang pipiliin mo?',
      options: d.options,
      correctIndex: d.worstIdx,
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
    final place = _element(locations);
    final time = _element(times);
    final event = _rng.nextInt(2) == 0
        ? 'isang maliit na magnanakaw ng pera sa tindahan'
        : 'isang malaking basag na bintana';

    final people = <String>{};
    while (people.length < 4) {
      people.add(_pickName(_rng.nextBool()));
    }
    final pList = people.toList();
    final liarIdx = _rng.nextInt(4);
    final liarBehavior = _element(behaviors);
    final otherBehaviors = List.of(behaviors.where((b) => b != liarBehavior))
      ..shuffle(_rng);

    // 3 magkakaibang detalye: ang sinungaling ay nagbabanggit ng isang FABRICATED na detalye
    final trueDetail = 'ang mga ilaw ay nakapatay nang oras na iyon';
    final liarDetail = 'malinaw niyang nakita ang mukha ng suspek';

    final witnesses = <Suspect>[];
    for (int i = 0; i < 4; i++) {
      final isLiar = i == liarIdx;
      witnesses.add(Suspect(
        name: pList[i],
        relation: 'saksi',
        alibi: isLiar ? liarDetail : trueDetail,
        behavior: isLiar ? liarBehavior : otherBehaviors[i],
        statement: isLiar
            ? 'Pahayag: "Nakita ko ang buong mukha ng suspek, at sigurado akong lalaki ito, naka-itim na jacket."'
            : (_rng.nextBool()
                ? 'Pahayag: "Hindi ko masyadong nakita — madilim at gulo-gulo na noon."'
                : 'Pahayag: "Narinig ko ang ingay, pero nakasara ang pinto ng bahay ko."'),
      ));
    }
    final liar = witnesses[liarIdx];

    final story = StringBuffer()
      ..writeln('Nangyari ang $event sa $place bandang $time.')
      ..writeln('Isang mahalagang detalye ang inilabas ng may-ari: $trueDetail.')
      ..writeln('Apat na saksi ang kinausap:')
      ..writeln();
    for (final w in witnesses) {
      story.write('— ${w.name}: ${w.statement}\n');
      story.write('   DETALYE: ${w.alibi}\n');
      story.write('   KILOS: ${w.behavior}\n\n');
    }
    story.write('Sino ang nagsisinungaling?');

    final questions = <CaseQuestion>[];

    // Q1 EASY
    questions.add(CaseQuestion(
      kind: QuestionKind.easy,
      prompt: 'Ano ang mahalagang detalye na inilabas ng may-ari ng tindahan?',
      options: [
        trueDetail,
        'ilaw na bukas at maliwanag',
        'madaling araw na bukas ang tindahan',
        'may CCTV ang tindahan',
      ],
      correctIndex: 0,
      explanation: 'Nakasulat mismo sa teksto: $trueDetail.',
    ));

    // Q2 DEDUCTION — sino ang sinungaling
    final nameOpts = witnesses.map((w) => w.name).toList()..shuffle(_rng);
    questions.add(CaseQuestion(
      kind: QuestionKind.deduction,
      prompt: 'Sino sa mga saksi ang nagsisinungaling?',
      options: nameOpts,
      correctIndex: nameOpts.indexOf(liar.name),
      explanation:
          'Si ${liar.name} lang ang nagbanggit ng "$liarDetail" — pero alam na natin na $trueDetail! Imposibleng makita niya ang mukha ng suspek. Ang kilos niya ay: ${liar.behavior}.',
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
          'Ang kanyang pahayag ("$liarDetail") ay direktang sumasalungat sa napatunayang detalye ($trueDetail). Ang kilos niya — ${liar.behavior} — ay suportado lamang, HINDI ang pangunahing ebidensya. Sa totoong investigation, ang say against the record ang bumubulag sa mga pulis.',
      questions: questions,
    );
  }

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
  final List<String> options;
  final int correctIdx;
  final int worstIdx;
  final String why;
  final String worstWhy;

  _MoralDilemma({
    required this.tagline,
    required this.characters,
    required this.setup,
    required this.options,
    required this.correctIdx,
    required this.worstIdx,
    required this.why,
    required this.worstWhy,
  });
}