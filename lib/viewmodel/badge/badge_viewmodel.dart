import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/badge/my_badge.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/badge/badge_repository.dart';

final badgeViewModelProvider =
    StateNotifierProvider<BadgeViewModel, AsyncValue<MyBadge?>>((ref) {
  final repo = ref.watch(badgeRepositoryProvider);
  return BadgeViewModel(repo);
});

class BadgeViewModel extends StateNotifier<AsyncValue<MyBadge?>> {
  BadgeViewModel(this._repository) : super(const AsyncLoading());

  final BadgeRepository _repository;

  Future<void> loadMyBadge() async {
    state = const AsyncLoading();
    try {
      final badge = await _repository.fetchMyBadge();
      state = AsyncData(badge);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> setRepresentativeBadge(String badgeCode) async {
    state = const AsyncLoading();
    try {
      final badge = await _repository.setRepresentativeBadge(badgeCode);
      state = AsyncData(badge);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

