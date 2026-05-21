import 'package:flutter_riverpod/flutter_riverpod.dart';

final studyRunningProvider = StateProvider<bool>((ref) => false);

class AppInteractionLockNotifier extends StateNotifier<int> {
  AppInteractionLockNotifier() : super(0);

  bool get isLocked => state > 0;

  void lock() {
    state += 1;
  }

  void unlock() {
    if (state == 0) return;
    state -= 1;
  }
}

final appInteractionLockProvider =
    StateNotifierProvider<AppInteractionLockNotifier, int>((ref) {
      return AppInteractionLockNotifier();
    });

final appInteractionLockedProvider = Provider<bool>((ref) {
  return ref.watch(appInteractionLockProvider) > 0;
});
