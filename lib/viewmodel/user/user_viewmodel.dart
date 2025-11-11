import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/entity/user/user.dart';
import '../../provider/repository_provider.dart';
import '../../repository/user/user_repository.dart';

final userViewModelProvider =
StateNotifierProvider<UserViewModel, AsyncValue<User>>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserViewModel(repo);
});

class UserViewModel extends StateNotifier<AsyncValue<User>> {
  final UserRepository _repo;
  UserViewModel(this._repo) : super(const AsyncLoading());

  Future<void> loadUserProfile() async {
    state = const AsyncLoading();
    try {
      final user = await _repo.getUserProfile();
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
