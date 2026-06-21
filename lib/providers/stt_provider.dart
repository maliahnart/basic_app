import 'package:flutter_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttState {
  final bool isListening;
  final String currentText;
  final String errorMessage;

  SttState({
    this.isListening = false,
    this.currentText = '',
    this.errorMessage = '',
  });
  SttState copyWith({
    bool? isListening,
    String? currentText,
    String? errorMessage,
  }) {
    return SttState(
      isListening: isListening ?? this.isListening,
      currentText: currentText ?? this.currentText,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SttNotifier extends StateNotifier<SttState> {
  final SpeechToText _speechToText = SpeechToText();
  SttNotifier() : super(SttState());
  Future<bool> toggleRecording() async {
    if (state.isListening) {
      await stopListening();
      return false;
    }
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      state = state.copyWith(
        errorMessage: 'Quyền truy cập Microphone bị từ chối!',
      );
      return false;
    }
    bool available = await _speechToText.initialize(
      onError: (val) => state = state.copyWith(
        isListening: false,
        errorMessage: val.errorMsg,
      ),
      onStatus: (val) {
        if (val == 'done' || val == 'notListening') {
          state = state.copyWith(isListening: false);
        }
      },
    );
    if (available) {
      state = state.copyWith(
        isListening: true,
        errorMessage: '',
        currentText: '',
      );

      _speechToText.listen(
        onResult: (val) {
          state = state.copyWith(currentText: val.recognizedWords);
        },
        localeId: 'vi_VN',
      );
    }
    return true;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    state = state.copyWith(isListening: false);
  }

  void clearText() {
    state = state.copyWith(currentText: '');
  }
}

final sttProvider = StateNotifierProvider<SttNotifier, SttState>(
  (ref) => SttNotifier(),
);
