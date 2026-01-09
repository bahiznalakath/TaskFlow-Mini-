// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubtaskHiveAdapter extends TypeAdapter<SubtaskHive> {
  @override
  final int typeId = 2;

  @override
  SubtaskHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubtaskHive(
      id: fields[0] as String,
      taskId: fields[1] as String,
      title: fields[2] as String,
      completed: fields[3] as bool,
      assignee: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubtaskHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.completed)
      ..writeByte(4)
      ..write(obj.assignee);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubtaskHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
