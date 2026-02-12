import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/answer.dart';

class AnswersService {
  List<Answer> _answers = [];
  bool _isLoaded = false;

  List<Answer> get answers => _answers;
  bool get isLoaded => _isLoaded;

  Future<void> loadAnswers() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/answers.json');
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      _answers = (jsonData['answers'] as List)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList();
      _isLoaded = true;
    } catch (e) {
      _answers = _getFallbackAnswers();
      _isLoaded = true;
    }
  }

  Answer getRandomAnswer() {
    if (_answers.isEmpty) {
      _answers = _getFallbackAnswers();
    }
    final random = Random();
    return _answers[random.nextInt(_answers.length)];
  }

  List<Answer> _getFallbackAnswers() {
    return [
      Answer(
        id: 'F01',
        tags: ['go'],
        text: {
          'ko': '지금이 기회야. 잡아.',
          'en': "Now's your chance—take it.",
          'ja': '今がチャンス。掴んで。',
          'zh': '现在是机会。抓住它。'
        },
        subtext: {
          'ko': '딱 한 번만 더 용기.',
          'en': 'One more ounce of courage.',
          'ja': 'もう少しだけ勇気を。',
          'zh': '再多一点勇气。'
        },
      ),
      Answer(
        id: 'F02',
        tags: ['wait'],
        text: {
          'ko': '오늘은 잠깐 멈춤.',
          'en': 'Pause for today.',
          'ja': '今日はちょっと休憩。',
          'zh': '今天暂停一下。'
        },
        subtext: {
          'ko': '멈추면 오히려 빨라져.',
          'en': 'Pausing can speed you up.',
          'ja': '止まれば逆に速くなる。',
          'zh': '停下来反而更快。'
        },
      ),
      Answer(
        id: 'F03',
        tags: ['no'],
        text: {
          'ko': '그건 네 선을 넘었어.',
          'en': 'That crossed your boundary.',
          'ja': 'それは一線を越えている。',
          'zh': '那已经越界了。'
        },
        subtext: {
          'ko': '거리 두는 게 정답.',
          'en': 'Distance is the answer.',
          'ja': '距離を置くのが正解。',
          'zh': '保持距离是正解。'
        },
      ),
      Answer(
        id: 'F04',
        tags: ['selfcare'],
        text: {
          'ko': '물 한 잔이면 반은 해결.',
          'en': 'A glass of water solves half.',
          'ja': '水一杯で半分解決。',
          'zh': '一杯水能解决一半。'
        },
        subtext: {
          'ko': '뇌부터 깨우자.',
          'en': 'Wake your brain first.',
          'ja': 'まず脳を目覚めさせよう。',
          'zh': '先唤醒大脑吧。'
        },
      ),
      Answer(
        id: 'F05',
        tags: ['decision'],
        text: {
          'ko': '편해지는 쪽이 맞아.',
          'en': 'Choose what brings peace.',
          'ja': '楽になる方が正解。',
          'zh': '让自己舒服的选择是对的。'
        },
        subtext: {
          'ko': '몸이 먼저 안다.',
          'en': 'Your body knows first.',
          'ja': '体が先に知っている。',
          'zh': '身体最先知道。'
        },
      ),
      Answer(
        id: 'F06',
        tags: ['go'],
        text: {
          'ko': '작게 시작해도 돼.',
          'en': 'Start small. It counts.',
          'ja': '小さく始めてもいい。',
          'zh': '从小事做起。'
        },
        subtext: {
          'ko': '0→1이 전부야.',
          'en': '0→1 is everything.',
          'ja': '0→1が全てだ。',
          'zh': '0→1 就是一切。'
        },
      ),
      Answer(
        id: 'F07',
        tags: ['wait'],
        text: {
          'ko': '지금은 정리 타임.',
          'en': "It's a cleanup moment.",
          'ja': '今は整理の時間。',
          'zh': '现在是整理时间。'
        },
        subtext: {
          'ko': '정리하면 길이 보여.',
          'en': 'Clarity reveals the path.',
          'ja': '整理すれば道が見える。',
          'zh': '整理好了路就出现了。'
        },
      ),
      Answer(
        id: 'F08',
        tags: ['relationship'],
        text: {
          'ko': '한 톤만 더 부드럽게.',
          'en': 'Just one tone softer.',
          'ja': 'もうワントーン優しく。',
          'zh': '语气再柔和一点。'
        },
        subtext: {
          'ko': '진심은 톤에 실려.',
          'en': 'Tone carries intent.',
          'ja': '本心はトーンに乗る。',
          'zh': '真心藏在语气里。'
        },
      ),
      Answer(
        id: 'F09',
        tags: ['decision'],
        text: {
          'ko': '둘 다 끌리면 보류.',
          'en': 'If both pull you, pause.',
          'ja': '両方惹かれるなら保留。',
          'zh': '如果两个都想要，先保留。'
        },
        subtext: {
          'ko': '급할수록 천천히.',
          'en': "Slower when it's urgent.",
          'ja': '急ぐほどゆっくり。',
          'zh': '越急越要慢。'
        },
      ),
      Answer(
        id: 'F10',
        tags: ['no'],
        text: {
          'ko': '그건 에너지 낭비.',
          'en': "That's an energy leak.",
          'ja': 'それはエネルギーの無駄。',
          'zh': '那是浪费精力。'
        },
        subtext: {
          'ko': '아껴 써, 너를.',
          'en': 'Save it—for you.',
          'ja': '自分を大切にして。',
          'zh': '爱惜你自己。'
        },
      ),
      Answer(
        id: 'F11',
        tags: ['selfcare'],
        text: {
          'ko': '잠이 답일 때가 있어.',
          'en': 'Sometimes sleep is the answer.',
          'ja': '睡眠が答えの時もある。',
          'zh': '有时候睡觉就是答案。'
        },
        subtext: {
          'ko': '피곤하면 판단이 흐려져.',
          'en': 'Fatigue blurs judgment.',
          'ja': '疲れると判断が鈍る。',
          'zh': '疲劳会模糊判断。'
        },
      ),
      Answer(
        id: 'F12',
        tags: ['go'],
        text: {
          'ko': '오늘 10분이면 승리.',
          'en': 'Ten minutes today is a win.',
          'ja': '今日10分やれば勝ち。',
          'zh': '今天做10分钟就是胜利。'
        },
        subtext: {
          'ko': '작은 성취가 흐름.',
          'en': 'Small wins build flow.',
          'ja': '小さな達成が流れを作る。',
          'zh': '小成就是顺流。'
        },
      ),
      Answer(
        id: 'F13',
        tags: ['go'],
        text: {
          'ko': '완벽 말고 완료.',
          'en': 'Done beats perfect.',
          'ja': '完璧より完了。',
          'zh': '完成比完美更重要。'
        },
        subtext: {
          'ko': '완료가 다음을 연다.',
          'en': 'Completion opens the next.',
          'ja': '完了が次を開く。',
          'zh': '完成开启下一步。'
        },
      ),
      Answer(
        id: 'F14',
        tags: ['wait'],
        text: {
          'ko': '내일의 네가 더 똑똑해.',
          'en': 'Tomorrow-you is wiser.',
          'ja': '明日の自分の方が賢い。',
          'zh': '明天的你更聪明。'
        },
        subtext: {
          'ko': '하룻밤만 더.',
          'en': 'One more night.',
          'ja': 'もう一晩だけ。',
          'zh': '再过一晚。'
        },
      ),
      Answer(
        id: 'F15',
        tags: ['no'],
        text: {
          'ko': '정중하게, 단호하게.',
          'en': 'Polite, but firm.',
          'ja': '丁寧に、でも断固として。',
          'zh': '礼貌但坚定。'
        },
        subtext: {
          'ko': '부드러운 거절이 최고.',
          'en': 'Soft refusal, strong boundary.',
          'ja': '柔らかい拒絶が最強。',
          'zh': '温和的拒绝最好。'
        },
      ),
      Answer(
        id: 'F16',
        tags: ['go'],
        text: {
          'ko': '불안해도 해볼 만해.',
          'en': 'Worth trying, even anxious.',
          'ja': '不安でもやる価値あり。',
          'zh': '即使不安也值得一试。'
        },
        subtext: {
          'ko': '불안=성장 신호.',
          'en': 'Anxiety can mean growth.',
          'ja': '不安は成長のサイン。',
          'zh': '不安=成长信号。'
        },
      ),
      Answer(
        id: 'F17',
        tags: ['selfcare'],
        text: {
          'ko': '밥 먹고 다시 생각.',
          'en': 'Eat first, rethink later.',
          'ja': 'ご飯を食べてから考え直そう。',
          'zh': '吃完饭再想。'
        },
        subtext: {
          'ko': '저혈당은 적이다.',
          'en': 'Low energy is the enemy.',
          'ja': '低血糖は敵だ。',
          'zh': '低血糖是敌人。'
        },
      ),
      Answer(
        id: 'F18',
        tags: ['decision'],
        text: {
          'ko': '가장 단순한 답이 정답.',
          'en': 'The simplest answer is it.',
          'ja': '一番シンプルな答えが正解。',
          'zh': '最简单的答案就是正解。'
        },
        subtext: {
          'ko': '복잡하면 한 번 줄여.',
          'en': "If it's complex, simplify once.",
          'ja': '複雑なら一度削ぎ落とそう。',
          'zh': '复杂的话就简化一次。'
        },
      ),
      Answer(
        id: 'F19',
        tags: ['relationship'],
        text: {
          'ko': '칭찬 한 번이 흐름을 바꿔.',
          'en': 'One compliment shifts the flow.',
          'ja': '一つの褒め言葉が流れを変える。',
          'zh': '一句赞美能改变流向。'
        },
        subtext: {
          'ko': '먼저 따뜻하게 시작해.',
          'en': 'Start warm.',
          'ja': 'まずは温かく始めよう。',
          'zh': '先从温暖开始。'
        },
      ),
      Answer(
        id: 'F20',
        tags: ['decision'],
        text: {
          'ko': '답은 밖이 아니라 안에.',
          'en': 'The answer is inside.',
          'ja': '答えは外ではなく中にある。',
          'zh': '答案不在外面，在里面。'
        },
        subtext: {
          'ko': '너의 기준으로.',
          'en': 'By your standard.',
          'ja': '君の基準で。',
          'zh': '以你的标准。'
        },
      ),
    ];
  }
}
