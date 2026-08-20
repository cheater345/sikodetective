import 'dart:math';
import 'siko_case.dart';

class CaseGenerator {
  final Random _rng;
  final int _caseId;

  // Tracks a shuffled "bag" per pool so that every moral dilemma, deception
  // scene, and riddle is used once before any of them repeat.
  static final Map<String, List<int>> _poolBags = {};
  static final Map<String, int> _bagPos = {};

  CaseGenerator({int? caseId, int? seed})
      : _caseId = caseId ?? 1,
        _rng = Random(seed);

  int _nextFromBag(String pool, int length) {
    var bag = _poolBags[pool];
    var pos = _bagPos[pool] ?? 0;
    if (bag == null || pos >= bag.length) {
      final prevLast = bag != null && bag.isNotEmpty ? bag.last : null;
      bag = List<int>.generate(length, (i) => i)..shuffle(_rng);
      if (prevLast != null && bag.first == prevLast && length > 1) {
        final swapIdx = 1 + _rng.nextInt(length - 1);
        final tmp = bag[0];
        bag[0] = bag[swapIdx];
        bag[swapIdx] = tmp;
      }
      _poolBags[pool] = bag;
      pos = 0;
    }
    _bagPos[pool] = pos + 1;
    return bag[pos];
  }

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
    'pulis retirado', 'chef ng restaurant', 'mekaniko', 'dentista', 'teller sa bangko',
    'magtatahi', 'pharmacist', 'call center agent', 'bumbero', 'kartero',
    'negosyante ng talipapa', 'security analyst', 'veterinarian sa zoo lab',
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
    'isang boarding inn sa Zambales',
    'ang rooftop ng isang condominium sa Pasig',
    'isang sementeryo sa Tarlac',
    'isang abandoned na simbahan sa Bulacan',
    'ang basement ng isang mall sa Paranaque',
    'isang probinsyang baryo sa Catanduanes',
    'ang waiting shed sa Quezon Avenue',
    'isang karinderya sa Lucena',
  ];
  static const List<String> times = [
    'alas-diyes ng gabi', 'alas-tres ng madaling araw', 'alas-singko ng hapon',
    'alas-onse ng umaga', 'alas-otso ng gabi', 'alas-dose ng hatinggabi',
    'alas-kuwatro ng madaling araw', 'alas-sais ng umaga', 'alas-onse ng gabi',
  ];
  static const List<String> titlesMurder = [
    'Lihim ng Gabi', 'Ang Pasan na Katotohanan', 'Mga Balot na Mukha',
    'Huling Mensahe', 'Anino sa Dilim', 'Ang Nakatagong Kadahilanan',
    'Pusong Bato', 'Alaala ng Biktima', 'Saksi sa Katahimikan', 'Bakas ng Kahapon',
    'Isang Metronom ng Kasinungalingan', 'Ang Gabi ng Tandang Sora',
    'Silong ng Paantok', 'Ang Kwarto Nang Walang Bubong', 'Kontego sa Daan',
  ];
  static const List<String> titlesMoral = [
    'Ang Pagpili', 'Sa Kabila ng Daan', 'Ang Pabigat na Desisyon',
    'Barya-barya lang', 'Ang Utang na Di Mamamatay', 'Panibagong Umaga',
    'Ang Nakatagong Kabutihan', 'Susi sa Pinto', 'Ang Mahabang Gabi', 'Huling Subok',
    'Ang Ikaapat na Bintana', 'Lihim sa Ikaapat na Kwarto', 'Ang Pusong Hindi Sumusuko',
    'Kabanata ng Pagbangon', 'Isang Yakap sa Dilim',
  ];
  static const List<String> titlesDeception = [
    'Puso ng Mambabasa', 'Salita ng Saksi', 'Ang Daya sa Detalye',
    'Huli sa Akto', 'Boses ng Katotohanan', 'Ang Ikatlong Kwento',
    'Mukha ng Kasinungalingan', 'Tunay na Salaysay', 'Tabbing ng Mata', 'Ang Sabay na Kwento',
    'Tatlong Daan ng Buhay', 'Ang Nakatagong Katotohanan', 'Buhay na Larawan',
    'Palabas sa Gabi', 'Pagbabalat-kayo ng Puso',
  ];

  static const List<String> behaviors = [
    'napapansing pinagpapawisan at paulit-ulit na tinitignan ang orasan',
    'hindi makatingin nang diretso sa mata ng nagtatanong',
    'nanlalamig ang kamay at mahina ang boses habang sumasagot',
    'palaging ngumingiti nang pigil — parang alam na ang eksaktong mangyayari',
    'mabilis na nagpalit ng kwento nang mahuli sa sablay',
    'kabado ngunit pilit na nagmumukhang kalmado',
    'paulit-ulit na inaayos ang suot na damit habang nagsasalita',
    'tumitingin sa paligid bago sumagot — parang naghahanap ng masasandigan',
    'sobrang daldal habang sumasagot — malayo na ang takbo ng kwento',
    'madalas huminto at maghahanap ng tamang salita bago magpatuloy',
  ];

  SikoCase generate() {
    final type = CaseType.values[_nextFromBag('type', 4)];
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
    'isang semento na pamalo', 'isang wire na electric cord',
    'isang kawali na bakal', 'isang bakal na tubo ng gripo',
  ];
  static const List<String> _murderMotives = [
    'paghihiganti sa lumang alitan', 'pagnanakaw ng nakatagong kayamanan',
    'paninibugho sa relasyon', 'isang mabigat na utang na hindi nabayaran',
    'pagtakpan ang lihim na pakikipagsabwatan', 'isang away sa mana',
    'pagdamdam sa pagtaksil sa negosyo',
    'isang nakaraan na hindi mabura sa emosyon',
    'pag-imbak ng pera na di nagbabayad ng utang',
    'isang away sa inutang na bahay at lupa',
    'pagtakpan ang maling resibo sa kompanya',
  ];
  static const List<String> _relations = [
    'kapitbahay', 'pinsan', 'kasamang boarder', 'dating katrabaho', 'bestfriend',
    'asawa ni dating kaibigan', 'kaklase sa seminary', 'suki sa tindahan',
    'kapitbahay na lagi nag-aaway', 'kakilala sa simbahan',
    'miyembro ng simbahan', 'kapatid sa maternal side', 'malapit na kaopisina',
    'tindera sa palengke', 'katiwala sa opisina', 'dating guro',
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
      _MoralDilemma(
        tagline: 'Nakahuli ka ng magnanakaw na dalang-dala ang pitaka ng matanda.',
        characters: 'Ikaw, ang magnanakaw, ang matanda, at ang pulis sa malapit',
        setup: 'Nakikita mo ang isang lalaking mabilis na hinawakan ang pitaka ng nakatalikod na matanda at tumakbo. Nakahawak ka na sa kanya bago pa man siya makalampas. Ang pitaka ay hawak niya pa rin.',
        q1Prompt: 'Ayon sa kwento, ano ang hinablot ng lalaki sa matanda?',
        q1Options: [
          'Ang pitaka habang nakatalikod ang matanda',
          'Ang relo habang may suot na guwantes',
          'Ang cellphone habang natutulog',
          'Ang bayong na may dalang pera',
        ],
        q1Correct: 0,
        options: [
          'Itawag agad sa pulis habang hawak pa siya',
          'Ibitaw siya at pasawayin — baka may saktan',
          'Kunin ang pitaka at ibalik sa matanda, saka siya papakawalan',
          'Maliit na bagay lang iyon — hayaang umalis',
        ],
        correctIdx: 0,
        worstIdx: 3,
        psychTerm: 'Justice orientation',
        why: 'Ang pagtawag sa pulis habang hawak ang taong may pitaka ay nagpoprotekta sa ari-arian ng matanda at hindi ka kumakapit sa init ng sandali na maaaring lumala sa personal na pagharap. Ang makataong hakbang ay ang pagsangkot ng awtoridad — hindi pagparusa nang sarili mo.',
        worstWhy: 'Ang sabihing "maliit na bagay lang" ay pagwawalang-bahala sa karapatan ng matanda. Ang magnanakaw ay pwedeng bumalik at magnakaw muli. Ang hindi pag-aksyon ay tahimik na pag-apruba sa pagnanakaw.',
      ),
      _MoralDilemma(
        tagline: 'Nakita mong binubully ng mga kaklase ang isang mag-aaral.',
        characters: 'Ikaw, ang binubully, at ang mga kaklase',
        setup: 'Sa corridor, napalibutan ng limang kaklase ang isang mag-aaral at pinagtatawanan siya ng malakas dahil sa kanyang damit at pangalan. Palaging paulit-ulit ang ganito, at walang guro na malapit.',
        q1Prompt: 'Ayon sa kwento, ano ang dahilan ng pagtuya sa mag-aaral?',
        q1Options: [
          'Ang kanyang damit at pangalan',
          'Ang kanyang itsura at tono ng boses',
          'Ang kanyang cellphone na luma',
          'Ang kanyang relihiyon at lugar',
        ],
        q1Correct: 0,
        options: [
          'Tumabi sa kanya at harapin ang grupo nang mahinahon',
          'Iwanan ang lugar — hindi ito laban ko',
          'Sumali sa tuya para hindi ako mapansin',
          'Kuhanan ng video at i-post online',
        ],
        correctIdx: 0,
        worstIdx: 3,
        psychTerm: 'Bystander intervention',
        why: 'Ang pagtayo sa tabi ng biktima at pagharap sa grupo nang mahinahon (hindi agresibo) ay isang "bystander intervention" — nababawasan nito ang kapangyarihan ng grupo at binibigyan ng ligtas na pwesto ang biktima. Hindi mo kailangang makipag-away para makatulong.',
        worstWhy: 'Ang pag-post ng video online ay nagpaparami sa kahihiyan at hindi tumutulong sa biktima — ito ay ibang uri ng pambubully. Ang pagkuha ng "content" mula sa pagdurusa ng iba ay ginagawa ka ring bahagi ng pinsala.',
      ),
      _MoralDilemma(
        tagline: 'May nakita kang wallet na may malaking pera sa loob ng jeep.',
        characters: 'Ikaw at ang isang tao na umalis na sa jeep',
        setup: 'Sa ilalim ng upuan ng jeep ay may nakita kang wallet na puno ng pera. Walang nakakaalam na nakita mo ito. Ang jeep ay bababa ka na sa susunod na hinto.',
        q1Prompt: 'Ayon sa kwento, saan mo nakita ang wallet?',
        q1Options: [
          'Sa ilalim ng upuan sa jeep',
          'Sa loob ng bag ng sabay mo',
          'Sa gilid ng daan',
          'Sa floor lamp sa bahay',
        ],
        q1Correct: 0,
        options: [
          'Ibigay sa konduktor ang wallet para mahawakan ng may-ari',
          'Dalhin ang wallet at hanapin ang may-ari sa social media',
          'Itago ang wallet — walang nakakakita naman',
          'Iwanan kung saan ito — hindi ko ito laban',
        ],
        correctIdx: 0,
        worstIdx: 2,
        psychTerm: 'Integrity',
        why: 'Ang pag-aalala sa pagsasakay ng wallet sa konduktor (o kaya ay sa obrang pampublikong lunas) ay praktikal at makatao — ito ay nananatili sa pampublikong sistema at hindi ka kumikilos nang lihim. Ang paghanap sa may-ari online ay pwede ring ningas-kugon.',
        worstWhy: 'Ang pagtago ng wallet ng iba ay pagnanakaw — kahit na walang nakakita. Ang "walang nakakakita" ay hindi nangangahulugang tama. Ang integrity ay ang ginagawa mo kapag walang nagmamasid.',
      ),
      _MoralDilemma(
        tagline: 'Nalaman mong mali ang paglabas ng suweldo ng kapatid mo.',
        characters: 'Ikaw at ang kapatid mo',
        setup: 'Nagpasweldo ang kapatid mo at napansin niyang sobra ang natanggap niya ng tatlong libo. Wala pang nagtatanong tungkol dito at hindi alam ng kompanya.',
        q1Prompt: 'Ayon sa kwento, magkano ang sobrang natanggap ng kapatid mo?',
        q1Options: [
          'Tatlong libong piso',
          'Limang libong piso',
          'Dalawang daang piso',
          'Sampung libong piso',
        ],
        q1Correct: 0,
        options: [
          'Imungkahi sa kapatid na ipagbigay-alam agad sa HR',
          'Payuhan siyang itago muna hanggang magtanong sila',
          'Sabihing maging maalaga sa paggastos para di sila manghinala',
          'Kunin ang parte mo dahil obligasyon din nila sa pamilya',
        ],
        correctIdx: 0,
        worstIdx: 3,
        psychTerm: 'Honesty',
        why: 'Ang pag-amin ng labis na sahod ay maliit na halaga sa kasalukuyan kaysa sa pangmatagalang tiwala. Ang maagang pag-ulat ang pinakamabilis na paraan para maiwasan ang mas malalaking problema sa HR.',
        worstWhy: 'Ang pagkuha ng parte sa sobrang sahod ng kapatid ay pagpapalubha ng pagnanakaw — ang sobrang pera ay hindi iyo, at ang paggastos nito ay pagtangkilik sa maling bagay.',
      ),
      _MoralDilemma(
        tagline: 'Nakita mong may kumakatok sa bahay ng matandang babae.',
        characters: 'Ikaw at ang matandang babae',
        setup: 'May isang lalaki ang nagpupumilit na pumasok sa bahay ng matandang babae sa inyong barangay. Nabasa mong hindi siya inaanak at nakatatakot ang pakikipag-usap. Ang matanda ay madalas kasi mag-isa.',
        q1Prompt: 'Ayon sa kwento, sino ang nagpupumilit na pumasok sa bahay ng matanda?',
        q1Options: [
          'Isang lalaki na hindi inaanak',
          'Isang babae na kapitbahay',
          'Isang pulis na may ID',
          'Isang kamag-anak na nagbabakasyon',
        ],
        q1Correct: 0,
        options: [
          'Tawagin ang tanod ng barangay o pulis',
          'Hintayin mo munang makarinig ng sigaw',
          'Tumabi ka lang — baka yan lang ang anak niya',
          'Isigaw mo ang pangalan ng matanda para magising siya',
        ],
        correctIdx: 0,
        worstIdx: 2,
        psychTerm: 'Bystander effect',
        why: 'Ang pagtawag sa tanod ng barangay o pulis ay nagmasid sa seguridad ng matanda nang hindi ka nagmamadali sa sala. Hindi mo kailangang magparaang mag-isip — basta may makarating na tulong. Ito ay mas ligtas kaysa sa personal na pagharap na maaaring lumala.',
        worstWhy: 'Ang "baka yan lang ang anak niya" ay isang haka-haka na maaaring maglantad sa matanda sa panganib. Kapag may nagalit sa kanyang bahay, ang bawat minutong pagkaantala sa pagtawag ng tulong ay pwedeng magpabigat ng pinsala.',
      ),
      _MoralDilemma(
        tagline: 'May nakitang bagong cellphone sa sahig ng mall.',
        characters: 'Ikaw at ang nag-alaga ng store sa tabi',
        setup: 'Sa mismong mall, nakakita ka ng bagong cellphone sa sahig malapit sa pinto. Lumipas ang ilang minuto at wala nang naghahanap. May tindahan sa tabi na may CCTV.',
        q1Prompt: 'Ayon sa kwento, saan mo nakita ang cellphone?',
        q1Options: [
          'Sa sahig malapit sa pinto ng mall',
          'Sa loob ng bag ng tindera',
          'Sa bubong ng parking',
          'Sa loob ng cr ng mall',
        ],
        q1Correct: 0,
        options: [
          'Ibigay sa customer service ng mall para balikan ng may-ari',
          'Sukatin ang screen at ikaw na ang magkalat',
          'Itago at itabi — baka away na lang kapag binanggit',
          'Hulaan ang pin code — swerte na lang kung tama',
        ],
        correctIdx: 0,
        worstIdx: 3,
        psychTerm: 'Ethical dilemma',
        why: 'Ang pagbibigay sa customer service ng mall (na may CCTV at ligtas na pag-aalaga) ay ang pinaka-makatao at madaling paraan — binabalik mo ang ari-arian nang hindi mo ito ginagawang personal na pasya. Ang tiwala ang hindi mo kayang bilhin ng kahit anong presyo ng phone.',
        worstWhy: 'Ang pag-aangkin ng nawawalang cellphone ay pagnanakaw ng ari-arian ng iba. Ang "tinadhana sa akin" ay isang pagbigay-katwiran lamang — ang pera at pagkakataon na mawala ay dapat ibalik bilang karapatan ng tunay na may-ari.',
      ),
      _MoralDilemma(
        tagline: 'Nalaman mong nasira ang dokumento ng kaaway mo sa trabaho.',
        characters: 'Ikaw, ang kasamahan, at ang manager',
        setup: 'May kaaway ka sa trabaho na lagi kang inaakusa. Isang araw, nalaman mong mali ang pag-aayos ng kanyang dokumento na maaaring magtanggal sa kanya sa trabaho. Nasa kamay mo lang ang katotohanan na pwedeng magligtas sa kanya.',
        q1Prompt: 'Ayon sa kwento, ano ang maaaring maging resulta ng maling dokumento?',
        q1Options: [
          'Maaari siyang matanggal sa trabaho',
          'Maaaring ma-promote siya',
          'Wala itong epekto sa kanya',
          'Baka ma-Angkinin niya ang bonus',
        ],
        q1Correct: 0,
        options: [
          'Ipadala ang katotohanan kahit na ayaw mo sa kanya',
          'Hayaan lang — mabuti nang matanggal siya sa trabaho',
          'Gamitin itong pakinabang para humingi ng pabor',
          'Ipakalat sa iba ang totoong detalye para kahit papaano may gamit',
        ],
        correctIdx: 0,
        worstIdx: 2,
        psychTerm: 'Fairness',
        why: 'Ang pagbigay ng ebidensya kahit may personal na hindi pagkakaunawaan ay nagpoprotekta sa hustisya ng trabaho — hindi ka gumagawa ng desisyon batay sa galit. Ang pagbagsak ng kasamahan ay hindi dapat maganap dahil lamang sa iyong pansariling galit.',
        worstWhy: 'Ang paggamit ng sakit ng iba para makakuha ng pabor o kapalit ay isang uri ng blackmail. Ang "walang batas ang nagmamalasakit" ay hindi — ang hustisya ay hindi napapalitan ng personal na motibo.',
      ),
    ];

    final d = dilemmas[_nextFromBag('moral', dilemmas.length)];

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
      _DeceptionScene(
        event: 'pagtakas ng isang alagang aso sa gate ng bahay',
        places: [
          'isang bahay sa Sikatuna, Quezon City',
          'isang compound sa Pasig',
          'isang housing village sa Cavite',
          'isang farmhouse sa Batangas',
        ],
        whoInformed: 'may-ari ng bahay',
        trueDetail: 'nakakandadong bakal na gate at walang nakalas na padlock nang oras ng insidente',
        liarClaim: 'buksan ang gate nang kanyang makita at nakalabas ang aso roon',
        q1Wrongs: [
          'nagkwento ang kapitbahay na nasa ilalim ng pinto ang aso',
          'may binabasag na bintana sa kusina',
          'naglalakad ang mga aso sa loob ng compound',
        ],
      ),
      _DeceptionScene(
        event: 'pagkasira ng gulay sa loob ng bodega ng palengke',
        places: [
          'isang bodega ng palengke sa Divisoria',
          'isang cold storage sa Davao',
          'isang bodega ng supply sa Iloilo',
          'isang imbakan ng bigas sa Nueva Ecija',
        ],
        whoInformed: 'katiwala ng bodega',
        trueDetail: 'sarado ang lahat ng pinto ng bodega at naka-scan ang temperature na normal buong gabi',
        liarClaim: 'nakita niyang bumukas ang pinto sa likuran at pumasok ang mga taong kinarga ang gulay',
        q1Wrongs: [
          'may malaking butas sa bubong na inaan ng ulan',
          'nagulo ang cctv at walang rekord buong gabi',
          'sinira ng mga daga ang mga kahon ng gulay',
        ],
      ),
      _DeceptionScene(
        event: 'pagnanakaw ng mga alahas sa isang jewelry store',
        places: [
          'isang jewelry store sa SM Mega Mall',
          'isang tindahan ng alahas sa Greenhills',
          'isang boutique sa Ayala',
          'isang pawnshop sa Divisoria',
        ],
        whoInformed: 'manager ng tindahan',
        trueDetail: 'walang nasirang bintana at naka-lock ang tindahan — nang walang tao, at walang pumasok sa pinto na wala sa CCTV nang oras ng insidente',
        liarClaim: 'nakita niyang may lalaking humawak sa pinto nang 5 minuto at nagpatuloy sa loob bago pa man pumasok ang guard',
        q1Wrongs: [
          'bukas ang pinto at tahimik ang lahat ng camera',
          'may tao na naka-mask na pumasok mula sa kisame',
          'nanjan ang guard pero hindi niya napansin ang pagpasok',
        ],
      ),
      _DeceptionScene(
        event: 'pagbaha ng tubig sa loob ng isang opisina',
        places: [
          'isang opisina sa BGC',
          'isang call center hub sa Clark',
          'isang law office sa Makati',
          'isang school library sa Marikina',
        ],
        whoInformed: 'administrator ng gusali',
        trueDetail: 'walang pumutok na tubo ng tubig at patay ang pangunahing balbula ng building nang oras ng baha',
        liarClaim: 'nakita niyang bumukas at pumutok ang tubo ng banyo sa ikalawang palapag bago pa man dumating ang baha',
        q1Wrongs: [
          'may pumutok na tubo sa kisame ng storage',
          'may nag-iwan ng bukas na gripo sa cr',
          'bumaha dahil sa malakas na ulan sa labas',
        ],
      ),
      _DeceptionScene(
        event: 'pagnanakaw ng mga gamit sa loob ng isang paaralan',
        places: [
          'isang pampublikong paaralan sa Tondo',
          'isang science high school sa Quezon City',
          'isang kolehiyo sa Cebu',
          'isang boarding school sa Benguet',
        ],
        whoInformed: 'punong guro ng paaralan',
        trueDetail: 'lahat ng bintana ay naka-rehas at nakakandado, at nakasara ang pangunahing pinto nang walang nasirang lock',
        liarClaim: 'nakita niyang bukas ang bintana ng library at may pumasok na tao na may dalang bag',
        q1Wrongs: [
          'may bumukas na pinto galing sa loob',
          'may nagyelong kawad na ginamit para makapasok',
          'may sirang CCTV kaya walang rekord ng insidente',
        ],
      ),
    ];
    final scene = scenes[_nextFromBag('deception', scenes.length)];
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
    final r = riddles[_nextFromBag('riddle', riddles.length)];

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
    _Riddle(
      title: 'Ang Orasan na Nakabaligtad',
      story: 'May isang taong gustong malaman kung anong oras na. Meron siyang dalawang relo: ang isa ay 5 minuto ang bilis, at ang isa naman ay 5 minutong hina. Alin ang mas maaasahan upang malaman ang totoong oras?',
      q1Prompt: 'Ayon sa kwento, ilang minuto ang bilis ng unang relo?',
      q1Options: [
        '5 minutong bilis',
        '10 minutong bilis',
        '15 minutong bilis',
        '30 minutong bilis',
      ],
      q1Correct: 0,
      prompt: 'Alin ang mas maaasahan para malaman ang eksaktong oras?',
      options: [
        'Ang relong 5 minutong hina — kasi alam mong 5 minuto ka lang nasa likod at pwede mong i-add ang 5 minuto',
        'Ang relong 5 minutong bilis — kasi parang mas mahaba ang panahon',
        'Ang dalawa ay magkapareho — wala namang tama sa kanila',
        'Wala sa dalawa — kailangan ng bagong relo',
      ],
      correctIdx: 0,
      answerExplanation:
          'Ang relong 5 minutong HINA ang mas maaasahan: kung sinasabi nito na 2:00, alam mong 2:05 na talaga (i-add mo ang 5 minuto). Ngunit ang relong 5 minutong BILIS ay gumagalaw pa rin nang mas mabilis — lumalayo pa ito sa tamang oras bawat minuto. Ang predictable na mali ay mas madaling i-correct kaysa sa mali na patuloy na lumalaki.',
      psychPrompt: 'Ano ang prinsipyong sikolohikal na pinag-uusapan dito?',
      psychOptions: [
        'Predictability — mas maganda ang mali na alam mo ang sukat kaysa sa hindi mo alam ang paglihis',
        'Halo effect — mas maganda ang mukhang mabilis',
        'Priming — naaalala mo lang ang mga bilis na relo',
        'Sunk cost — ayaw mong bitiwan ang relo na binili mo',
      ],
      psychCorrect: 0,
      psychExplain:
          'Ang insight: hindi lahat ng "mali" ay pantay. Ang mali na may CONSTANT at alam na paglihis ay pwedeng i-adjust — ito ay "kalibrated error." Ang mali na patuloy na lumalaki ay mas mahirap i-correct. Sa buhay, mas mabuting malaman ang iyong mga kahinaan (predictable) kaysa sa magkaroon ng pananalig na hindi mo kayang i-verify.',
      q4Prompt: 'Ang bitag dito ay ang pag-aakalang…',
      q4Options: [
        'ang "bilis" ay parang mas magaling kaysa sa "hina"',
        'ang relo ay may baterya',
        'ang oras ay laging pareho sa lahat ng lugar',
        'kailangan mong bilhin ang mas mahal na relo',
      ],
      q4Correct: 0,
      q4Explain:
        'Ang bitag: inuugnay natin ang "bilis" sa pagiging mabuti at "hina" sa pagiging masama — isang halimbawa ng value judgment na walang basehan. Sa math at lohika, ang bilis o hina ay hindi mas mabuti — ang pagiging PREDICTABLE at ADJUSTABLE ang mahalaga.',
    ),
    _Riddle(
      title: 'Ang Tsuper at ang 4 na Pasahero',
      story: 'Isang bus ang gumagalaw papunta sa hilaga. Ang tsuper ay 30 taong gulang. May 4 na pasahero sa loob: isang guro, isang nars, isang karpintero, at isang abogado. Ilang taon ang tsuper ng bus?',
      q1Prompt: 'Ilang taon ang tsuper ng bus?',
      q1Options: [
        '30 taong gulang',
        '40 taong gulang',
        '50 taong gulang',
        '60 taong gulang',
      ],
      q1Correct: 0,
      prompt: 'Ilang taon ang tsuper ng bus?',
      options: [
        '30 taon — nakasaad mismo sa kwento na ang tsuper ay 30 taong gulang',
        'Hindi alam — hindi nabanggit ang edad ng tsuper',
        '30 taon — kasi may 4 na pasahero na may mga propesyon',
        '34 taon — kasi 30 + 4 na pasahero',
      ],
      correctIdx: 0,
      answerExplanation:
          'Ang sagot ay nasa kwento mismo: "Ang tsuper ay 30 taong gulang." Ang lahat ng iba pang detalye (hilaga, mga propesyon) ay mga dagdag na distraction na hindi kailangan para sa sagot. Sinasanay nito ang iyong kakayahang i-filter kung aling impormasyon ang TOTOONG kailangan.',
      psychPrompt: 'Anong cognitive tendency ang ginagamit ng trick na ito?',
      psychOptions: [
        'Cognitive load — sobrang daming impormasyon kaya nakakalimutan ang mahalagang detalye',
        'Confirmation bias — hinahanap ang edad sa maling lugar',
        'Halo effect — nabigla sa mga propesyon',
        'Priming — naaalala lang ang mga katulad na palaisipan',
      ],
      psychCorrect: 0,
      psychExplain:
          'Ang palaisipang ito ay tungkol sa cognitive load: kapag maraming dagdag na detalye, nahihirapan ang utak na manatiling nakatutok sa core question. Ang kasanayang ito — pag-filter ng mahahalagang impormasyon mula sa ingay — ay susi sa problema-solving at paggawa ng desisyon.',
      q4Prompt: 'Ang bitag dito ay…',
      q4Options: [
        'ang pag-focus sa mga dagdag na propesyon imbes na sa direktang sagot sa kwento',
        'ang pagtingin sa kanan ng bus',
        'ang pagbilang ng mga gulong',
        'ang pagtukoy ng pangalan ng tsuper',
      ],
      q4Correct: 0,
      q4Explain:
        'Ang bitag: ang mga propesyon ng mga pasahero at ang direksyon ng bus ay mga "noise" na idinagdag para ma-distract ka. Ang kasanayang ito — pag-ignore ng irrelevancy — ay kung paano mo dapat tratuhin ang maraming impormasyon sa pang-araw-araw na buhay.',
    ),
    _Riddle(
      title: 'Ang Palaka sa Balon',
      story: 'Isang palaka ang nasa ilalim ng isang balon na 12 metro ang lalim. Araw-araw, umakyat ito ng 3 metro, pero sa gabi ay dumudulas ito pabalik ng 2 metro. Ilang araw bago ito makaakyat at makalabas sa balon?',
      q1Prompt: 'Ilang metro ang lalim ng balon?',
      q1Options: [
        '12 metro',
        '10 metro',
        '15 metro',
        '8 metro',
      ],
      q1Correct: 0,
      prompt: 'Ilang araw bago makaalis ang palaka sa balon?',
      options: [
        '10 araw — sa unang 9 na araw ay netong 1 metro ang taas kada araw, at sa ika-10 araw ay aakyat ito ng 3 metro (9+3=12)',
        '6 araw — kasi 12 / 2 = 6',
        '4 na araw — kasi 12 / 3 = 4',
        '12 araw — kasi 3 - 2 = 1 metro bawat araw',
      ],
      correctIdx: 0,
      answerExplanation:
          'Ang sagot ay 10 araw. Sa bawat araw, ang palaka ay may netong 1 metro na taas (umakyat ng 3, bumaba ng 2). Pagkatapos ng 9 na araw, nasa 9 na metro ito. Sa ika-10 araw, umakyat ito ng 3 metro: 9 + 3 = 12 metro — LABAS NA ito bago pa man dumulas pabalik sa gabi. Ang common mistake ay ang pag-sabi ng 12 araw (netong 1 metro/day), na hindi iniisip na sa huling araw ay aakyat na ito nang hindi na bumababa.',
      psychPrompt: 'Anong karaniwang pagkakamali ang ginagawa ng mga sumasagot?',
      psychOptions: [
        'Hinahati nila ang total distance sa netong 1 metro nang hindi iniisip na sa huling araw ay makaakyat na',
        'Sinisikap nilang i-multiply ang distansya sa araw',
        'Nakalimutan nilang may tubig sa balon',
        'Iniisip nilang ang palaka ay natutulog sa gabi',
      ],
      psychCorrect: 0,
      psychExplain:
          'Ang error ay ang pagtrato sa problema bilang isang tuwid na linear equation (12 / 1 = 12 araw) nang hindi iniisip ang endpoint condition — na kapag nakarating na sa tuktok ay hindi na kailangan pang bumaba. Ang pag-iisip sa mga "edge cases" ay mahalagang kasanayan sa lohika at pagprogram.',
      q4Prompt: 'Ang bitag dito ay…',
      q4Options: [
        'ang pag-aakalang ang netong pag-akyat bawat araw ay kailangan mangyari hanggang sa huling araw',
        'ang pagbilang ng mga palaka sa balon',
        'ang pag-akala na may hagdan sa balon',
        'ang pag-akalang walang tulog ang palaka',
      ],
      q4Correct: 0,
      q4Explain:
        'Ang bitag: hinahayaan nating maging ugali ang "netong 1 metro kada araw" kaya nakakalimutan natin na ang araw na umabot sa tuktok ay ang huling hakbang — hindi na siya bababa muli. Ang pag-check ng "anong mangyayari sa huling hakbang?" ay madalas ang susi sa tamang sagot.',
    ),
    _Riddle(
      title: 'Ang Tatlong Lalaki sa Restawran',
      story: 'Tatlong lalaki ang kumain sa isang restawran at nagbayad ng 30 piso — 10 piso bawat isa. Nalaman ng may-ari na ang bill ay 25 piso lamang, kaya binigyan niya ang waiter ng 5 piso para ibalik. Pero ang waiter ay nagtago ng 2 piso at nagbalik ng 3 piso — 1 piso bawat lalaki. Kaya ang bawat lalaki ay nagbayad ng 9 piso: 3 × 9 = 27, at 27 + 2 (tago ng waiter) = 29. Saan napunta ang 1 piso?',
      q1Prompt: 'Magkano ang aktwal na bill ng mga lalaki?',
      q1Options: [
        '25 piso',
        '30 piso',
        '27 piso',
        '20 piso',
      ],
      q1Correct: 0,
      prompt: 'Saan napunta ang nawawalang 1 piso?',
      options: [
        'Wala itong nawawala — ang 27 ay ang total na 25 (bill) + 2 (tago ng waiter) na ang tanong ay mali ang pagbibilang',
        'Kinukuha ito ng waiter sa kanyang bulsa',
        'Nahulog sa sahig ng restawran',
        'Binigay sa may-ari bilang tip',
      ],
      correctIdx: 0,
      answerExplanation:
          'Walang nawawalang piso. Ang 27 piso ay binubuo ng 25 (bill) + 2 (tinago ng waiter). Ang pag-add ng 2 sa 27 ay mali — ang 27 ay kasama na ang 2. Ang tamang pagtingin: 25 (sa may-ari) + 2 (sa waiter) = 27 (mula sa mga lalaki) + 3 (ibalik sa mga lalaki) = 30. Ang 29 ay isang maling equation na nagbibigay ng maling tanong.',
      psychPrompt: 'Anong cognitive error ang nagpapalinlang sa atin sa palaisipang ito?',
      psychOptions: [
        'Confirmation bias — hinahanap natin ang "nawawalang piso" kahit walang nawawala',
        'Halo effect — mahusay tayong nag-add ng numero',
        'Anchoring — una tayong nag-focus sa 30',
        'Framing — tinanggap natin ang maling matematika ng tanong',
      ],
      psychCorrect: 0,
      psychExplain:
          'Ang trick ay ang pag-frame: tinuturo sa atin ng kwento na "i-add ang 27 at 2" para i-assert na 29 na lang ang kabuuan. Ngunit ang operasyon mismo ang mali — ang 27 at 2 ay nagmula sa magkaibang base. Ang pagtanggap sa framing ng tanong nang walang pag-verify ay ang lihim na ugat ng maling sagot.',
      q4Prompt: 'Ang bitag dito ay…',
      q4Options: [
        'ang pagtanggap sa maling math ng tanong nang hindi ito binubusisi',
        'ang pag-iisip na ang waiter ay magnanakaw',
        'ang pag-akalang walang 1 piso sa buong mundo',
        'ang pag-akalang nagbayad ang mga lalaki ng 10 piso bawat isa',
      ],
      q4Correct: 0,
      q4Explain:
        'Ang bitag: ang tunay na lesson ay hindi tungkol sa piso kundi sa pag-verify ng mga claim. Kapag may tanong na "saan nawala ang 1 piso?", dapat mong balikan ang accounting — ang 27 + 2 ay walang kabuluhang pagbibilang. Ang pagsasanay sa matematika ay nagsisimula sa pagtatanong kung tama ba ang mga numero na ibinibigay sa iyo.',
    ),
    _Riddle(
      title: 'Ang Bata at ang Ama',
      story: 'Ang ama ni Juan ay may dalawang anak. Ang isa ay si Juan, at ang isa ay ang kapatid ni Juan. Ang ama ni Juan ay 40 taong gulang. Si Juan ay 20 taong gulang. Ilang taon ang kapatid ni Juan?',
      q1Prompt: 'Ilang taon si Juan?',
      q1Options: [
        '20 taong gulang',
        '10 taong gulang',
        '30 taong gulang',
        '40 taong gulang',
      ],
      q1Correct: 0,
      prompt: 'Ilang taon ang kapatid ni Juan?',
      options: [
        'Hindi matukoy — hindi binigay ang edad ng kapatid',
        '20 taon — kasi magkasing-edad sila ni Juan',
        '10 taon — kasi hati sila sa edad ng ama',
        '40 taon — kasi kasama siya sa edad ng ama',
      ],
      correctIdx: 0,
      answerExplanation:
          'Ang sagot: hindi natin alam. Ang kwento ay nagsasabi na may dalawang anak ang ama — si Juan at ang kapatid ni Juan — ngunit walang binabanggit na edad ng kapatid. Hindi mo pwedeng i-derive ang edad mula sa edad ni Juan o ng ama. Ang trick ay ang pag-aakalang kailangan mong mag-compute kapag ang sagot ay wala sa impormasyon.',
      psychPrompt: 'Anong tendency ang nagpapaisip sa atin na may sagot na dapat i-compute?',
      psychOptions: [
        'Need for closure — gusto nating makuha agad ang isang numero kahit kulang ang impormasyon',
        'Halo effect — nagtitiwala tayo sa mga taong may edad',
        'Anchoring — na-focus tayo sa 40 at 20',
        'Confirmation bias — naghahanap tayo ng pattern sa mga numero',
      ],
      psychCorrect: 0,
      psychExplain:
          'Ang "need for closure" ay ang cognitive tendency na gustong tapusin ang problema sa pamamagitan ng pagkuha ng sagot — kahit na ang tamang sagot ay "hindi natin alam." Ang pagtanggap sa kawalan ng impormasyon ay isang mas mahalagang kasanayan kaysa sa pagkuha ng maling sagot para lang may masagot.',
      q4Prompt: 'Ang bitag dito ay…',
      q4Options: [
        'ang pag-akalang kailangang may bilang na sagot kahit walang sapat na impormasyon',
        'ang pagbilang ng mga anak sa pamilya',
        'ang pag-akalang si Juan ay panganay',
        'ang pagtingin sa edad ng ama bilang code',
      ],
      q4Correct: 0,
      q4Explain:
        'Ang bitag: ang ating pagmamadali para sa "closure" (pagkuha ng sagot) ay madalas nagtutulak sa atin na mag-imbento ng numero. Ang matalinong sagot minsan ay "hindi natin alam" — at ang pagkilala sa limitasyon ng impormasyon ay isang mahalagang bahagi ng lohikal na pag-iisip.',
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
      'Sabihin niyang "nasa meeting ako" buong hapon, ngunit walang meeting na naka-record sa kompanya at walang kasamahan ang nakakita sa kanya.',
      'Sabi niyang nagbibisikleta siya papuntang bayan, pero wala sa garahe ang bike niya nang i-check ng pulis.',
      'Inangkin niyang natulog siya sa cr ng opisina nang mahabang oras, pero nakasara at walang gumagalaw sa recording ng hall noong oras na iyon.',
      'Nagsabing umutang siya ng pick-up sa kakilala, pero ang kakilala ay nasa ibang probinsya buong linggo.',
      'Sabi niyang bumisita daw siya sa kaibigan sa ospital, pero walang pangalan niya sa visitor log ng ospital nang araw na iyon.',
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
      'May time-in record sa opisina at election voucher na nagpapatunay sa kanyang lokasyon',
      'May video call log sa kaibigan na tumagal ng mahigit isang oras nang oras ng krimen',
      'May resibo ng grocery sa anumang tindahan na may timestamp na eksakto sa oras ng krimen',
      'Sumakay siya sa jeep na may konduktor na naaalala ang kanyang mukha at pwesto',
      'May resibo ng sine sa mall na may eksaktong oras ng panonood na tumutugma sa krimen',
    ];
    return solids[_rng.nextInt(solids.length)];
  }

  String _killerStatement(String victim) {
    final st = [
      '"Medyo matigas ang ulo ng biktima, pero hindi ko kayang makita siyang ganun," sabi niya habang umiiwas ng tingin.',
      '"Huling beses kaming nag-usap ni $victim ay noong Monday, pero normal pa noon," ani niya — at agad dinagdag, "Alam mo, ang kantina ay may bagong mantel, at ang tindahan ay bagong pintura, at ang sasakyan ng kapitbahay ay may bagong gulong..." Sobrang layo ng sigla sa tanong.',
      '"Alam ko ang nararamdaman niya tungkol sa mga nangyari sa nakaraan," malamig na sabi niya, ngunit hindi niya maalala ang huling ngiti ng biktima.',
      '"Kung ako ang nasa labas, hindi ko hahayaang mangyari iyan kay $victim," sabi niya, ngunit nang tanungin tungkol sa ginawa niya, bigla siyang nanahimik.',
      '"Kakaalis pa lang namin noong nagkita kami. Kaunti lang ang inusap," sabi niya — pero nang hilinging ilarawan ang damit ng biktima, nakapagbigay siya ng sobrang detalye tungkol sa sapatos, medyas, at kahit na butones ng polo.',
      '"Akala ko nasa bahay siya buong araw," malamig na sabi niya — ngunit nang tanungin kung saan siya mismo pumunta, nagkalituhan ang kwento at nagbago ng pwesto.',
    ];
    return st[_rng.nextInt(st.length)];
  }

  String _innocentStatement(String victim) {
    final st = [
      '"Si $victim ay may pambihirang pagmamahal sa pamilya, hindi ko maipapaliwanag kung sino ang may kakayahang gawin ito," sabi niyang may halong hinagpis.',
      '"Narinig ko ang sigaw ni $victim mula sa labas, pero laging may mga ingay sa lugar na ito," aniya nang may pangamba.',
      '"Siyempre, alam kong may mga taong may sama ng loob. Pero hindi ko akalain na ganito kalalim," sambit niyang nakayuko.',
      '"Nag-usap kami ni $victim tungkol sa mga plano, nakangiti pa siya noong umaga," sabi niyang mapait.',
      '"Kailangan kong masagot ang pangalan niya sa madaling araw," sabi niyang may halong pagod, "Pero mabilis kong nakalimutan kasi maraming nangyayari sa buhay ko."',
      '"Hindi ko alam kung bakit siya napasama sa gulo. Mabait naman siya sa akin palagi," umiyak siya habang nagsasalita.',
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