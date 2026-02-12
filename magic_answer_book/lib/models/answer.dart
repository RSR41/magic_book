class Answer {
  final String id;
  final List<String> tags;
  final Map<String, String> text;
  final Map<String, String> subtext;

  Answer({
    required this.id,
    required this.tags,
    required this.text,
    required this.subtext,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as String,
      tags: List<String>.from(json['tags'] as List),
      text: Map<String, String>.from(json['text'] as Map),
      subtext: Map<String, String>.from(json['subtext'] as Map),
    );
  }

  String getLocalizedText(String locale) {
    return text[locale] ?? text['ko'] ?? text['en'] ?? '';
  }

  String getLocalizedSubtext(String locale) {
    return subtext[locale] ?? subtext['ko'] ?? subtext['en'] ?? '';
  }
}
