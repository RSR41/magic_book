import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isSoundEnabled = true;

  SoundService() {
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
    if (!enabled) {
      _bgmPlayer.stop();
      _sfxPlayer.stop();
    } else {
      // Resume BGM if needed?
      // For now, we rely on screens to request BGM playback
    }
  }

  Future<void> playBgm(String fileName) async {
    if (!_isSoundEnabled) return;
    if (_bgmPlayer.state == PlayerState.playing) return;

    try {
      await _bgmPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint('Error playing BGM: $e');
    }
  }

  Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping BGM: $e');
    }
  }

  Future<void> playSfx(String fileName) async {
    if (!_isSoundEnabled) return;

    try {
      // For overlapping SFX, we might need multiple players or AudioCache (deprecated in v6)
      // v6 creates new player for simple one-shots easily or we can reuse
      // We'll use a new player for SFX to allow overlaps or just reuse _sfxPlayer if overlap not needed
      // To allow overlap:
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/$fileName'),
          mode: PlayerMode.lowLatency);
      player.onPlayerComplete.listen((event) {
        player.dispose();
      });
    } catch (e) {
      debugPrint('Error playing SFX: $e');
    }
  }

  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
