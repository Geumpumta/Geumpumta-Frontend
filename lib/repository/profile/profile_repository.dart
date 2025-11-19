import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/user/update_profile_request_dto.dart';
import 'package:geumpumta/service/retrofit/profile_api.dart';

class ProfileRepository {
  ProfileRepository(this._api);

  final ProfileApi _api;

  Future<bool> verifyNickname(String nickname) async {
    final response = await _api.verifyNickname(nickname);
    return response.data.isAvailable;
  }

  Future<ImageUploadResult> uploadProfileImage(File imageFile) async {
    final fileName = imageFile.path.split(Platform.pathSeparator).last;
    final multipartFile = await MultipartFile.fromFile(
      imageFile.path,
      filename: fileName,
    );

    final response = await _api.uploadProfileImage(multipartFile);
    return ImageUploadResult(
      imageUrl: response.data.imageUrl,
      publicId: response.data.publicId,
    );
  }

  Future<void> updateUserProfile({
    required String nickname,
    required String imageUrl,
    required String publicId,
  }) async {
    await _api.updateUserProfile(
      UpdateProfileRequestDto(
        nickname: nickname,
        imageUrl: imageUrl,
        publicId: publicId,
      ),
    );
  }
}

class ImageUploadResult {
  ImageUploadResult({
    required this.imageUrl,
    required this.publicId,
  });

  final String imageUrl;
  final String publicId;
}

