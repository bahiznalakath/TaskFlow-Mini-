import 'package:hive/hive.dart';
import '../../data/models/user_hive.dart';

Future<void> seedUsers() async {
  final box = Hive.box<UserHive>('users');

  if (box.isNotEmpty) return;

  await box.putAll({
    'u1': UserHive(
      id: 'u1',
      email: 'admin@test.com',
      password: '123456',
      role: 'admin',
    ),
    'u2': UserHive(
      id: 'u2',
      email: 'staff1@test.com',
      password: '123456',
      role: 'employee',
    ),
    'u3': UserHive(
      id: 'u3',
      email: 'staff2@test.com',
      password: '123456',
      role: 'employee',
    ),
  });
}
