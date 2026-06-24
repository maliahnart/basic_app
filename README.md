┌──────────────────────────────────────────────────────────────┐
│ UI LAYER │
│ HomeScreen | RecordScreen | PlaybackScreen | BottomSheet │SpashScreen
└──────────────────────────────────────────────────────────────┘
↕ (ref.watch / ref.read)
┌──────────────────────────────────────────────────────────────┐
│ PROVIDER LAYER │
│ sttProvider │ ttsProvider │ historyProvider │
│ (StateNotifier) │ (StateNotifier) │ (StateNotifier) │
└──────────────────────────────────────────────────────────────┘
↕ ↕
┌───────────────────────┐ ┌────────────────────────────────────┐
│ HARDWARE PLUGINS│ │ DATA LAYER (Hive) │
│ SpeechToText | TTS       │ 	  │ Box('history') │
└───────────────────────┘ └────────────────────────────────────┘

### Các Luồng Xử Lý Chính:
1. **Luồng 1 (Speech to Text):** Kích hoạt Microphone qua `permission_handler` -> Gọi dịch vụ `speech_to_text` -> Truyền stream text realtime lên UI qua `sttProvider` -> Khi bấm dừng, tự động lưu vào Hive Cache nếu text hợp lệ.
2. **Luồng 2 (Text to Speech):** Nhận văn bản đầu vào kèm cấu hình nâng cao (Tốc độ, Cao độ, Âm lượng) -> Điều khiển `flutter_tts` phát âm thanh. Hỗ trợ cơ chế Re-trigger để cập nhật thông số nóng realtime qua sự kiện `onChangeEnd`.
3. **Luồng 3 (Quản lý dữ liệu Hive):** Giới hạn cứng **tối đa 5 bản ghi gần nhất** tại tầng Provider để tối ưu hóa bộ nhớ RAM và ROM. Bản ghi mới nhất luôn được đảo ngược đưa lên đầu danh sách (`index 0`).


## Cấu Trúc Thư Mục Dự Án (Folder Structure)

-lib gồm models, providers,routes, ui, utils
Model chứa hive model để lưu dữ liệu
providers cung cấp logic và state cho các màn hình tương ứng
routes cấu hình đường dẫn các màn và shellroutes nhúng bottom trong các màn hình
ui là các màn hình cơ bản cần thiết cho dự án
utils là cấu hình chung appStyle và appColors cho dự án


Yêu Cầu Cấu Hình Hệ Thống (Native Configurations)
Để ứng dụng tương tác được với phần cứng thiết bị thật mà không gây crash, bắt buộc phải khai báo các quyền sau:
 Android (android/app/src/main/AndroidManifest.xml)
Phải thêm các uses-permission như record_audio và internet cộng thêm các thẻ queries intent
 iOS (ios/Runner/Info.plist)
Phải thêm các key để yêu cầu quyền truy cập
## Hướng Dẫn Cài Đặt & Khởi Chạy (Getting Started)
1.	Clone dự án và cài đặt dependencies:
git clone git@github.com:maliahnart/basic_app.git
checkout sang nhánh tts
flutter pub get
2.	Sinh mã nguồn tự động cho Hive Model:
flutter pub run build_runner build --delete-conflicting-outputs
3.	Chạy ứng dụng trong môi trường Development:
flutter run 
trong thư mục gốc của dự án
4.	Build file APK:Bash
flutter build apk --split-per-abi
flutter build apk –release
Đường dẫn file đầu ra: build/app/outputs/flutter-apk/app-release.apk

