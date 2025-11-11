import 'package:geumpumta/models/dto/email/send_email_verification_request_dto.dart';
import 'package:geumpumta/models/dto/email/verify_code_request_dto.dart';
import 'package:geumpumta/service/retrofit/email_api.dart';

class EmailRepository {
  final EmailApi emailApi;

  EmailRepository({required this.emailApi});

  Future<void> sendEmailVerification(String email) async {
    try {
      final response = await emailApi.sendEmailVerification(
        SendEmailVerificationRequestDto(email: email),
      );
      if (!response.success) throw Exception('이메일 전송 실패');
    } catch (e,st) {
      print('[UserRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }

  Future<bool> verifyCode(String email, String code) async {
    try {
      final response = await emailApi.verifyCode(
        VerifyCodeRequestDto(email: email, code: code),
      );
      return response.data.isVerified;
    } catch (e) {
      return false;
    }
  }
}
