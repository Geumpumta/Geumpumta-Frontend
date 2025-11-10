import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoAuthService {
  Future<void> signIn() async {
    try {
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }
      print('카카오 로그인 성공!');
    } catch (e) {
      print('카카오 로그인 실패: $e');
    }
  }
}
