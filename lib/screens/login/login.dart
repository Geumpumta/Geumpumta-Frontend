import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geumpumta/viewmodel/auth/auth_viewmodel.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authViewModelProvider);
    final authViewModel = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/image/login/main_logo.svg'),
              const SizedBox(height: 60),
              Image.asset(
                'assets/image/login/main_img.png',
                filterQuality: FilterQuality.high,
              ),
              const SizedBox(height: 80),

              GestureDetector(
                onTap: isLoading
                    ? null
                    : () => authViewModel.loginWithKakao(context),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/image/login/kakao_login_icon.png'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: isLoading
                    ? null
                    : () => authViewModel.loginWithGoogle(context),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/image/login/google_login_icon.png'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: isLoading
                    ? null
                    : () => authViewModel.loginWithApple(context),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/image/login/apple_login_icon.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
