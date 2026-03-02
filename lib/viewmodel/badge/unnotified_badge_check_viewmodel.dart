import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/badge/unnotified_badge.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/badge/badge_repository.dart';

final unnotifiedBadgeCheckViewModelProvider =
    StateNotifierProvider<
      UnnotifiedBadgeCheckViewModel,
      AsyncValue<List<UnnotifiedBadge>>
    >((ref) {
      final repo = ref.watch(badgeRepositoryProvider);
      return UnnotifiedBadgeCheckViewModel(repo);
    });

class UnnotifiedBadgeCheckViewModel
    extends StateNotifier<AsyncValue<List<UnnotifiedBadge>>> {
  UnnotifiedBadgeCheckViewModel(this._repository) : super(const AsyncData([]));

  final BadgeRepository _repository;
  bool _isChecking = false;

  Future<List<UnnotifiedBadge>> checkUnnotifiedBadges() async {
    if (_isChecking) {
      return const <UnnotifiedBadge>[];
    }

    _isChecking = true;
    state = const AsyncLoading();
    try {
      final badges = await _repository.fetchUnnotifiedBadges();
      state = AsyncData(badges);
      return badges;
    } catch (e, st) {
      state = AsyncError(e, st);
      return const <UnnotifiedBadge>[];
    } finally {
      _isChecking = false;
    }
  }
}
