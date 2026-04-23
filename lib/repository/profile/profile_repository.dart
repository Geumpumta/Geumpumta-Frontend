import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/user/update_profile_request_dto.dart';
import 'package:geumpumta/models/dto/user/image_upload_response_dto.dart';
import 'package:geumpumta/service/retrofit/profile_api.dart';

class ProfileRepository {
  ProfileRepository(this._api, this._dio);

  final ProfileApi _api;
  final Dio _dio;

  Future<bool> verifyNickname(String nickname) async {
    final response = await _api.verifyNickname(nickname);
    return response.data.isAvailable;
  }

  Future<ImageUploadResult> uploadProfileImage(
    File imageFile, {
    CancelToken? cancelToken,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final fileName = imageFile.path.split(Platform.pathSeparator).last;
    final multipartFile = await MultipartFile.fromFile(
      imageFile.path,
      filename: fileName,
    );

    final formData = FormData()..files.add(MapEntry('image', multipartFile));
    final response = await _dio
        .post<Map<String, dynamic>>(
          '/api/v1/image/profile',
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
          cancelToken: cancelToken,
        )
        .timeout(
          timeout,
          onTimeout: () {
            if (cancelToken != null && !cancelToken.isCancelled) {
              cancelToken.cancel(ImageUploadTimeoutException.cancelReason);
            }
            throw const ImageUploadTimeoutException();
          },
        );

    final responseDto = ImageUploadResponseDto.fromJson(
      response.data ?? const <String, dynamic>{},
    );
    if (!responseDto.success) {
      throw Exception('이미지 업로드에 실패했습니다.');
    }

    return ImageUploadResult(
      imageUrl: responseDto.data.imageUrl,
      publicId: responseDto.data.publicId,
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

class ImageUploadTimeoutException implements Exception {
  const ImageUploadTimeoutException();

  static const String cancelReason = 'image_upload_timeout';

  @override
  String toString() => 'ImageUploadTimeoutException';
}
