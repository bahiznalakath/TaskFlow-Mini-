import 'package:hive/hive.dart';

class SessionManager {
  static const _boxName = 'session';

  static Future<void> saveUser(String userId) async {
    final box = Hive.box(_boxName);
    await box.put('userId', userId);
  }

  static String? getUser() {
    if (!Hive.isBoxOpen(_boxName)) return null;
    final box = Hive.box(_boxName);
    return box.get('userId');
  }

  // static Future<void> logout() async {
  //   if (!Hive.isBoxOpen(_boxName)) return;
  //   final box = Hive.box(_boxName);
  //   await box.clear();
  // }

  static Future<void> logout() async {
    if (!Hive.isBoxOpen(_boxName)) return;
    await Hive.box(_boxName).clear();
  }




}
