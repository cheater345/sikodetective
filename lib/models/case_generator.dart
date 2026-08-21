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
    'guro sa kolehiyo', 'driver ng tricycle', 'kontratista ng konstruksyon',
    'panadero', 'electrician', 'fisherman sa fish port', 'tour guide sa probinsya',
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
    'isang bahay-kubo sa isla ng Palawan',
    'isang bilihan ng bigas sa Isabela',
    'isang terminal ng bus sa Cubao',
    'ang attic ng isang lumang bahay sa Vigan',
    'isang fish port sa Navotas',
    'isang boarding house sa Maynila',
  ];
  static const List<String> times = [
    'alas-diyes ng gabi', 'alas-tres ng madaling araw', 'alas-singko ng hapon',
    'alas-onse ng umaga', 'alas-otso ng gabi', 'alas-dose ng hatinggabi',
    'alas-kuwatro ng madaling araw', 'alas-sais ng umaga', 'alas-onse ng gabi',
    'alas-singko ng madaling araw', 'alas-diyes ng umaga', 'alas-tres ng hapon',
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
    'hindi mapakali at panay ang pagbabago ng tayo',
    'paulit-ulit na nililinis ang kuko habang nagsasalita',
    'mabilis sumagot bago pa matapos ang tanong — parang inaabangan',
    'sobrang ngiti sa mga hindi dapat nakakatawang tanong',
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
    'isang piraso ng kahoy na may bakal na pako', 'isang kutsilyo ng chef ng kusina',
    'isang bakal na flashlight na pang-sports', 'isang matulis na salamin na basag',
    'isang bakal na tinidor ng barbecue', 'isang pala ng hardin',
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
    'pagtakpan ang lihim na anak sa labas', 'panloloko sa utang na may interes',
    'pag-agaw sa pwesto sa negosyo', 'paghihiganti sa pagtataksil ng katibayan',
    'pagnanakaw ng identidad sa kompanya', 'inis sa ingay na ginagawa ng biktima',
    'pagtakpan ang nakita ng biktima sa pandaraya sa barangay',
  ];
  static const List<String> _relations = [
    'kapitbahay', 'pinsan', 'kasamang boarder', 'dating katrabaho', 'bestfriend',
    'asawa ni dating kaibigan', 'kaklase sa seminary', 'suki sa tindahan',
    'kapitbahay na lagi nag-aaway', 'kakilala sa simbahan',
    'miyembro ng simbahan', 'kapatid sa maternal side', 'malapit na kaopisina',
    'tindera sa palengke', 'katiwala sa opisina', 'dating guro',
    'kasambahay ng tiyahin', 'kababata sa probinsya', 'dating kasintahan',
    'kaparehong koponan sa basketball', 'kasosyo sa negosyo ng sari-sari',
    'kakilala sa bangka', 'kalaro sa online game', 'katulong sa bahay ng lolo',
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
_MoralDilemma(
        tagline: 'Nalaman mong sobra ang natanggap mong sahod sa buwan na ito.',
        characters: 'Ikaw, ang iyong boss, at ang HR manager',
        setup: 'Nagpasweldo ang kompanya at napansin mong sobra ang natanggap mo ng limang libong piso. Wala pang nagtatanong tungkol dito at hindi alam ng accounting.',
        q1Prompt: 'Ayon sa kwento, magkano ang sobrang natanggap mong sahod?',
        q1Options: [
          'Limang libong piso',
          'Isang libong piso',
          'Sandaang piso',
          'Sampung libong piso',
        ],
        q1Correct: 0,
        options: [
          'Ipagbigay-alam agad sa HR at ibalik ang pera',
          'Itago muna ang pera hanggang sa may magtanong',
          'Gamitin ang pera para sa isang emergency',
          'I-donate ang pera sa charity para hindi na mabawi',
        ],
        correctIdx: 0,
        worstIdx: 1,
        psychTerm: 'Honesty',
        why: 'Ang pag-amin sa labis na sahod ay pagpapakita ng integridad. Ang maagang pag-ulat ay umiiwas sa posibleng suspisyon ng fraud at pinapanatili ang tiwala ng kompanya sa iyo.',
        worstWhy: 'Ang pagtago ng pera na hindi sa iyo ay pagnanakaw, kahit pa pagkakamali ng iba. Ang "hindi naman nila napansin" ay hindi katuwiran para sa panlilinlang.',
      ),
_MoralDilemma(
        tagline: 'May nakita kang wallet na puno ng pera sa ilalim ng upuan ng jeep.',
        characters: 'Ikaw, ang konduktor, at ang nawawalang may-ari',
        setup: 'Sa ilalim ng upuan ng jeep ay may nakita kang wallet na puno ng pera. Walang nakakaalam na nakita mo ito at bababa ka na sa susunod na hinto.',
        q1Prompt: 'Ayon sa kwento, saan mo nakita ang wallet?',
        q1Options: [
          'Sa ilalim ng upuan sa jeep',
          'Sa gilid ng kalsada',
          'Sa loob ng bag ng katabi',
          'Sa sahig ng terminal',
        ],
        q1Correct: 0,
        options: [
          'Ibigay ang wallet sa konduktor para maibalik sa may-ari',
          'Dalhin ang wallet at hanapin ang may-ari sa social media',
          'Itago ang wallet dahil walang nakakita',
          'Iwanan na lang kung nasaan ito',
        ],
        correctIdx: 0,
        worstIdx: 2,
        psychTerm: 'Integrity',
        why: 'Ang pagbibigay sa konduktor ay ang pinaka-praktikal at makataong paraan para maibalik ang gamit. Binibigyan nito ang may-ari ng siguradong paraan para mabawi ang wallet.',
        worstWhy: 'Ang pagtago ng wallet ay pagnanakaw. Ang "walang nakakakita" ay hindi dahilan para kuhanin ang hindi sa iyo.',
      ),
_MoralDilemma(
        tagline: 'Nakita mong binubully ng mga kaklase ang isang mag-aaral sa corridor.',
        characters: 'Ikaw, ang binubully, at ang grupo ng mga bully',
        setup: 'Napalibutan ng limang kaklase ang isang mag-aaral at pinagtatawanan siya ng malakas dahil sa kanyang luma at punit na damit. Walang guro na malapit sa lugar.',
        q1Prompt: 'Ayon sa kwento, ano ang dahilan ng pagtuya sa mag-aaral?',
        q1Options: [
          'Ang kanyang luma at punit na damit',
          'Ang kanyang grado sa klase',
          'Ang kanyang boses',
          'Ang kanyang itsura',
        ],
        q1Correct: 0,
        options: [
          'Tumabi sa biktima at harapin ang grupo nang mahinahon',
          'Iwanan ang lugar para hindi ka madamay',
          'Sumali sa tawanan para hindi ka magmukhang kakaiba',
          'Kuhanan ng video at i-post sa social media',
        ],
        correctIdx: 0,
        worstIdx: 3,
        psychTerm: 'Bystander intervention',
        why: 'Ang pagtayo sa tabi ng biktima ay isang "bystander intervention" — binabawasan nito ang kapangyarihan ng mga bully at binibigyan ng suporta ang biktima.',
        worstWhy: 'Ang pag-post ng video online ay nagdaragdag lamang sa kahihiyan ng biktima at ginagawa kang bahagi ng pananakit.',
      ),
_MoralDilemma(
        tagline: 'Nalaman mong may maling dokumento ang kaaway mo sa trabaho na maaaring magpaalis sa kanya.',
        characters: 'Ikaw, ang iyong kaaway, at ang manager',
        setup: 'May kaaway ka sa trabaho na laging naninira sa iyo. Nalaman mong may malaking pagkakamali sa report niya na maaaring maging dahilan ng kanyang pagkakatanggal. Ikaw lang ang nakakaalam nito.',
        q1Prompt: 'Ayon sa kwento, ano ang maaaring mangyari sa kaaway mo?',
        q1Options: [
          'Maaari siyang matanggal sa trabaho',
          'Maaari siyang ma-promote',
          'Maaari siyang mapagalitan lang',
          'Wala itong epekto',
        ],
        q1Correct: 0,
        options: [
          'Ipaalam sa kanya ang mali para maitama niya ito',
          'Hayaan lang siya para matanggal sa trabaho',
          'Gamitin ang impormasyon para humingi ng pabor',
          'Isumbong ang mali sa manager para masiguradong matatanggal siya',
        ],
        correctIdx: 0,
        worstIdx: 2,
        psychTerm: 'Fairness',
        why: 'Ang pagtulong kahit sa kaaway ay pagpapakita ng propesyonalismo at integridad. Ang hustisya sa trabaho ay hindi dapat nakabase sa personal na galit.',
        worstWhy: 'Ang paggamit ng pagkakamali ng iba para sa sariling pakinabang ay isang uri ng blackmail at manipulasyon.',
      ),
_MoralDilemma(
        tagline: 'May isang lalaking nagpupumilit na pumasok sa bahay ng matanda mong kapitbahay.',
        characters: 'Ikaw, ang lalaki, at ang matandang kapitbahay',
        setup: 'May isang lalaking hindi mo kilala na pilit na binubuksan ang pinto ng matanda mong kapitbahay. Nakikita mong natatakot ang matanda sa loob. Wala kang kahit anong armas.',
        q1Prompt: 'Ayon sa kwento, ano ang ginagawa ng lalaki sa bahay ng matanda?',
        q1Options: [
          'Nagpupumilit na pumasok sa bahay',
          'Kumatok nang mahinahon',
          'Nag-iiwan ng sulat sa pinto',
          'Naglilinis ng bakuran',
        ],
        q1Correct: 0,
        options: [
          'Tawagan agad ang barangay o ang pulis',
          'Tumingin lang mula sa malayo para hindi mapansin',
          'Sigawan ang lalaki para lumayo',
          'Hayaan lang dahil baka kamag-anak niya iyon',
        ],
        correctIdx: 0,
        worstIdx: 3,
        psychTerm: 'Bystander effect',
        why: 'Sa ganitong sitwasyon, ang pinakaligtas at pinakamabilis na tulong ay ang pagtawag sa awtoridad. Hindi mo kailangang ilagay ang sarili mo sa panganib, ngunit kailangan mong kumilos.',
        worstWhy: 'Ang pag-aakalang "baka kamag-anak lang" ay isang mapanganib na pagpapaliban ng tulong na maaaring magresulta sa pinsala sa biktima.',
      ),
_MoralDilemma(
        tagline: 'Nakapulot ka ng isang bagong cellphone sa sahig ng mall.',
        characters: 'Ikaw, ang security guard, at ang may-ari ng phone',
        setup: 'Nakapulot ka ng isang mamahaling cellphone sa sahig ng mall. Walang nakakita sa iyo at walang tao sa paligid. May malapit na customer service center.',
        q1Prompt: 'Ayon sa kwento, saan mo nakita ang cellphone?',
        q1Options: [
          'Sa sahig ng mall',
          'Sa loob ng isang tindahan',
          'Sa parking lot',
          'Sa loob ng banyo',
        ],
        q1Correct: 0,
        options: [
          'Ibigay ang phone sa customer service ng mall',
          'Subukang hulaan ang passcode para hanapin ang may-ari',
          'Itago ang phone at ibenta ito',
          'Iwanan na lang ang phone kung nasaan ito',
        ],
        correctIdx: 0,
        worstIdx: 2,
        psychTerm: 'Ethical dilemma',
        why: 'Ang pag-uwi ng gamit sa tamang awtoridad ay ang pinaka-etikal na hakbang. Binibigyan nito ang may-ari ng pinakamalaking tsansa na mabawi ang kanilang gamit.',
        
        worstWhy: 'Ang pagbebenta ng gamit na hindi sa iyo ay pagnanakaw. Ang paggamit ng pagkakataon para kumita ay pagkasira ng iyong moralidad.',
      ),
_MoralDilemma(
        tagline: 'May nagawa kang malaking pagkakamali sa isang report na hindi pa napapansin ng boss mo.',
        characters: 'Ikaw, ang iyong boss, at ang iyong mga kasamahan',
        setup: 'Nakagawa ka ng isang maling kalkulasyon sa report na isinumite mo. Hindi pa ito napapansin ng iyong boss, ngunit kung hindi ito maitatama, maaaring magkaroon ng problema sa budget sa susunod na buwan.',
        q1Prompt: 'Ayon sa kwento, ano ang nangyari sa report na isinumite mo?',
        q1Options: [
          'May maling kalkulasyon sa report',
          'Nawala ang ilang pahina ng report',
          'Mali ang pangalan ng kliyente',
          'Hindi natapos ang report sa oras',
        ],
        q1Correct: 0,
        options: [
          'Aminin ang pagkakamali sa boss at itama ang report',
          'Manahimik at umasang hindi mapapansin ang mali',
          'Isisi ang pagkakamali sa isang kasamahan',
          'Burahin ang report at gumawa ng bago nang walang paalam',
        ],
        correctIdx: 0,
        worstIdx: 2,
        psychTerm: 'Responsibility',
        why: 'Ang pag-amin sa pagkakamali ay pagpapakita ng pananagutan. Mas mainam na itama ang mali habang maaga pa kaysa hayaan itong lumala at maging problema ng lahat.',
        worstWhy: 'Ang pagsisi sa iba ay isang kawalan ng integridad. Ang paninira sa kasamahan para pagtakpan ang sarili ay isang mabigat na pagkakamali.',
      ),
_MoralDilemma(
        tagline: 'Nalaman mong nandaya ang iyong matalik na kaibigan sa isang board exam.',
        characters: 'Ikaw, ang iyong kaibigan, at ang PRC board',
        setup: 'May ebidensya kang nakita na gumamit ng kodigo ang iyong kaibigan sa isang mahalagang board exam. Kung hindi siya papasa, mawawalan siya ng trabaho at hindi makakatulong sa pamilya.',
        q1Prompt: 'Ayon sa kwento, ano ang ginamit ng kaibigan mo para makapasa?',
        q1Options: [
          'Kodigo sa board exam',
          'Tulong mula sa ibang tao',
          'Susi ng sagot mula sa internet',
          'Pagsusulpot ng sagot sa papel',
        ],
        q1Correct: 0,
        options: [
          'Kausapin ang kaibigan at hikayatin siyang maging tapat',
          'Isiwalat ang pandaraya sa awtoridad',
          'Manahimik na lang para matulungan ang pamilya niya',
          'Humingi ng kapalit na pabor sa kaibigan kapalit ng pananahimik',
        ],
        correctIdx: 0,
        worstIdx: 3,
        psychTerm: 'Confrontation',
        why: 'Ang pag-uusap nang tapat ay pagbibigay ng pagkakataon sa kaibigan na ituwid ang mali. Ang pagpilit sa kanya na maging tapat ay mas nakakatulong sa long-term kaysa sa pagtatago ng kasalanan.',
        worstWhy: 'Ang paggamit ng lihim ng iba para sa sariling pakinabang ay blackmail. Ginagawa nitong transaksyon ang pagkakaibigan sa halip na suporta.',
      ),
_MoralDilemma(
        tagline: 'Ang negosyo ng iyong pamilya ay ginagamit bilang front ng ilegal na lending.',
        characters: 'Ikaw, ang iyong magulang, at ang mga biktima',
        setup: 'Nalaman mong ang pamilya mong negosyo ay ginagamit para sa ilegal na pautang na may sobrang taas na interes. Maraming pamilya ang nababaon sa utang dahil dito.',
        q1Prompt: 'Ayon sa kwento, ano ang ginagamit na front ng negosyo ng pamilya mo?',
        q1Options: [
          'Ilegal na lending',
          'Pagnanakaw ng gamit',
          'Ilegal na sugalan',
          'Pagtatago ng mga kontrabando',
        ],
        q1Correct: 0,
        options: [
          'Kausapin ang pamilya at magbigay ng ultimatum na itigil ito',
          'Iulat ang ilegal na gawain sa mga awtoridad',
          'Manahimik na lang dahil tumutulong ang pera sa pamilya',
          'Tumulong sa pagpapatakbo ng lending para lumaki ang kita',
        ],
        correctIdx: 0,
        worstIdx: 3,
        psychTerm: 'Moral courage',
        why: 'Ang pagkakaroon ng lakas ng loob na harapin ang pamilya ay pagpapakita ng moral courage. Ang pagpili sa tama kaysa sa sariling pakinabang ay tunay na integridad.',
        worstWhy: 'Ang pagtulong sa ilegal na gawain ay ginagawa kang kasabwat sa krimen. Ang pera na galing sa paghihirap ng iba ay hindi kailanman magiging tama.',
      ),
_MoralDilemma(
        tagline: 'Tinanong ka kung gusto mong tumulong sa paggawa ng isang pekeng alibi para sa kaibigan.',
        characters: 'Ikaw, ang iyong kaibigan, at ang pulis',
        setup: 'Ang iyong kaibigan ay nasangkot sa isang gulo (hindi krimen, kundi nakakahiya). Nakiusap siya sa iyo na magsinungaling sa oras at lugar para hindi siya mapahiya sa kanyang mga magulang.',
        q1Prompt: 'Ayon sa kwento, bakit humihingi ng tulong ang iyong kaibigan?',
        q1Options: [
          'Para hindi mapahiya sa mga magulang',
          'Para makaiwas sa kulong',
          'Para makakuha ng pera',
          'Para makaiwas sa trabaho',
        ],
        q1Correct: 0,
        options: [
          'Tanggihan ang hiling at sabihing hindi ka magsisinungaling',
          'Tulungan siya dahil ito ay maliit na bagay lang',
          'Sabihin sa magulang niya ang totoo',
          'Humingi ng pabor kapalit ng paggawa ng alibi',
        ],
        correctIdx: 0,
        worstIdx: 3,
        psychTerm: 'Integrity',
        why: 'Ang pagsasabi ng totoo kahit sa maliliit na bagay ay pagbuo ng karakter. Ang pagtanggi sa pagsisinungaling ay pagpapakita ng respeto sa katotohanan.',
        worstWhy: 'Ang paggawa ng alibi kapalit ng pabor ay pagbebenta ng iyong integridad. Ang pagsisinungaling ay nagsisimula sa maliit na bagay bago lumaki.',
      ),
_MoralDilemma(
        tagline: 'Nakita mong may naghihingalo sa kalsada habang nagmamadali ka sa isang mahalagang interview.',
        characters: 'Ikaw, ang nasugatan, at ang mga dumadaan',
        setup: 'May nakita kang lalaking nadapa at hindi kumikibo sa kalsada. Wala kang load sa phone at walang tao sa paligid. Kung tutulong ka, siguradong huli ka na sa interview na maaaring magpabago sa buhay mo.',
        q1Prompt: 'Ayon sa kwento, ano ang sitwasyon mo habang nakakita ng nasugatan?',
        q1Options: [
          'Nagmamadali sa isang mahalagang interview',
          'Papunta sa isang party',
          'Naglalakad papunta sa palengke',
          'Pauwi na galing sa trabaho',
        ],
        q1Correct: 0,
        options: [
          'Tumigil at tumulong hanggang may dumating na saklolo',
          'Ipagpatuloy ang paglalakad para hindi mawala ang pagkakataon sa trabaho',
          'Sigawan lang ang paligid at ituloy ang lakad',
          'Tumawag ng tulong sa pinakamalayong lugar',
        ],
        correctIdx: 0,
        worstIdx: 1,
        psychTerm: 'Responsibility',
        why: 'Ang buhay ng tao ay mas mahalaga kaysa sa anumang career opportunity. Ang pagtulong sa oras ng pangangailangan ay ang pinakamataas na anyo ng responsibilidad.',
        worstWhy: 'Ang pag-iwan sa isang taong naghihingalo para sa sariling ambisyon ay pagpili sa materyal na bagay kaysa sa buhay ng kapwa.',
      ),
_MoralDilemma(
        tagline: 'May nakita kang post sa social media na maling akusasyon sa isang kakilala.',
        characters: 'Ikaw, ang biktima, at ang mga netizens',
        setup: 'May kumalat na post na nagsasabing ang kakilala mo ay nagnanakaw sa opisina. Alam mong mali ito dahil kasama mo siya noong oras na iyon. Maraming tao na ang nag-share at naninira sa kanya.',
        q1Prompt: 'Ayon sa kwento, ano ang kumakalat na akusasyon sa kakilala mo?',
        q1Options: [
          'Nagnanakaw siya sa opisina',
          'Nagsisinungaling siya sa boss',
          'Nag-aaway siya sa katrabaho',
          'Huli siya sa pagpasok',
        ],
        q1Correct: 0,
        options: [
          'Mag-post ng patunay na hindi siya ang gumawa',
          'Ipagtanggol siya nang pribadong mensahe sa biktima',
          'Manahimik na lang para hindi ka madamay sa gulo',
          'Sumali sa paninira para magmukhang kampi ka sa nakararami',
        ],
        correctIdx: 0,
        worstIdx: 3,
        psychTerm: 'Fairness',
        why: 'Ang pagtayo para sa katotohanan sa gitna ng "cancel culture" ay pagpapakita ng fairness. Ang pag-correct sa maling impormasyon ay tumutulong sa biktima na mabawi ang kanyang dignidad.',
        worstWhy: 'Ang pagsali sa paninira para lang mag-fit in ay pagtalikod sa moralidad at pagpapatibay sa maling sistema ng paghusga.',
      ),
_MoralDilemma(
        tagline: 'Nakita mong ginagamit ng kasamahan mo ang printer ng opisina para sa kanyang side business.',
        characters: 'Ikaw, ang iyong kasamahan, at ang manager',
        setup: 'Ang iyong katrabaho ay gumagamit ng papel at tinta ng kompanya para sa kanyang sariling negosyo ng stickers. Maliit na bagay lang ito, pero araw-araw niya itong ginagawa.',
        q1Prompt: 'Ayon sa kwento, ano ang ginagamit ng kasamahan mo sa opisina?',
        q1Options: [
          'Printer ng opisina para sa side business',
          'Kuryente para sa sariling gadgets',
          'Internet para sa online games',
          'Kape ng boss para sa sarili',
        ],
        q1Correct: 0,
        options: [
          'Kausapin siya at sabihing hindi ito tama',
          'Iulat siya sa manager para hindi ka mapagbintangan',
          'Hayaan lang dahil maliit na bagay lang naman ito',
          'Humingi ng parte sa kita ng kanyang business',
        ],
        correctIdx: 0,
        worstIdx: 3,
        psychTerm: 'Honesty',
        why: 'Ang paggamit ng resources ng iba para sa sariling pakinabang ay mali, gaano man ito kaliit. Ang pagpapaalala sa kasamahan ay pagpapanatili ng etikal na kapaligiran sa trabaho.',
        worstWhy: 'Ang paghingi ng parte sa kita ay pag-apruba sa pagnanakaw at paggawa nitong transaksyon para sa sariling pakinabang.',
      ),
_MoralDilemma(
        tagline: 'Nakita mong may nakalimutang gamit ang isang estranghero sa taxi.',
        characters: 'Ikaw, ang driver ng taxi, at ang estranghero',
        setup: 'May naiwang envelope na may perang pang-matrikula ang isang pasahero sa taxi. Alam ng driver kung sino ang pasahero dahil may record ng booking, pero gusto niyang hatiin ang pera sa iyo.',
        q1Prompt: 'Ayon sa kwento, ano ang naiwan ng pasahero sa taxi?',
        q1Options: [
          'Envelope na may perang pang-matrikula',
          'Isang mamahaling relo',
          'Susi ng bahay at kotse',
          'Bag na may mga dokumento',
        ],
        q1Correct: 0,
        options: [
          'Hilingin sa driver na ibalik ang pera sa pasahero',
          'Tanggapin ang hati ng pera dahil hindi mo naman ninakaw',
          'Kuhanin ang lahat ng pera at iwan ang driver',
          'Ibigay ang pera sa isang charity',
        ],
        correctIdx: 0,
        worstIdx: 2,
        psychTerm: 'Integrity',
        why: 'Ang integridad ay ang paggawa ng tama kahit may pagkakataong kumita nang madali. Ang pag-uwi ng pera sa may-ari ay pagpapakita ng respeto sa pinaghirapan ng iba.',
        worstWhy: 'Ang pagkuha ng lahat ng pera at pag-iwan sa driver ay pagtatraydor sa kasama at pagnanakaw sa taong nangangailangan.',
      ),
_MoralDilemma(
        tagline: 'Nalaman mong may mali sa computation ng iyong bonus.',
        characters: 'Ikaw, ang accountant, at ang iyong boss',
        setup: 'Nagkamali ang accountant at binigyan ka ng bonus na doble kaysa sa nararapat. Hindi ito napansin ng boss mo at siguradong hindi na ito mababawi kung hindi mo sasabihin.',
        q1Prompt: 'Ayon sa kwento, ano ang nangyari sa iyong bonus?',
        q1Options: [
          'Dobleng bonus ang natanggap',
          'Kulang ang natanggap na bonus',
          'Maling account ang napadalhan',
          'Wala kang natanggap na bonus',
        ],
        q1Correct: 0,
        options: [
          'Ipaalam sa accountant ang pagkakamali at ibalik ang sobra',
          'Itago ang pera bilang reward sa iyong paghihirap',
          'I-donate ang sobra sa isang kawanggawa',
          'Hatiin ang pera sa iyong mga kasamahan',
        ],
        correctIdx: 0,
        worstIdx: 1,
        psychTerm: 'Honesty',
        why: 'Ang katapatan sa maliit na bagay ay pundasyon ng tiwala sa trabaho. Ang pag-ulat sa mali ay nagpapakita na mas mahalaga sa iyo ang integridad kaysa sa pera.',
        worstWhy: 'Ang pag-aakalang "reward" ito ay pagbibigay-katwiran sa pagkakamali ng iba para sa sariling pakinabang.',
      ),
_MoralDilemma(
        tagline: 'Nakita mong may nadulas na dokumento ng isang kliyente na may sensitibong impormasyon.',
        characters: 'Ikaw, ang kliyente, at ang iyong katrabaho',
        setup: 'May nakita kang dokumento sa printer na may sensitibong impormasyon ng isang kliyente. Ang nag-print nito ay ang iyong katrabaho na kilala sa pagiging pabaya. Wala pang nakakakita nito kundi ikaw.',
        q1Prompt: 'Ayon sa kwento, ano ang nakita mo sa printer?',
        q1Options: [
          'Dokumentong may sensitibong impormasyon',
          'Maling report ng budget',
          'Sulat para sa manager',
          'Blankong papel na may tinta',
        ],
        q1Correct: 0,
        options: [
          'Ibalik ang dokumento sa may-ari at paalalahanan siya',
          'Ipakita ang dokumento sa iba para mapahiya ang katrabaho',
          'Itago ang dokumento para magamit bilang leverage',
          'Itapon na lang ang papel para hindi na magkaroon ng gulo',
        ],
        correctIdx: 0,
        worstIdx: 2,
        psychTerm: 'Professionalism',
        why: 'Ang pagprotekta sa impormasyon ng kliyente ay bahagi ng propesyonalismo. Ang pag-uwi ng dokumento nang walang ingay ay nagpapakita ng paggalang sa privacy at etika ng trabaho.',
        worstWhy: 'Ang paggamit ng sensitibong impormasyon bilang leverage ay blackmail at isang seryosong paglabag sa etika ng propesyon.',
      ),
_MoralDilemma(
        tagline: 'May nakita kang bata na umiiyak dahil nawawala ang kanyang magulang sa mall.',
        characters: 'Ikaw, ang bata, at ang security guard',
        setup: 'Isang batang nasa edad na lima ang umiiyak sa gitna ng mall. Mukhang naliligaw siya at wala siyang dalang kahit anong identification. Maraming tao ang dumadaan pero walang tumitigil.',
        q1Prompt: 'Ayon sa kwento, ano ang kalagayan ng bata?',
        q1Options: [
          'Umiiyak at nawawala ang magulang',
          'Naghahanap ng laruan',
          'Kasama ang isang estranghero',
          'Nakatulog sa bench',
        ],
        q1Correct: 0,
        options: [
          'Samahan ang bata at dalhin sa nearest security guard',
          'Hayaan ang bata at asahan na may makakakita rin',
          'Bigyan ng kendi ang bata at iwanan siya',
          'Hanapin ang magulang sa pamamagitan ng pag-sigaw sa mall',
        ],
        correctIdx: 0,
        worstIdx: 1,
        psychTerm: 'Responsibility',
        why: 'Ang pagtulong sa isang bulnerableng tao ay isang batayang responsibilidad. Ang pagsama sa bata hanggang sa makarating sa awtoridad ang pinakaligtas at pinakamabilis na paraan.',
        worstWhy: 'Ang pag-iwan sa bata sa paniniwalang "may makakakita rin" ay pagpapabaya sa seguridad ng isang bata.',
      ),
_MoralDilemma(
        tagline: 'Nalaman mong may maling impormasyon sa isang news report tungkol sa iyong barangay.',
        characters: 'Ikaw, ang reporter, at ang mga residente',
        setup: 'May lumabas na balita sa internet na nagsasabing may outbreak ng sakit sa inyong barangay. Alam mong mali ito at gawa-gawa lamang, ngunit nagdudulot na ito ng panic at pag-iwas ng mga tao sa inyo.',
        q1Prompt: 'Ayon sa kwento, ano ang kumalat na balita tungkol sa barangay?',
        q1Options: [
          'May outbreak ng sakit',
          'May malaking sunog',
          'May baha sa kalsada',
          'May nag-aalok ng trabaho',
        ],
        q1Correct: 0,
        options: [
          'Makipag-ugnayan sa reporter at magbigay ng tamang impormasyon',
          'Ipagwalang-bahala ang balita dahil hindi ka naman apektado',
          'Sumali sa panic at mag-post din ng mga babala',
          'Awayin ang reporter sa comments section ng post',
        ],
        correctIdx: 0,
        worstIdx: 2,
        psychTerm: 'Civic duty',
        why: 'Ang pagwawasto ng maling impormasyon (fake news) ay bahagi ng tungkulin ng isang mamamayan. Ang pagbibigay ng tamang datos ay nakakatulong sa komunidad na bumalik sa normal.',
        worstWhy: 'Ang pagsali sa panic ay nagpapalala sa problema at nagpapakalat ng takot na walang basehan.',
      )
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
_DeceptionScene(
        event: 'pagnanakaw ng gadgets sa dorm',
        places: [
          'isang dorm sa Quezon City',
          'isang dorm sa Maynila',
          'isang dorm sa Baguio',
          'isang dorm sa Iloilo',
        ],
        whoInformed: 'IT specialist ng dorm',
        trueDetail: 'ang video na "live" ay na-record na ilang araw bago ang insidente',
        liarClaim: 'nakita niyang live-stream siya ng gaming session noong oras na iyon',
        q1Wrongs: [
          'may glitch ang internet',
          'hindi siya nakita sa camera',
          'mali ang timestamp ng video',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw sa bahay na mukhang inambush',
        places: [
          'isang bahay sa Cavite',
          'isang bahay sa Laguna',
          'isang bahay sa Bulacan',
          'isang bahay sa Batangas',
        ],
        whoInformed: 'ophthalmologist',
        trueDetail: 'ang contact lens ay nasa loob pa ng mata ng biktima, ngunit ang contact lens case sa mesa ay bukas at walang laman',
        liarClaim: 'nakita niyang nag-aayos na ng tulog ang biktima at tinanggal na ang mga lens',
        q1Wrongs: [
          'basag ang salamin ng bintana',
          'nakabukas ang pinto ng bahay',
          'may bakas ng sapatos sa putik',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw ng manok sa farm',
        places: [
          'isang farm sa Isabela',
          'isang farm sa Nueva Ecija',
          'isang farm sa Tarlac',
          'isang farm sa Pangasinan',
        ],
        whoInformed: 'behavioral analyst',
        trueDetail: 'ang apat na saksi ay nagbigay ng eksaktong salita-salita na kwento — isang pattern ng inensayong alibi',
        liarClaim: 'nakita niya ang magnanakaw na tumatakbo palayo habang kasama ang ibang saksi',
        q1Wrongs: [
          'magkakaiba ang oras ng pagdating',
          'walang nakakita sa magnanakaw',
          'mali ang kulay ng manok',
        ],
      ),
_DeceptionScene(
        event: 'paninira ng tindahan ng magulang',
        places: [
          'isang tindahan sa Pampanga',
          'isang tindahan sa Zambales',
          'isang tindahan sa Bataan',
          'isang tindahan sa Tarlac',
        ],
        whoInformed: 'dispatcher ng 911',
        trueDetail: 'ang pagtawag sa pulis ay 3 minuto lang matapos ang orasan ng krimen — masyadong mabilis para sa isang taong hindi alam ang nangyari',
        liarClaim: 'nagulat siya nang makita ang sira at agad tumawag ng tulong',
        q1Wrongs: [
          'walang signal ang phone',
          'maling numero ang natawagan',
          'matagal bago sumagot ang pulis',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw sa warehouse',
        places: [
          'isang warehouse sa Binondo',
          'isang warehouse sa Valenzuela',
          'isang warehouse sa Pasig',
          'isang warehouse sa Marikina',
        ],
        whoInformed: 'CCTV forensic expert',
        trueDetail: 'ang footage ng CCTV ay isang loop na paulit-ulit na playback ng nakaraang oras',
        // liarClaim and q1Wrongs shifted slightly
        liarClaim: 'kita sa CCTV na walang pumasok sa warehouse nang oras na iyon',
        q1Wrongs: [
          'malabo ang resolution ng camera',
          'may putol na wire sa CCTV',
          'madilim ang paligid ng warehouse',
        ],
      ),
_DeceptionScene(
        event: 'paninira ng gamit sa opisina',
        places: [
          'isang opisina sa Makati',
          'isang opisina sa BGC',
          'isang opisina sa Ortigas',
          'isang opisina sa Pasay',
        ],
        whoInformed: 'fitness app analyst',
        trueDetail: 'ang fitness tracker ay nagtala ng libu-libong hakbang nang oras na sinasabi niyang natutulog siya',
        liarClaim: 'natutulog siya sa bahay nang mangyari ang paninira',
        q1Wrongs: [
          'walang baterya ang tracker',
          'mali ang oras ng app',
          'hindi niya suot ang tracker',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw sa palengke ng itlog',
        places: [
          'isang palengke sa Navotas',
          'isang palengke sa Quiapo',
          'isang palengke sa Baguio',
          'isang palengke sa Cebu',
        ],
        whoInformed: 'bus driver at CCTV',
        trueDetail: 'nakuhang sumakay ang suspect sa bus pabalik-balik sa lugar ng krimen sa oras na sinasabi niyang wala siya doon',
        liarClaim: 'nasa kabilang bayan siya at hindi nakapunta sa palengke',
        q1Wrongs: [
          'walang ticket ang sumakay',
          'mali ang plaka ng bus',
          'hindi malinaw ang mukha sa CCTV',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw sa simbahan ng donasyon',
        places: [
          'isang simbahan sa Bulacan',
          'isang simbahan sa Tarlac',
          'isang simbahan sa Pangasinan',
          'isang simbahan sa Ilocos',
        ],
        whoInformed: 'parokya ng simbahan',
        trueDetail: 'ang anonymous na sulat ay may mga detalyeng tanging ang pumatay/magnanakaw lang ang nakakaalam',
        liarClaim: 'nakita niyang may pumasok na estranghero sa pinto ng simbahan',
        q1Wrongs: [
          'walang pirma ang sulat',
          'maling tinta ang ginamit',
          'hindi nabasa ang sulat',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw ng laptop sa opisina',
        places: [
          'isang opisina sa Quezon City',
          'isang opisina sa Pasig',
          'isang opisina sa Makati',
          'isang opisina sa Taguig',
        ],
        whoInformed: 'digital forensic analyst',
        trueDetail: 'ang metadata ng file na iniwan ay nagmula sa computer na tanging ang suspect lang ang may access',
        liarClaim: 'hindi siya gumamit ng computer noong araw na iyon',
        q1Wrongs: [
          'sira ang hard drive',
          'may virus ang laptop',
          'maling format ng file',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw sa bahay na may candela',
        places: [
          'isang bahay sa Laguna',
          'isang bahay sa Batangas',
          'isang bahay sa Rizal',
          'isang bahay sa Quezon',
        ],
        whoInformed: 'crime lab analyst',
        trueDetail: 'may natagpuang upos ng sigarilyo sa bintana na tumugma sa DNA ng suspect',
        liarClaim: 'hindi siya kailanman nakapunta sa bahay na iyon',
        q1Wrongs: [
          'hindi naninigarilyo ang suspect',
          'mali ang brand ng sigarilyo',
          'nabasa ng ulan ang upos',
        ],
      ),
_DeceptionScene(
        event: 'paninira ng halamanan ng resort',
        places: [
          'isang resort sa Palawan',
          'isang resort sa Boracay',
          'isang resort sa Bohol',
          'isang resort sa Cebu',
        ],
        whoInformed: 'social media investigator',
        trueDetail: 'may Facebook post ang suspect na nagpapakita sa kanya sa lugar nang oras na sinasabi niyang nasa probinsya siya',
        liarClaim: 'nasa malayo siyang probinsya at hindi nakapunta sa resort',
        q1Wrongs: [
          'private ang kanyang account',
          'mali ang date ng post',
          'hindi siya ang nasa larawan',
        ],
      ),
_DeceptionScene(
        event: 'pagkasira ng inumin sa isang handaan',
        places: [
          'isang handaan sa Cavite',
          'isang handaan sa Bulacan',
          'isang handaan sa Laguna',
          'isang handaan sa Rizal',
        ],
        whoInformed: 'food analyst',
        trueDetail: 'ang inumin ay may halong pait na substance na tanging ang suspect lang ang may supply',
        liarClaim: 'nakita niyang may naglagay ng asukal sa inumin kaya hindi siya nagsalita',
        q1Wrongs: [
          'wala pang lasa ang inumin',
          'maling baso ang ginamit',
          'may amoy na kakaiba',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw sa bahay ng kapitbahay',
        places: [
          'isang bahay sa Pasay',
          'isang bahay sa Parañaque',
          'isang bahay sa Las Piñas',
          'isang bahay sa Muntinlupa',
        ],
        whoInformed: 'airport security',
        trueDetail: 'ang may-ari ng bahay ay nasa airport na simula alas-otso, pero claims ang suspect na nakausap niya ito ng alas-diyes',
        liarClaim: 'nakita niyang nasa bahay pa ang may-ari nang alas-diyes',
        q1Wrongs: [
          'sarado ang telepono',
          'maling oras ang boarding pass',
          'walang record ng flight',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw ng alahas sa shop',
        places: [
          'isang jewelry shop sa Makati',
          'isang jewelry shop sa QC',
          'isang jewelry shop sa Pasay',
          'isang jewelry shop sa BGC',
        ],
        whoInformed: 'may-ari ng shop',
        trueDetail: 'ang loob ng safe ay kulay asul, ngunit binanggit ng suspect na "puti ang loob ng safe" nang magkwento',
        liarClaim: 'nakita niyang bukas ang safe kaya kinuha ang alahas',
        q1Wrongs: [
          'wala ring susi ang safe',
          'nakasara ang pinto',
          'maling brand ng safe',
        ],
      ),
_DeceptionScene(
        event: 'paninira ng kape sa opisina',
        places: [
          'isang opisina sa Pasig',
          'isang opisina sa Makati',
          'isang opisina sa QC',
          'isang opisina sa Taguig',
        ],
        whoInformed: 'office manager',
        trueDetail: 'ang kape ay nilagyan ng asin, ngunit ang suspect ay nagsabing "sobrang tamis" ng kape nang tikman niya',
        liarClaim: 'nakita niyang may naglagay ng asukal sa kape',
        q1Wrongs: [
          'mapait ang kape',
          'wala nang asukal sa opisina',
          'mali ang tasa',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw sa tindahan ng gulay',
        places: [
          'isang tindahan sa Quezon City',
          'isang tindahan sa Pasay',
          'isang tindahan sa Manila',
          'isang tindahan sa Makati',
        ],
        whoInformed: 'accountant ng tindahan',
        trueDetail: 'ang lahat ng resibo at bills ay naka-exact sequence na masyadong perpekto para sa isang normal na lakad',
        liarClaim: 'nakita niyang may pumasok na tao habang siya ay bumibili sa kabilang tindahan',
        q1Wrongs: [
          'walang timestamp ang resibo',
          'maling petsa ang nakasulat',
          'hindi tugma ang presyo',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw ng sapi sa bodega',
        places: [
          'isang bodega sa Binondo',
          'isang bodega sa Valenzuela',
          'isang bodega sa Pasig',
          'isang bodega sa Marikina',
        ],
        whoInformed: 'locksmith expert',
        trueDetail: 'ang kandado ay nabasag mula sa LOOB ng bodega, hindi mula sa labas',
        liarClaim: 'nakita niyang may pumasok sa pinto gamit ang master key',
        q1Wrongs: [
          'may duplicate na susi',
          'sira ang pinto ng bodega',
          'nakabukas ang bintana',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw sa opisina sa pangalawang palapag',
        places: [
          'isang opisina sa BGC',
          'isang opisina sa Makati',
          'isang opisina sa Pasay',
          'isang opisina sa Taguig',
        ],
        whoInformed: 'janitor ng gusali',
        trueDetail: 'basa ang sahig ng palapag 1 pero tuyo ang hagdan patungo sa palapag 2, kaya imposibleng dumaan ang suspect na basa ang sapatos',
        liarClaim: 'nakita niyang tumakbo ang magnanakaw pababa ng hagdan',
        q1Wrongs: [
          'walang bakas ng putik',
          'maling oras ng ulan',
          'malinis ang sapatos',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw ng kotse ng kapitbahay',
        places: [
          'isang bahay sa Cavite',
          'isang bahay sa Laguna',
          'isang bahay sa Rizal',
          'isang bahay sa Quezon',
        ],
        whoInformed: 'mekaniko',
        trueDetail: 'mainit ang makina ng kotse kahit sinabing hindi ito ginamit sa loob ng isang linggo',
        liarClaim: 'hindi niya ginamit ang kotse at nakaparada lang ito doon',
        q1Wrongs: [
          'sira ang radiator',
          'walang gasolina ang kotse',
          'maling plaka ng sasakyan',
        ],
      ),
_DeceptionScene(
        event: 'pagnanakaw sa tindahan ng damit',
        places: [
          'isang boutique sa Makati',
          'isang boutique sa QC',
          'isang boutique sa Pasay',
          'isang boutique sa BGC',
        ],
        whoInformed: 'weather bureau record',
        trueDetail: 'umulan nang malakas noong Lunes, ngunit ang suspect ay nagsabing "mainit at maaraw ang panahon" nang oras ng krimen',
        liarClaim: 'nakita niyang may pumasok na tao habang maaraw ang panahon',
        q1Wrongs: [
          'mali ang oras ng ulan',
          'walang ulan sa lugar',
          'mali ang petsa ng report',
        ],
      )
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
_Riddle(
      title: 'Ang Dalawang Pintuan (Liar/Truth)',
      story: 'May dalawang pintuan: ang isa ay papunta sa kalayaan at ang isa ay papunta sa kamatayan. May dalawang guwardiya sa bawat pinto. Ang isa ay laging nagsasabi ng totoo, at ang isa ay laging nagsisinungaling. Maaari ka lang magtanong ng ISANG tanong sa ISANG guwardiya para malaman kung alin ang pinto ng kalayaan.',
      q1Prompt: 'Ayon sa kwento, ano ang katangian ng dalawang guwardiya?',
      q1Options: [
        'Ang isa ay laging nagsasabi ng totoo at ang isa ay laging nagsisinungaling',
        'Pareho silang nagsasabi ng totoo',
        'Pareho silang nagsisinungaling',
        'Hindi nila alam ang tamang pinto',
      ],
      q1Correct: 0,
      prompt: 'Ano ang dapat mong itanong para malaman ang pinto ng kalayaan?',
      options: [
        'Itanong sa isa: "Kung tatanungin ko ang kabilang guwardiya, alin ang pinto ng kalayaan?" — at piliin ang KABALIGTARAAN ng isasagot niya',
        'Itanong sa isa: "Saan ang pinto ng kalayaan?" — at maniwala agad sa sagot',
        'Tumingin sa mga mata ng guwardiya para malaman kung sino ang nagsisinungaling',
        'Tangkain na buksan ang dalawang pinto nang sabay',
      ],
      correctIdx: 0,
      answerExplanation: 'Anumang guwardiya ang tanungin mo, ang isasagot nila ay ang pinto ng KAMATAYAN. Bakit? Kasi ang nagsasabi ng totoo ay sasabihin ang kasinungalingan ng kabilang guwardiya. Ang nagsisinungaling naman ay pagsisinungalingan ang katotohanan ng kabilang guwardiya. Kaya ang laging sagot ay mali, at dapat piliin ang kabilang pinto.',
      psychPrompt: 'Aling psychological concept ang ginagamit dito para malutas ang problema?',
      psychOptions: [
        'Logical deduction through contradiction',
        'Confirmation bias',
        'Emotional reasoning',
        'Hasty generalization',
      ],
      psychCorrect: 0,
      psychExplain: 'Ito ay isang logic puzzle na gumagamit ng "contradiction" para ma-neutralize ang kasinungalingan. Ginagamit ang mismong katangian ng nagsisinungaling para makuha ang katotohanan.',
      q4Prompt: 'Ano ang pinaka-mahalagang detalye para gumana ang solusyong ito?',
      q4Options: [
        'Ang katotohanang may isang nagsisinungaling at isang tapat',
        'Ang bilang ng mga pinto',
        'Ang itsura ng mga guwardiya',
        'Ang oras ng pagtatanong',
      ],
      q4Correct: 0,
      q4Explain: 'Kung hindi mo alam na may isang nagsisinungaling at isang tapat, hindi mo magagamit ang logic ng "contradiction" para makuha ang tamang sagot.',
    ),
_Riddle(
      title: 'Ang Apat na Pusa sa Sulok',
      story: 'May isang parisukat na bahay. Sa bawat sulok ng bahay, mayroong isang pusa. Sa harap ng bawat pusa, mayroong tatlong pusa. Ilang pusa ang nasa loob ng bahay?',
      q1Prompt: 'Ayon sa kwento, ilang pusa ang nasa bawat sulok ng bahay?',
      q1Options: [
        'Isang pusa',
        'Dalawang pusa',
        'Tatlong pusa',
        'Apat na pusa',
      ],
      q1Correct: 0,
      prompt: 'Ilang pusa ang nasa loob ng bahay?',
      options: [
        '4 na pusa — dahil ang bawat pusa sa sulok ay nakaharap sa tatlo pang pusa',
        '12 na pusa — dahil 4 x 3 = 12',
        '16 na pusa — dahil 4 na sulok x 4 na pusa',
        '8 na pusa — dahil dalawang pusa sa bawat sulok',
      ],
      correctIdx: 0,
      answerExplanation: 'Isipin ang parisukat. May pusa sa bawat sulok (A, B, C, D). Si A ay nakaharap kina B, C, at D. Si B ay nakaharap kina A, C, at D. Ganun din sina C at D. Sa kabuuan, apat lang na pusa ang kailangan para magkaroon ng tatlong pusa sa harap ng bawat isa.',
      psychPrompt: 'Bakit maraming tao ang sumasagot ng 12 sa palaisipang ito?',
      psychOptions: [
        'Dahil sa "automatic calculation" o multiplicative thinking',
        'Dahil sa sobrang pag-iisip ng detalye',
        'Dahil sa maling pag-unawa sa salitang "sulok"',
        'Dahil sa takot sa maling sagot',
      ],
      psychCorrect: 0,
      psychExplain: 'Ang utak ay madalas gumamit ng "shortcuts" (heuristics). Kapag narinig ang "apat" at "tatlo," ang automatic na response ay multiplication (4x3) sa halip na visualization ng spatial arrangement.',
      q4Prompt: 'Ano ang pinaka-mahalagang kasanayan para malutas ito?',
      q4Options: [
        'Spatial visualization',
        'Fast calculation',
        'Reading comprehension',
        'Memory recall',
      ],
      q4Correct: 0,
      q4Explain: 'Kailangan mong i-visualize ang posisyon ng mga pusa sa loob ng isang parisukat para makita na apat lang sila.',
    ),
_Riddle(
      title: 'Ang Kahong Mali ang Label',
      story: 'May tatlong kahon ng prutas: isang may mansanas, isang may dalandan, at isang may halo (mansanas at dalandan). Ang lahat ng label sa mga kahon ay MALI. Kumuha ka ng isang prutas mula sa isang kahon nang hindi tumitingin. Paano mo malalaman ang tamang label ng lahat ng kahon?',
      q1Prompt: 'Ayon sa kwento, ano ang katayuan ng mga label sa mga kahon?',
      q1Options: [
        'Lahat ng label ay MALI',
        'Lahat ng label ay TAMA',
        'Isa lang ang mali',
        'Dalawa ang mali',
      ],
      q1Correct: 0,
      prompt: 'Ano ang unang dapat mong gawin?',
      options: [
        'Kumuha ng isang prutas mula sa kahon na may label na "HALO"',
        'Kumuha ng prutas mula sa kahon ng "MANSANA"',
        'Kumuha ng prutas mula sa kahon ng "DANDALAN"',
        'Buksan ang lahat ng kahon nang sabay-sabay',
      ],
      correctIdx: 0,
      answerExplanation: 'Kumuha ka sa kahon ng "HALO". Dahil alam mong MALI ang label, ang laman nito ay maaaring puro mansanas o puro dalandan. Kung mansanas ang nakuha mo, ang kahon na iyon ay MANSANAS. Ang kahon na may label na "DANDALAN" ay hindi maaaring dalandan (mali label) at hindi rin mansanas (dahil nahanap mo na), kaya ito ang HALO. Ang huling kahon (label "MANSANA") ay DANDALAN.',
      psychPrompt: 'Aling cognitive process ang ginamit dito?',
      psychOptions: [
        'Process of elimination',
        'Confirmation bias',
        'Trial and error',
        'Hasty generalization',
      ],
      psychCorrect: 0,
      psychExplain: 'Ginagamit ang "process of elimination" kung saan inaalis ang mga imposibleng opsyon base sa isang siguradong katotohanan (ang label ay mali).',
      q4Prompt: 'Ano ang pinaka-mahalagang detalye sa solusyong ito?',
      q4Options: [
        'Ang katotohanang lahat ng label ay MALI',
        'Ang bilang ng mga prutas sa loob',
        'Ang kulay ng mga kahon',
        'Ang laki ng mga prutas',
      ],
      q4Correct: 0,
      q4Explain: 'Ang pag-alam na lahat ay mali ang nagbibigay ng entry point para sa solusyon.',
    ),
_Riddle(
      title: 'Ang Siruhano at ang Anak',
      story: 'Isang ama at ang kanyang anak na lalaki ang naaksidente sa kotse. Namatay ang ama. Dinala ang anak sa ospital at pagdating doon, sinabi ng siruhano (surgeon), "Hindi ko siya maaaring operahan, anak ko siya!"',
      q1Prompt: 'Ayon sa kwento, ano ang nangyari sa ama?',
      q1Options: [
        'Namatay siya sa aksidente',
        'Nakaligtas siya sa aksidente',
        'Nasa ospital siya',
        'Wala siyang kasamang anak',
      ],
      q1Correct: 0,
      prompt: 'Sino ang siruhano?',
      options: [
        'Ang ina ng bata',
        'Ang lolo ng bata',
        'Ang tiyuhin ng bata',
        'Isang estranghero',
      ],
      correctIdx: 0,
      answerExplanation: 'Ang siruhano ay ang INA ng bata. Ang riddle na ito ay gumagana dahil sa "gender bias" — marami ang awtomatikong nag-iisip na ang siruhano ay lalaki, kaya nalilito sila kung paanong anak niya ang bata kung patay na ang ama.',
      psychPrompt: 'Bakit nahihirapan ang maraming tao na sagutin ito?',
      psychOptions: [
        'Dahil sa implicit bias (gender stereotype)',
        'Dahil sa kawalan ng medical knowledge',
        'Dahil sa sobrang pag-iisip ng aksidente',
        'Dahil sa maling pag-unawa sa salitang "ama"',
      ],
      psychCorrect: 0,
      psychExplain: 'Implicit bias ay ang hindi malay na asosyasyon ng utak (hal. Surgeon = Lalaki). Nililimitahan nito ang pag-iisip sa mga posibleng sagot.',
      q4Prompt: 'Ano ang aral ng palaisipang ito sa pag-iisip?',
      q4Options: [
        'Huwag magpadala sa stereotypes',
        'Laging magtanong sa doktor',
        'Mag-ingat sa pagda-drive',
        'Maging mabilis sa pag-iisip',
      ],
      q4Correct: 0,
      q4Explain: 'Tinuturuan tayo nito na suriin ang ating mga assumptions at huwag hayaan ng bias ang ating lohika.',
    ),
_Riddle(
      title: 'Ang Uwak at ang Pitcher',
      story: 'Isang uhaw na uwak ang nakakita ng isang pitsel na may kaunting tubig sa ilalim. Hindi maabot ng tuka ng uwak ang tubig. May mga maliliit na bato sa paligid. Paano niya nainom ang tubig?',
      q1Prompt: 'Ayon sa kwento, bakit hindi mainom ng uwak ang tubig?',
      q1Options: [
        'Hindi maabot ng tuka ang tubig sa ilalim',
        'Masyadong marami ang tubig',
        'Wala nang tubig sa pitsel',
        'Masyadong mataas ang pitsel',
      ],
      q1Correct: 0,
      prompt: 'Ano ang ginawa ng uwak para mainom ang tubig?',
      options: [
        'Hulog nang hulog ng maliliit na bato sa pitsel hanggang tumaas ang tubig',
        'Basagin ang pitsel para lumabas ang tubig',
        'Tumawag ng ibang uwak para tumulong',
        'Hintayin ang ulan para mapuno ang pitsel',
      ],
      correctIdx: 0,
      answerExplanation: 'Sa pamamagan ng paghulog ng mga bato, ang volume ng tubig ay itinulak paitaas (displacement). Ito ay isang halimbawa ng basic physics at problem-solving.',
      psychPrompt: 'Aling kasanayan ang ipinakita ng uwak?',
      psychOptions: [
        'Adaptive problem solving',
        'Trial and error',
        'Instinctive behavior',
        'Random chance',
      ],
      psychCorrect: 0,
      psychExplain: 'Ang paggamit ng tool (bato) para baguhin ang kapaligiran upang makuha ang layunin ay tinatawag na adaptive problem solving.',
      q4Prompt: 'Ano ang pinaka-mahalagang detalye sa solusyong ito?',
      q4Options: [
        'Ang pagtaas ng tubig dahil sa mga bato',
        'Ang kulay ng pitsel',
        'Ang laki ng uwak',
        'Ang dami ng tubig sa simula',
      ],
      q4Correct: 0,
      q4Explain: 'Ang displacement ng tubig ang susi. Kung walang mga bato, hindi tataas ang tubig.',
    ),
_Riddle(
      title: 'Ang Dalawang Ama at Dalawang Anak',
      story: 'May tatlong tao sa isang bangka: dalawang ama at dalawang anak. Ngunit walang babae sa bangka.',
      q1Prompt: 'Ayon sa kwento, ilang tao ang nasa bangka?',
      q1Options: [
        'Tatlong tao',
        'Apat na tao',
        'Limang tao',
        'Dalawang tao',
      ],
      q1Correct: 0,
      prompt: 'Paano nangyari na may dalawang ama at dalawang anak pero tatlo lang sila?',
      options: [
        'Lolo, Ama, at Anak (ang Ama ay anak ng Lolo at ama ng Anak)',
        'Dalawang magkapatid na ama at isang anak',
        'Isang ama na may dalawang anak na lalaki',
        'Isang ama at isang anak na may kasamang estranghero',
      ],
      correctIdx: 0,
      answerExplanation: 'Lolo -> Ama -> Anak. Ang Ama ay anak ng Lolo (1 anak) at ama ng Anak (1 ama). Ang Lolo ay ama rin. So: 2 Ama (Lolo at Ama) at 2 Anak (Ama at Anak).',
      psychPrompt: 'Bakit nakakalito ang palaisipang ito?',
      psychOptions: [
        'Dahil sa assumption na ang "ama" at "anak" ay magkahiwalay na tao',
        'Dahil sa maling bilang ng tao',
        'Dahil sa kawalan ng babae',
        'Dahil sa laki ng bangka',
      ],
      psychCorrect: 0,
      psychExplain: 'Ang utak ay madalas na nag-aassign ng isang role sa bawat tao. Hindi nito agad naiisip na ang isang tao ay maaaring may dalawang role (ama at anak) nang sabay.',
      q4Prompt: 'Ano ang aral ng palaisipang ito?',
      q4Options: [
        'Tingnan ang ugnayan ng mga tao (roles)',
        'Huwag magtiwala sa bilang',
        'Laging may kasamang lolo',
        'Maging mabilis sa pagbibilang',
      ],
      q4Correct: 0,
      q4Explain: 'Itinuturo nito ang kahalagahan ng pag-unawa sa hierarchy at overlapping roles sa pamilya.',
    ),
_Riddle(
      title: 'Ang Bakas sa Niyebe',
      story: 'Isang lalaki ang naglalakad sa isang malawak at malinis na field ng niyebe. May mga bakas ng paa papunta sa isang bahay, ngunit walang bakas na pabalik, kahit na alam nating nakabalik siya sa kanyang pinagmulan.',
      q1Prompt: 'Ayon sa kwento, ano ang nakita sa niyebe?',
      q1Options: [
        'May bakas papunta sa bahay ngunit walang pabalik',
        'Walang bakas ng paa',
        'May bakas ng sasakyan',
        'May bakas ng hayop',
      ],
      q1Correct: 0,
      prompt: 'Paano siya nakabalik nang walang naiwang bakas?',
      options: [
        'Naglakad siya pabalik sa eksaktong bakas ng kanyang pagpunta',
        'Lumipad siya pabalik gamit ang parachute',
        'Naglakad siya sa gilid ng field na walang niyebe',
        'Sinuot niya ang sapatos na pabaliktad',
      ],
      correctIdx: 0,
      answerExplanation: 'Naglakad siya pabalik sa mismong bakas na ginawa niya nang papunta sa bahay. Kaya sa paningin ng observer, isa lang ang set ng bakas.',
      psychPrompt: 'Anong cognitive trap ang ginamit dito?',
      psychOptions: [
        'Linear thinking (iniisip na ang pag-alis ay dapat gumawa ng bagong bakas)',
        'Confirmation bias',
        'Over-complicating the problem',
        'Implicit memory',
      ],
      psychCorrect: 0,
      psychExplain: 'Linear thinking ay ang pag-assume na ang bawat kilos ay gumagawa ng bagong ebidensya. Dito, ang pag-uulit ng landas ang solusyon.',
      q4Prompt: 'Ano ang pinaka-mahalagang detalye sa solusyong ito?',
      q4Options: [
        'Ang pag-uulit ng landas',
        'Ang kulay ng niyebe',
        'Ang laki ng sapatos',
        'Ang oras ng paglalakad',
      ],
      q4Correct: 0,
      q4Explain: 'Ang pag-overlap ng mga bakas ang nagtatanggal ng ebidensya ng pag-uwi.',
    ),
_Riddle(
      title: 'Ang 5-Litre at 3-Litre na Lalagyan',
      story: 'Mayroon kang dalawang lalagyan ng tubig: isang 5-litro at isang 3-litro. Kailangan mong makakuha ng eksaktong 4 na litro ng tubig. Paano mo ito gagawin?',
      q1Prompt: 'Ayon sa kwento, ano ang sukat ng dalawang lalagyan?',
      q1Options: [
        '5-litro at 3-litro',
        '4-litro at 2-litro',
        '6-litro at 1-litro',
        '10-litro at 5-litro',
      ],
      q1Correct: 0,
      prompt: 'Ano ang sequence ng paglilipat ng tubig?',
      options: [
        'Punuin ang 5L, isalin sa 3L (maiwan 2L), itapon ang 3L, isalin ang 2L sa 3L, punuin ang 5L, isalin sa 3L hanggang mapuno (maiwan 4L)',
        'Punuin ang 3L, isalin sa 5L, ulitin hanggang mapuno ang 5L',
        'Hatiin ang 5L sa dalawa',
        'Gumamit ng ruler para sukatin ang 4L',
      ],
      correctIdx: 0,
      answerExplanation: 'Step 1: 5L full, 3L empty. Step 2: 5L -> 3L (5L has 2L left). Step 3: Empty 3L. Step 4: 2L -> 3L (3L has 2L). Step 5: 5L full. Step 6: 5L -> 3L (3L only needs 1L, so 5L left with 4L).',
      psychPrompt: 'Aling kasanayan ang kailangan dito?',
      psychOptions: [
        'Algorithmic thinking',
        'Quick estimation',
        'Trial and error',
        'Visual memory',
      ],
      psychCorrect: 0,
      psychExplain: 'Algorithmic thinking ay ang pagsunod sa serye ng mga lohikal na hakbang para marating ang isang eksaktong resulta.',
      q4Prompt: 'Ano ang pinaka-mahalagang detalye sa solusyong ito?',
        q4Options: [
          'Ang paggamit ng 3L bilang panukat sa 5L',
          'Ang pagpunta sa gripo',
          'Ang kulay ng tubig',
          'Ang laki ng lalagyan',
        ],
      q4Correct: 0,
      q4Explain: 'Ang paglilipat ng tubig para mabawasan ang volume ang tanging paraan para makuha ang 4L.',
    ),
_Riddle(
      title: 'Ang Counterfeit na Barya',
      story: 'Mayroong 8 barya. Isa sa mga ito ay peke at mas magaan kaysa sa iba. Gamit ang isang timbangan (balance scale), paano mo mahahanap ang peke sa loob lamang ng dalawang timbang?',
      q1Prompt: 'Ayon sa kwento, ilang barya ang kailangang suriin?',
      q1Options: [
        '8 barya',
        '10 barya',
        '5 barya',
        '12 barya',
      ],
      q1Correct: 0,
      prompt: 'Ano ang unang hakbang sa pagtitimbang?',
      options: [
        'Hatiin ang 8 barya sa tatlo: 3, 3, at 2. Timbangin ang dalawang grupo ng 3',
        'Hatiin ang 8 barya sa dalawa: 4 at 4',
        'Timbangin ang lahat ng barya nang isa-isa',
        'Timbangin ang 3 barya laban sa 5 barya',
      ],
      correctIdx: 0,
      answerExplanation: 'Step 1: Timbangin ang 3 vs 3. Kung pantay, ang peke ay nasa natitirang 2. Kung hindi, ang peke ay nasa mas magaan na grupo ng 3. Step 2: Mula sa grupong may peke (2 o 3), kumuha ng dalawang barya at timbangin. Kung pantay, ang huling isa ang peke. Kung hindi, ang mas magaan ang peke.',
      psychPrompt: 'Anong logic ang ginamit dito?',
      psychOptions: [
        'Recursive partitioning',
        'Linear search',
        'Random sampling',
        'Confirmation bias',
      ],
      psychCorrect: 0,
      psychExplain: 'Recursive partitioning ay ang paghahati ng problema sa mas maliliit na bahagi hanggang makuha ang sagot.',
      q4Prompt: 'Bakit hindi sapat ang paghahati sa 4 at 4?',
        q4Options: [
          'Kailangan ng tatlong grupo para ma-isolate ang peke sa dalawang timbang',
          'Kasi masyadong mabigat ang 4 na barya',
          'Dahil hindi pantay ang timbangan',
          'Dahil mas mabilis ang tatlong grupo',
        ],
      q4Correct: 0,
      q4Explain: 'Sa 4 vs 4, kung hindi pantay, may 4 pang barya. Kailangan ng higit sa dalawang timbang para makuha ang isa sa apat. Sa 3-3-2, laging nakukuha ang peke sa 2 timbang.',
    ),
_Riddle(
      title: 'Ang Lobo, Kambing, at Repolyo',
      story: 'Isang magsasaka ang kailangang itawid ang isang lobo, isang kambing, at isang repolyo sa kabilang panig ng ilog. Ang bangka ay kasya lang ang magsasaka at isang item. Kung iiwan ang lobo at kambing, kakainin ng lobo ang kambing. Kung iiwan ang kambing at repolyo, kakainin ng kambing ang repolyo.',
      q1Prompt: 'Ayon sa kwento, ano ang mga kailangang itawid ng magsasaka?',
      q1Options: [
        'Lobo, kambing, at repolyo',
        'Lobo, aso, at manok',
        'Kambing, baka, at damo',
        'Lobo, usa, at puno',
      ],
      q1Correct: 0,
      prompt: 'Ano ang unang dapat itawid ng magsasaka?',
      options: [
        'Ang kambing — dahil ito ang tanging item na pwedeng iwan kasama ang lobo o repolyo',
        'Ang lobo — para hindi makain ang kambing',
        'Ang repolyo — para hindi makain ng kambing',
        'Wala, dapat maghanap ng mas malaking bangka',
      ],
      correctIdx: 0,
      answerExplanation: 'Dapat munang itawid ang kambing (Lobo + Repolyo = Safe). Pagbalik, itawid ang lobo, pero ibalik ang kambing. Itawid ang repolyo (Lobo + Repolyo = Safe). Pagbalik, itawid ang kambing. Lahat ay nakatawid nang ligtas.',
      psychPrompt: 'Aling cognitive process ang kailangan dito?',
      psychOptions: [
        'Strategic planning with constraints',
        'Trial and error',
        'Immediate gratification',
        'Linear thinking',
      ],
      psychCorrect: 0,
      psychExplain: 'Kailangan ng strategic planning dahil may mga constraints (pagkain sa isa-t isa). Kailangan ng "backtracking" (pagbalik ng kambing) para magtagumpay.',
      q4Prompt: 'Ano ang pinaka-mahalagang hakbang sa solusyong ito?',
        q4Options: [
          'Ang pagbabalik ng kambing sa unang pampang',
          'Ang pag-iwan sa lobo at repolyo',
          'Ang paggamit ng bangka',
          'Ang pagtawid ng repolyo',
        ],
      q4Correct: 0,
      q4Explain: 'Ang pagbabalik ng kambing ang "aha moment" ng puzzle na ito, dahil hindi ito inaasahan ng karamihan.',
    ),
_Riddle(
      title: 'Ang Trak sa Tulay',
      story: 'Isang trak ang sumasailalim sa isang tulay. Ang taas ng trak ay eksaktong 3 metro, ngunit ang taas ng tulay ay 2.9 metro lamang. Gusto ng driver na makatawid ngunit hindi siya kasya.',
      q1Prompt: 'Ayon sa kwento, ano ang taas ng trak at ng tulay?',
      q1Options: [
        'Trak: 3m, Tulay: 2.9m',
        'Trak: 2.9m, Tulay: 3m',
        'Trak: 3.1m, Tulay: 3m',
        'Trak: 2m, Tulay: 1m',
      ],
      q1Correct: 0,
      prompt: 'Paano makakatawid ang trak sa tulay?',
      options: [
        'Bawasan ang hangin sa mga gulong para bumaba ang trak',
        'Putulin ang bubong ng trak',
        'Mag-antay na lumawak ang tulay',
        'Tumingala at magdasal',
      ],
      correctIdx: 0,
      answerExplanation: 'Sa pamamagitan ng pag-deflate ng mga gulong, bababa ang taas ng trak ng ilang sentimetro, sapat para makalusot ito sa 2.9m na tulay.',
      psychPrompt: 'Anong uri ng pag-iisip ang kailangan dito?',
      psychOptions: [
        'Lateral thinking',
        'Mathematical calculation',
        'Physical strength',
        'Luck',
      ],
      psychCorrect: 0,
      psychExplain: 'Lateral thinking ay ang paghahanap ng solusyon sa paraang hindi halata o hindi direct. Sa halip na baguhin ang tulay, binago ang taas ng trak via gulong.',
      q4Prompt: 'Ano ang pinaka-mahalagang detalye sa solusyong ito?',
        q4Options: [
          'Ang hangin sa mga gulong',
          'Ang materyales ng tulay',
          'Ang bilis ng trak',
          'Ang bigat ng kargada',
        ],
      q4Correct: 0,
      q4Explain: 'Ang gulong ang tanging part ng trak na pwedeng baguhin ang taas nang mabilis at madali.',
    ),
_Riddle(
      title: 'Ang 8 Barya at ang Timbangan',
      story: 'Mayroong 8 barya. Isa sa mga ito ay peke at mas mabigat kaysa sa iba. Gamit ang isang timbangan (balance scale), paano mo mahahanap ang peke sa loob lamang ng dalawang timbang?',
      q1Prompt: 'Ayon sa kwento, ano ang katangian ng peke na barya?',
      q1Options: [
        'Mas mabigat kaysa sa iba',
        'Mas magaan kaysa sa iba',
        'May ibang kulay',
        'May ibang sukat',
      ],
      q1Correct: 0,
      prompt: 'Ano ang unang hakbang sa pagtitimbang?',
      options: [
        'Hatiin ang 8 barya sa tatlo: 3, 3, at 2. Timbangin ang dalawang grupo ng 3',
        'Hatiin ang 8 barya sa dalawa: 4 at 4',
        'Timbangin ang lahat ng barya nang isa-isa',
        'Timbangin ang 3 barya laban sa 5 barya',
      ],
      correctIdx: 0,
      answerExplanation: 'Step 1: Timbangin ang 3 vs 3. Kung pantay, ang peke ay nasa natitirang 2. Kung hindi, ang peke ay nasa mas mabigat na grupo ng 3. Step 2: Mula sa grupong may peke (2 o 3), kumuha ng dalawang barya at timbangin. Kung pantay, ang huling isa ang peke. Kung hindi, ang mas mabigat ang peke.',
      psychPrompt: 'Anong logic ang ginamit dito?',
      psychOptions: [
        'Recursive partitioning',
        'Linear search',
        'Random sampling',
        'Confirmation bias',
      ],
      psychCorrect: 0,
      psychExplain: 'Recursive partitioning ay ang paghahati ng problema sa mas maliliit na bahagi hanggang makuha ang sagot.',
      q4Prompt: 'Bakit hindi sapat ang paghahati sa 4 at 4?',
        q4Options: [
          'Kailangan ng tatlong grupo para ma-isolate ang peke sa dalawang timbang',
          'Kasi masyadong mabigat ang 4 na barya',
          'Dahil hindi pantay ang timbangan',
          'Dahil mas mabilis ang tatlong grupo',
        ],
      q4Correct: 0,
      q4Explain: 'Sa 4 vs 4, kung hindi pantay, may 4 pang barya. Kailangan ng higit sa dalawang timbang para makuha ang isa sa apat. Sa 3-3-2, laging nakukuha ang peke sa 2 timbang.',
    )
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
      'Nag-claim siyang nag-live stream siya ng laro buong gabi, pero napatunayang na-record ang video ilang araw bago ang krimen.',
      'Sabi niyang nakita niyang agad-agad ang katawan nang pumasok siya at tumawag ng pulis, pero eksaktong 3 minuto lang ang pagitan ng pagpasok niya at pagtawag — kulang para sa isang taong hindi alam kung ano ang nangyari.',
      'Sabi niyang natutulog siya nang mangyari ang krimen, pero ang fitness tracker niya ay nagtala ng daan-daang hakbang nang mga oras na iyon.',
      'Sabi niyang nasa bahay siya buong gabi, pero ang CCTV ng bus ay nakuhang sumakay siya papunta at pabalik sa lugar ng krimen.',
      'Sabi niyang kinausap pa niya ang biktima sa telepono alas-nuebe, pero ang forensic time of death ay alas-otso pababa — wala nang buhay sa pagsagot ang biktima.',
      'Apat na taga-kinumpirma ang nagkwento ng kanyang alibi na magkapareho ng SALITA-SALITA — parang inensayo ang isang kwento. Ayon sa pag-aaral, mas magkaka-iba ang totoong alaala.',
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
      'May resibo ng gasolina sa gasolinahan na may timestamp na eksaktong oras ng krimen',
      'May screenshot ng group chat na pinost niya ang hapunan nang oras ng krimen',
      'May boarding pass at hotel booking na nagpapatunay sa kanyang paglalakbay',
      'Naka-video call siya sa kanyang ina na patuloy sa mahigit isang oras nang oras ng krimen',
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
      '"Hindi ko alam kung bakit siya namatay. Gusto ko lang sana siyang kausapin tungkol sa perang inutang niya sa akin noong nakaraang taon," sabi niya — pero hindi niya naalala ang pangalan ng biktima nang tanungin.',
      '"Mahal ko siya eh. Kaya kong gawin lahat para sa kanya," sabi niya — at nang tanungin kung anong bulaklak ang hinahawakan ng biktima sa hardin, agad niyang sinagot nang may sobrang detalye sa kulay at amoy kahit na nauna na siyang magsabing "hindi ko siya masyadong kilala."',
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
      '"Alam kong sira ang alitan namin ni $victim, pero hindi ko gagawin ito kahit kanino," aniya na may malamig na kamay at mahinang boses.',
      '"Nakikita ko siya araw-araw sa simbahan. Sigurado akong may mga taong may galit sa kanya, pero hindi ako," sabi niya at umiyak.',
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