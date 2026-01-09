import 'package:hive/hive.dart';

part 'user_hive.g.dart';

@HiveType(typeId: 3)
class UserHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  @HiveField(3)
  String role; // admin / employee

  UserHive({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
  });
}
