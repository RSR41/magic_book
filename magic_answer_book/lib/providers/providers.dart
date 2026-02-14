import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/answers_service.dart';
import '../services/storage_service.dart';
import '../services/ads_service.dart';
import '../services/iap_service.dart';
import '../models/answer.dart';
import '../models/saved_answer.dart';
import '../services/sound_service.dart';

// ─── Service Providers ───
final answersServiceProvider = Provider<AnswersService>((ref) {
  return AnswersService();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final adsServiceProvider = Provider<AdsService>((ref) {
  final adsService = AdsService();
  ref.onDispose(adsService.dispose);
  return adsService;
});

final iapServiceProvider = Provider<IapService>((ref) {
  final service = IapService();
  ref.onDispose(service.dispose);
  return service;
});

final soundServiceProvider = Provider<SoundService>((ref) {
  final service = SoundService();
  // Initialize with current setting
  final enabled = ref.read(storageServiceProvider).sound;
  service.setSoundEnabled(enabled);

  // Listen for changes
  ref.listen(soundEnabledProvider, (_, next) {
    service.setSoundEnabled(next);
  });

  ref.onDispose(service.dispose);
  return service;
});

// ─── Settings Providers ───
final vibrationProvider = StateProvider<bool>((ref) {
  return ref.read(storageServiceProvider).vibration;
});

final shakeEnabledProvider = StateProvider<bool>((ref) {
  return ref.read(storageServiceProvider).shake;
});

final soundEnabledProvider = StateProvider<bool>((ref) {
  return ref.read(storageServiceProvider).sound;
});

final languageProvider = StateProvider<String>((ref) {
  return ref.read(storageServiceProvider).language;
});

final isAdFreeProvider = StateProvider<bool>((ref) {
  return ref.read(storageServiceProvider).isAdFree;
});

final hasSeenIntroProvider = StateProvider<bool>((ref) {
  return ref.read(storageServiceProvider).hasSeenIntro;
});

// ─── Answer State ───
final currentQuestionProvider = StateProvider<String>((ref) => '');

final currentAnswerProvider = StateProvider<Answer?>((ref) => null);

final tryAgainCountProvider = StateProvider<int>((ref) => 0);

// ─── Saved Answers ───
final savedAnswersProvider =
    StateNotifierProvider<SavedAnswersNotifier, List<SavedAnswer>>((ref) {
  return SavedAnswersNotifier(ref.read(storageServiceProvider));
});

class SavedAnswersNotifier extends StateNotifier<List<SavedAnswer>> {
  final StorageService _storageService;

  SavedAnswersNotifier(this._storageService)
      : super(_storageService.getSavedAnswers());

  void refresh() {
    state = _storageService.getSavedAnswers();
  }

  Future<bool> saveAnswer(Answer answer, String question) async {
    final result = await _storageService.saveAnswer(answer, question);
    if (result) {
      state = _storageService.getSavedAnswers();
    }
    return result;
  }

  Future<void> deleteAnswer(String answerId) async {
    await _storageService.deleteSavedAnswer(answerId);
    state = _storageService.getSavedAnswers();
  }

  Future<void> deleteAll() async {
    await _storageService.deleteAllSavedAnswers();
    state = [];
  }
}

// ─── Navigation ───
final currentTabProvider = StateProvider<int>((ref) => 0);
