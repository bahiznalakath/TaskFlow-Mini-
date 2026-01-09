import 'package:hive/hive.dart';
import '../../data/models/user_hive.dart';

class AuthService {
  static UserHive? login(String email, String password) {
    final box = Hive.box<UserHive>('users');

    try {
      return box.values.firstWhere(
            (u) => u.email == email && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  static UserHive? getCurrentUser() {
    if (!Hive.isBoxOpen('session') || !Hive.isBoxOpen('users')) {
      return null;
    }

    final sessionBox = Hive.box('session');
    final userId = sessionBox.get('userId');

    if (userId == null) return null;

    final usersBox = Hive.box<UserHive>('users');
    return usersBox.get(userId);
  }

  static bool isAdmin() {
    return getCurrentUser()?.role == 'admin';
  }
  static bool isEmployee() {
    return getCurrentUser()?.role == 'employee';
  }
}
