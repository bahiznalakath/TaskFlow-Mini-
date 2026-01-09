import 'package:hive/hive.dart';

part 'project_hive.g.dart';

@HiveType(typeId: 0)
class ProjectHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool archived;

  // ✅ ADD THIS
  @HiveField(4)
  List<String> assignedUsers;

  ProjectHive({
    required this.id,
    required this.name,
    required this.description,
    this.archived = false,
    this.assignedUsers = const [],
  });
}
