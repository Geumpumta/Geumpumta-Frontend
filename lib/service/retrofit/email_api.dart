import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/common/common_dto.dart';
import 'package:geumpumta/models/dto/email/send_email_verification_request_dto.dart';
import 'package:geumpumta/models/dto/email/verify_code_request_dto.dart';
import 'package:geumpumta/models/dto/email/verify_code_response_dto.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'email_api.g.dart';

@RestApi()
abstract class EmailApi{
  factory EmailApi(Dio dio, {String baseUrl}) = _EmailApi;

  @POST('/api/v1/email/request-code')
  Future<CommonDto> sendEmailVerification(
      @Body() SendEmailVerificationRequestDto request,
      );
  
  @POST('/api/v1/email/verify-code')
  Future<VerifyCodeResponseDto> verifyCode(
      @Body() VerifyCodeRequestDto request,
      );
}