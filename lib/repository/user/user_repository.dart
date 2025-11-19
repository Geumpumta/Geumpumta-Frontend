import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/models/dto/user/complete_registration_request_dto.dart';
import 'package:geumpumta/repository/auth/auth_repository.dart';

import '../../models/entity/user/user.dart';
import '../../service/retrofit/user_api.dart';

class UserRepository {
  final UserApi _api;
  final AuthRepository _authRepository;

  UserRepository(this._api, this._authRepository);

  Future<User> getUserProfile() async {
    try {
      final response = await _api.getUserProfile();
      final dto = response.data;

      return User(
        name: dto.name,
        nickName: dto.nickName,
        email: dto.email,
        schoolEmail: dto.schoolEmail,
        userRole: dto.userRole,
        profileImage: dto.profilePictureUrl,
        oAuthProvider: dto.OAuthProvider,
        studentId: dto.studentId,
        department: DepartmentParser.fromKorean(dto.department),
      );
    } catch (e, st) {
      rethrow;
    }
  }

  Future<void> completeRegistration(
    String email,
    String studentId,
    String department,
  ) async {
    try {
      final response = await _api.completeRegistration(
        CompleteRegistrationRequestDto(
          email: email,
          studentId: studentId,
          department: department,
        ),
      );
      _authRepository.updateTokens(
        response.data.accessToken,
        response.data.refreshToken,
      );
    } catch (e, st) {
      rethrow;
    }
  }

}
