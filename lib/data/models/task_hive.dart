import 'package:hive/hive.dart';

part 'task_hive.g.dart';

@HiveType(typeId: 1)
class TaskHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String projectId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  @HiveField(4)
  int status;

  @HiveField(5)
  int priority;

  @HiveField(6)
  DateTime startDate;

  @HiveField(7)
  DateTime dueDate;

  @HiveField(8)
  double estimate;

  @HiveField(9)
  double timeSpent;

  @HiveField(10)
  List<String> assignees;

  @HiveField(11)
  List<String> labels;

  TaskHive({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.startDate,
    required this.dueDate,
    required this.estimate,
    required this.timeSpent,
    required this.assignees,
    required this.labels,
  });
}
