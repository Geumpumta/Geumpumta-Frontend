import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/badge/my_badge.dart';
import 'package:geumpumta/models/entity/badge/unnotified_badge.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/badge/badge_repository.dart';

final badgeViewModelProvider =
    StateNotifierProvider<BadgeViewModel, AsyncValue<MyBadge?>>((ref) {
      final repo = ref.watch(badgeRepositoryProvider);
      return BadgeViewModel(repo);
    });

final unnotifiedBadgeListViewModelProvider =
    StateNotifierProvider<
      UnnotifiedBadgeListViewModel,
      AsyncValue<List<UnnotifiedBadge>>
    >((ref) {
      final repo = ref.watch(badgeRepositoryProvider);
      return UnnotifiedBadgeListViewModel(repo);
    });

final activityBadgeListViewModelProvider =
    StateNotifierProvider<ActivityBadgeListViewModel, AsyncValue<List<MyBadge>>>(
      (ref) {
        final repo = ref.watch(badgeRepositoryProvider);
        return ActivityBadgeListViewModel(repo);
      },
    );

class BadgeViewModel extends StateNotifier<AsyncValue<MyBadge?>> {
  BadgeViewModel(this._repository) : super(const AsyncLoading());

  final BadgeRepository _repository;

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

class UnnotifiedBadgeListViewModel
    extends StateNotifier<AsyncValue<List<UnnotifiedBadge>>> {
  UnnotifiedBadgeListViewModel(this._repository) : super(const AsyncLoading());

  final BadgeRepository _repository;

  Future<void> loadUnnotifiedBadges() async {
    state = const AsyncLoading();
    try {
      final badges = await _repository.fetchUnnotifiedBadges();
      state = AsyncData(badges);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

class ActivityBadgeListViewModel
    extends StateNotifier<AsyncValue<List<MyBadge>>> {
  ActivityBadgeListViewModel(this._repository) : super(const AsyncLoading());

  final BadgeRepository _repository;

  Future<void> loadMyBadges() async {
    state = const AsyncLoading();
    try {
      final badges = await _repository.fetchMyBadges();
      state = AsyncData(badges);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
