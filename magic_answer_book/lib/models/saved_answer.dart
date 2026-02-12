class SavedAnswer {
  final String answerId;
  final String question;
  final Map<String, String> text;
  final Map<String, String> subtext;
  final DateTime savedAt;

  SavedAnswer({
    required this.answerId,
    required this.question,
    required this.text,
    required this.subtext,
    required this.savedAt,
  });

  factory SavedAnswer.fromMap(Map<dynamic, dynamic> map) {
    return SavedAnswer(
      answerId: map['answerId'] as String? ?? '',
      question: map['question'] as String? ?? '',
      text: Map<String, String>.from(map['text'] as Map? ?? {}),
      subtext: Map<String, String>.from(map['subtext'] as Map? ?? {}),
      savedAt: map['savedAt'] is DateTime
          ? map['savedAt'] as DateTime
          : DateTime.tryParse(map['savedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answerId': answerId,
      'question': question,
      'text': text,
      'subtext': subtext,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  String getLocalizedText(String locale) {
    return text[locale] ?? text['ko'] ?? text['en'] ?? '';
  }

  String getLocalizedSubtext(String locale) {
    return subtext[locale] ?? subtext['ko'] ?? subtext['en'] ?? '';
  }
}
