import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/user/complete_registration_request_dto.dart';
import 'package:geumpumta/models/dto/user/complete_registration_response_dto.dart';
import 'package:geumpumta/models/dto/user/get_user_info_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @GET("/api/v1/user/profile")
  Future<GetUserInfoResponseDto> getUserProfile();
  
  @POST('/api/v1/user/complete-registration')
  Future<CompleteRegistrationResponseDto> completeRegistration(
      @Body() CompleteRegistrationRequestDto request
      );
}
