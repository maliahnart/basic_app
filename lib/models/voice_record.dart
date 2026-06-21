import 'package:hive/hive.dart';
part 'voice_record.g.dart';
@HiveType(typeId: 0)
class VoiceRecord extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final DateTime createAt;

  @HiveField(2)
  final bool isStt;

  VoiceRecord({
    required this.text,
    required this.createAt,
    required this.isStt,
  });
}
