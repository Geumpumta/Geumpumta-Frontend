
import '../../models/entity/user/user.dart';
import '../../service/retrofit/user_api.dart';

class UserRepository {
  final UserApi _api;
  UserRepository(this._api);

  Future<User> getUserProfile() async {
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
      department: dto.department,
    );
  }
}
