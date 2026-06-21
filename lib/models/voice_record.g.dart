// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoiceRecordAdapter extends TypeAdapter<VoiceRecord> {
  @override
  final int typeId = 0;

  @override
  VoiceRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoiceRecord(
      text: fields[0] as String,
      createAt: fields[1] as DateTime,
      isStt: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, VoiceRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.createAt)
      ..writeByte(2)
      ..write(obj.isStt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
