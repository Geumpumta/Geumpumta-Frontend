import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/repository/profile/profile_repository.dart';
import 'package:geumpumta/provider/repository_provider.dart';

final profileEditViewModelProvider =
    StateNotifierProvider<ProfileEditViewModel, AsyncValue<void>>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return ProfileEditViewModel(repo);
});

class ProfileEditViewModel extends StateNotifier<AsyncValue<void>> {
  ProfileEditViewModel(this._profileRepository) : super(const AsyncData(null));

  final ProfileRepository _profileRepository;

  Future<bool> verifyNickname(String nickname) async {
    state = const AsyncLoading();
    try {
      final isAvailable = await _profileRepository.verifyNickname(nickname);
      state = const AsyncData(null);
      return isAvailable;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<ImageUploadResult> uploadImage(File imageFile) async {
    state = const AsyncLoading();
    try {
      final result = await _profileRepository.uploadProfileImage(imageFile);
      state = const AsyncData(null);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String nickname,
    required String imageUrl,
    required String publicId,
  }) async {
    state = const AsyncLoading();
    try {
      await _profileRepository.updateUserProfile(
        nickname: nickname,
        imageUrl: imageUrl,
        publicId: publicId,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}


