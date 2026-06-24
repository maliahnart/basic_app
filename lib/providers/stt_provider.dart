import 'package:demo_app/utils/constants.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttState {
  final bool isListening;
  final String currentText;
  final String errorMessage;
  final AppLanguage currentLanguage;

  SttState({
    this.isListening = false,
    this.currentText = '',
    this.errorMessage = '',
    this.currentLanguage = const AppLanguage(
      name: 'Tiếng Việt',
      localeId: 'vi_VN',
      flag: '🇻🇳',
    ),
  });
  SttState copyWith({
    bool? isListening,
    String? currentText,
    String? errorMessage,
    AppLanguage? currentLanguage,
  }) {
    return SttState(
      isListening: isListening ?? this.isListening,
      currentText: currentText ?? this.currentText,
      errorMessage: errorMessage ?? this.errorMessage,
      currentLanguage: currentLanguage ?? this.currentLanguage,
    );
  }
}

class SttNotifier extends StateNotifier<SttState> {
  final SpeechToText _speechToText;
  SttNotifier({SpeechToText? speechToText})
    : _speechToText = speechToText ?? SpeechToText(),
      super(SttState());
  void setLanguage(AppLanguage lang) {
    if (state.isListening) return;
    state = state.copyWith(currentLanguage: lang, currentText: '');
  }

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
      onError: (val) {
        String friendlyMessage = val.errorMsg;
        if (val.errorMsg == 'error_network') {
          friendlyMessage =
              'Lỗi kết nối hoặc hết thời gian chờ từ máy chủ. Vui lòng nói liên tục hoặc kiểm tra mạng.';
        } else if (val.errorMsg == 'error_speech_timeout') {
          friendlyMessage =
              'Không nhận diện được giọng nói (hết thời gian chờ).';
        } else if (val.errorMsg == 'error_no_match') {
          friendlyMessage =
              'Không nhận diện được từ ngữ phù hợp. Vui lòng nói rõ hơn.';
        } else if (val.errorMsg == 'error_permission') {
          friendlyMessage =
              'Không có quyền truy cập microphone hoặc nhận diện giọng nói.';
        } else if (val.errorMsg == 'error_busy') {
          friendlyMessage =
              'Bộ nhận diện giọng nói đang bận, vui lòng thử lại sau vài giây.';
        }
        state = state.copyWith(
          isListening: false,
          errorMessage: friendlyMessage,
        );
      },
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
        listenOptions: SpeechListenOptions(
          localeId: state.currentLanguage.localeId,
        ),
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
