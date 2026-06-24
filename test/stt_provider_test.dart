import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:demo_app/providers/stt_provider.dart';
import 'package:demo_app/utils/constants.dart';

class FakeSpeechToText extends Fake implements SpeechToText {
  bool isAvailable = true;
  bool listening = false;
  void Function(SpeechRecognitionError)? onErrorCallback;
  void Function(String)? onStatusCallback;
  void Function(SpeechRecognitionResult)? onResultCallback;

  @override
  Future<bool> initialize({
    void Function(SpeechRecognitionError)? onError,
    void Function(String)? onStatus,
    dynamic debugLogging,
    dynamic options,
    dynamic finalTimeout,
  }) async {
    onErrorCallback = onError;
    onStatusCallback = onStatus;
    return isAvailable;
  }

  @override
  Future<List<LocaleName>> locales() async {
    return [
      LocaleName('vi_VN', 'Tiếng Việt'),
      LocaleName('en_US', 'Tiếng Anh'),
    ];
  }

  @override
  bool get isListening => listening;

  @override
  Future<void> listen({
    void Function(SpeechRecognitionResult)? onResult,
    String? localeId,
    dynamic listenOptions,
    dynamic partialResults,
    dynamic onDevice,
    dynamic listenMode,
    dynamic sampleRate,
    dynamic cancelOnError,
    dynamic listenFor,
    dynamic pauseFor,
    void Function(double)? onSoundLevelChange,
  }) async {
    listening = true;
    onResultCallback = onResult;
    if (onStatusCallback != null) {
      onStatusCallback!('listening');
    }
  }

  @override
  Future<void> stop() async {
    listening = false;
    if (onStatusCallback != null) {
      onStatusCallback!('notListening');
    }
  }

  // Helper method for testing results
  void triggerResult(String words) {
    if (onResultCallback != null) {
      onResultCallback!(SpeechRecognitionResult.fromJson({
        'alternates': [
          {
            'recognizedWords': words,
            'recognizedPhrases': null,
            'confidence': 1.0
          }
        ],
        'resultType': 1
      }));
    }
  }

  // Helper method for testing errors
  void triggerError(String errorMsg) {
    if (onErrorCallback != null) {
      onErrorCallback!(SpeechRecognitionError(errorMsg, false));
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SttNotifier Tests', () {
    late FakeSpeechToText fakeSpeechToText;
    late SttNotifier sttNotifier;

    setUp(() {
      fakeSpeechToText = FakeSpeechToText();
      sttNotifier = SttNotifier(speechToText: fakeSpeechToText);

      // Mock permission_handler channel calls robustly
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter.baseflow.com/permissions/methods'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'requestPermissions') {
            final List<dynamic> requestedPermissions = methodCall.arguments;
            final Map<int, int> response = {};
            for (var p in requestedPermissions) {
              response[p as int] = 1; // 1 represents PermissionStatus.granted
            }
            return response;
          }
          if (methodCall.method == 'checkPermissionStatus') {
            final int permission = methodCall.arguments as int;
            return 1; // granted
          }
          return null;
        },
      );
    });

    test('Trạng thái khởi tạo mặc định là chính xác', () {
      expect(sttNotifier.state.isListening, false);
      expect(sttNotifier.state.currentText, '');
      expect(sttNotifier.state.errorMessage, '');
      expect(sttNotifier.state.currentLanguage.localeId, 'vi_VN');
    });

    test('Thay đổi ngôn ngữ hoạt động chính xác', () {
      const newLang = AppLanguage(name: 'Tiếng Anh', localeId: 'en_US', flag: '🇺🇸');
      sttNotifier.setLanguage(newLang);
      expect(sttNotifier.state.currentLanguage.localeId, 'en_US');
    });

    test('Dọn dẹp văn bản hoạt động chính xác', () {
      sttNotifier.state = sttNotifier.state.copyWith(currentText: 'Một số văn bản');
      sttNotifier.clearText();
      expect(sttNotifier.state.currentText, '');
    });

    test('Bật ghi âm thành công và cập nhật trạng thái', () async {
      final result = await sttNotifier.toggleRecording();
      
      expect(result, true);
      expect(sttNotifier.state.isListening, true);
      expect(sttNotifier.state.errorMessage, '');
      expect(sttNotifier.state.currentText, '');
    });

    test('Ghi nhận kết quả giọng nói thành văn bản chính xác', () async {
      await sttNotifier.toggleRecording();
      
      // Giả lập nhận diện được giọng nói
      fakeSpeechToText.triggerResult('hello world');
      
      expect(sttNotifier.state.currentText, 'hello world');
    });

    test('Dịch các mã lỗi kỹ thuật STT sang tiếng Việt thân thiện', () async {
      await sttNotifier.toggleRecording();
      
      // Giả lập lỗi network
      fakeSpeechToText.triggerError('error_network');
      
      expect(sttNotifier.state.isListening, false);
      expect(
        sttNotifier.state.errorMessage, 
        'Lỗi kết nối hoặc hết thời gian chờ từ máy chủ. Vui lòng nói liên tục hoặc kiểm tra mạng.'
      );
    });
  });
}
