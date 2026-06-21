import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsState {
  final bool isPlaying;
  final double speedRate;
  final double pitch;
  final double volume;
  final String currentLanguage;
  TtsState({
    this.isPlaying = false,
    this.speedRate = 1.0,
    this.pitch = 1.0,
    this.volume = 1.0,
    this.currentLanguage = 'vi-VN',
  });
  TtsState copyWith({
    bool? isPlaying,
    double? speedRate,
    double? pitch,
    double? volume,
    String? currentLanguage,
  }) {
    return TtsState(
      isPlaying: isPlaying ?? this.isPlaying,
      speedRate: speedRate ?? this.speedRate,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
      currentLanguage: currentLanguage ?? this.currentLanguage,
    );
  }
}

class TtsNotifier extends StateNotifier<TtsState> {
  final FlutterTts _flutterTts = FlutterTts();
  TtsNotifier() : super(TtsState()) {
    _initTts();
  }

  void _initTts() {
    _flutterTts.setStartHandler(() => state = state.copyWith(isPlaying: true));
    _flutterTts.setCompletionHandler(
      () => state = state.copyWith(isPlaying: false),
    );
    _flutterTts.setErrorHandler(
      (msg) => state = state.copyWith(isPlaying: false),
    );
  }

  void setSpeed(double rate) {
    state = state.copyWith(speedRate: rate);
  }

  void setPitch(double pitchVal) {
    state = state.copyWith(pitch: pitchVal);
  }

  void setLanguage(String langCode) {
    state = state.copyWith(currentLanguage: langCode);
  }

  void setVolume(double vol) {
    state = state.copyWith(volume: vol);
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    await _flutterTts.setLanguage(state.currentLanguage);
    await _flutterTts.setSpeechRate(state.speedRate);
    await _flutterTts.setPitch(state.pitch);
    await _flutterTts.setVolume(state.volume);

    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    state = state.copyWith(isPlaying: false);
  }
}

final ttsProvider = StateNotifierProvider<TtsNotifier, TtsState>(
  (ref) => TtsNotifier(),
);
