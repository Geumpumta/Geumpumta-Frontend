import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userInfoStateProvider =
StateNotifierProvider<UserInfoNotifier, User?>(
      (ref) => UserInfoNotifier(),
);

class UserInfoNotifier extends StateNotifier<User?> {
  UserInfoNotifier() : super(null);

  Future<void> setUser(User? user) async {
    state = user;

    final prefs = await SharedPreferences.getInstance();

    if (user == null) {
      await prefs.remove('userInfo');
    } else {
      final jsonString = jsonEncode(user.toJson());
      await prefs.setString('userInfo', jsonString);
      print(">>> SharedPreferences 저장 완료: $jsonString");
    }
  }

  Future<void> clear() async {
    state = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userInfo');
  }

  Future<void> updateTotalMillis(int newTotalMillis) async {
    if (state == null) return;

    state = state!.copyWith(totalMillis: newTotalMillis);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userInfo', jsonEncode(state!.toJson()));
  }
}
