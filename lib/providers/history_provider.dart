import 'package:demo_app/models/voice_record.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

class HistoryNotifier extends StateNotifier<List<VoiceRecord>> {
  final Box<VoiceRecord> _box;
  HistoryNotifier(this._box) : super([]) {
    loadRecords();
  }

  void loadRecords() {
    state = _box.values.toList().reversed.take(5).toList();
  }

  Future<void> saveRecords({required String text, required bool isStt}) async {
    if (text.trim().isEmpty) return;

    final newRecord = VoiceRecord(
      text: text,
      createAt: DateTime.now(),
      isStt: isStt,
    );
    // List<VoiceRecord> currentList = _box.values.toList();

    // currentList.add(newRecord);

    // if (currentList.length > 5) {
    //   await _box.deleteAt(0);
    //   currentList.removeAt(0);
    // }

    await _box.add(newRecord);
    // state = _box.values.toList().reversed.toList();
    loadRecords();
  }

  Future<void> deleteRecords(int uiIndex) async {
    int hiveIndex = (_box.length - 1) - uiIndex;
    if (hiveIndex >= 0 && hiveIndex < _box.length) {
      await _box.deleteAt(hiveIndex);
      loadRecords();
    }
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<VoiceRecord>>((ref) {
      final box = Hive.box<VoiceRecord>('history');
      return HistoryNotifier(box);
    });
