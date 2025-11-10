import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/viewmodel/auth/auth_viewmodel.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(authViewModelProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/login/main_logo.png',
              ),
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/image/login/main_img.png',
              ),
              const SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: (){
                  viewModel.loginWithKakao();
                  // Navigator.pushNamed(context, AppRoutes.signin1);
                },
                child: Image.asset(
                  'assets/image/login/kakao_login_icon.png'
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  viewModel.loginWithGoogle();
                  print('구글 로그인. 서버 연결 시 service 파일 연결');
                },
                child: Image.asset(
                    'assets/image/login/google_login_icon.png'
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
