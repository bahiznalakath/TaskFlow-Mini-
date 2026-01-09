import 'package:hive/hive.dart';

part 'subtask_hive.g.dart';

@HiveType(typeId: 2)
class SubtaskHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String taskId;

  @HiveField(2)
  String title;

  @HiveField(3)
  bool completed;

  @HiveField(4)
  String? assignee;

  SubtaskHive({
    required this.id,
    required this.taskId,
    required this.title,
    this.completed = false,
    this.assignee,
  });
}
