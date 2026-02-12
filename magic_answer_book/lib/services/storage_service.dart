import 'package:hive_flutter/hive_flutter.dart';
import '../models/answer.dart';
import '../models/saved_answer.dart';

class StorageService {
  static const String settingsBoxName = 'settingsBox';
  static const String metaBoxName = 'metaBox';
  static const String savedBoxName = 'savedBox';

  late Box _settingsBox;
  late Box _metaBox;
  late Box _savedBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox(settingsBoxName);
    _metaBox = await Hive.openBox(metaBoxName);
    _savedBox = await Hive.openBox(savedBoxName);

    // First launch date
    if (_metaBox.get('firstLaunchDate') == null) {
      _metaBox.put('firstLaunchDate', DateTime.now().toIso8601String());
    }
  }

  // ─── Settings ───
  bool get vibration =>
      _settingsBox.get('vibration', defaultValue: true) as bool;
  set vibration(bool value) => _settingsBox.put('vibration', value);

  bool get shake => _settingsBox.get('shake', defaultValue: true) as bool;
  set shake(bool value) => _settingsBox.put('shake', value);

  bool get sound => _settingsBox.get('sound', defaultValue: true) as bool;
  set sound(bool value) => _settingsBox.put('sound', value);

  String get language =>
      _settingsBox.get('language', defaultValue: 'ko') as String;
  set language(String value) => _settingsBox.put('language', value);

  bool get isAdFree =>
      _settingsBox.get('isAdFree', defaultValue: false) as bool;
  set isAdFree(bool value) => _settingsBox.put('isAdFree', value);

  bool get hasSeenIntro =>
      _settingsBox.get('hasSeenIntro', defaultValue: false) as bool;
  set hasSeenIntro(bool value) => _settingsBox.put('hasSeenIntro', value);

  // ─── Meta ───
  int get totalAnswersCount =>
      _metaBox.get('totalAnswersCount', defaultValue: 0) as int;
  set totalAnswersCount(int value) => _metaBox.put('totalAnswersCount', value);

  int get adInterstitialCount =>
      _metaBox.get('adInterstitialCount', defaultValue: 0) as int;
  set adInterstitialCount(int value) =>
      _metaBox.put('adInterstitialCount', value);

  String? get lastAdShownAt => _metaBox.get('lastAdShownAt') as String?;
  set lastAdShownAt(String? value) => _metaBox.put('lastAdShownAt', value);

  // ─── Saved Answers (FIFO, max 50) ───
  Future<bool> saveAnswer(Answer answer, String question) async {
    try {
      final keys = _savedBox.keys.toList();

      // Check for duplicate (update if same answerId)
      String? existingKey;
      for (final key in keys) {
        final item = _savedBox.get(key) as Map?;
        if (item != null && item['answerId'] == answer.id) {
          existingKey = key as String;
          break;
        }
      }

      if (existingKey != null) {
        await _savedBox.delete(existingKey);
      } else if (keys.length >= 50) {
        // FIFO: delete oldest
        final sortedKeys = List<dynamic>.from(keys);
        sortedKeys.sort((a, b) {
          final aMap = _savedBox.get(a) as Map?;
          final bMap = _savedBox.get(b) as Map?;
          final aTime = aMap?['savedAt']?.toString() ?? '';
          final bTime = bMap?['savedAt']?.toString() ?? '';
          return aTime.compareTo(bTime);
        });
        await _savedBox.delete(sortedKeys.first);
      }

      final key = 'saved_${DateTime.now().millisecondsSinceEpoch}';
      await _savedBox.put(key, {
        'answerId': answer.id,
        'question': question,
        'text': Map<String, String>.from(answer.text),
        'subtext': Map<String, String>.from(answer.subtext),
        'savedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  List<SavedAnswer> getSavedAnswers() {
    final items = <SavedAnswer>[];
    for (final key in _savedBox.keys) {
      final map = _savedBox.get(key);
      if (map != null && map is Map) {
        items.add(SavedAnswer.fromMap(map));
      }
    }
    // Sort by savedAt descending (newest first)
    items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return items;
  }

  Future<void> deleteSavedAnswer(String answerId) async {
    final keys = _savedBox.keys.toList();
    for (final key in keys) {
      final item = _savedBox.get(key) as Map?;
      if (item != null && item['answerId'] == answerId) {
        await _savedBox.delete(key);
        break;
      }
    }
  }

  Future<void> deleteAllSavedAnswers() async {
    await _savedBox.clear();
  }
}
