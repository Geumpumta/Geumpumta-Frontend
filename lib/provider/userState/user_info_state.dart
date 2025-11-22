import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/user/user.dart';

final userInfoStateProvider =
StateNotifierProvider<UserInfoNotifier, User?>(
      (ref) => UserInfoNotifier(),
);

class UserInfoNotifier extends StateNotifier<User?> {
  UserInfoNotifier() : super(null);

  void setUser(User? user) {
    state = user;
  }

  void clear() {
    state = null;
  }

  void updateTotalMillis(int newTotalMillis) {
    if (state == null) return;

    state = state!.copyWith(
      totalMillis: newTotalMillis,
    );
  }
}
