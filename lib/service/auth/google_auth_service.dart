import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> signIn() async {
    try {
      // final result = await _googleSignIn.signIn();
      // if (result == null) {
      //   print('구글 로그인 취소됨');
      //   return;
      // }
      // print('구글 로그인 성공: ${result.email}');
    } catch (e) {
      print('구글 로그인 실패: $e');
    }
  }
}
