import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/user/image_upload_response_dto.dart';
import 'package:geumpumta/models/dto/user/nickname_verify_response_dto.dart';
import 'package:geumpumta/models/dto/user/update_profile_request_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio, {String baseUrl}) = _ProfileApi;

  @GET('/api/v1/user/nickname/verify')
  Future<NicknameVerifyResponseDto> verifyNickname(
    @Query('nickname') String nickname,
  );

  @POST('/api/v1/image/profile')
  @MultiPart()
  Future<ImageUploadResponseDto> uploadProfileImage(
    @Part(name: 'image') MultipartFile image,
  );

  @POST('/api/v1/user/profile')
  Future<void> updateUserProfile(
    @Body() UpdateProfileRequestDto request,
  );
}

