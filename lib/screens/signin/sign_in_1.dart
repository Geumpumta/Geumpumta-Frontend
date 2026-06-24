import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/viewmodel/auth/auth_viewmodel.dart';

import '../../provider/signin/signin_provider.dart';
import '../../widgets/back_and_progress/back_and_progress.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_input/custom_input.dart';

class SignIn1Screen extends ConsumerStatefulWidget {
  const SignIn1Screen({super.key});

  @override
  ConsumerState<SignIn1Screen> createState() => _SignIn1ScreenState();
}

class _SignIn1ScreenState extends ConsumerState<SignIn1Screen> {
  final studentIdController = TextEditingController();
  final emailController = TextEditingController();

  bool isStudentIdValid = false;
  bool isEmailValid = false;

  @override
  void dispose() {
    studentIdController.dispose();
    emailController.dispose();
    super.dispose();
  }

  bool _validateEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@kumoh\.ac\.kr$');
    return regex.hasMatch(email);
  }

  bool _validateStudentId(String id) {
    final regex = RegExp(r'^\d{8,10}$');
    return regex.hasMatch(id);
  }

  Future<void> _handleCancelSignup() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('회원가입을 그만둘까요?'),
          content: const Text('지금까지 입력한 내용은 저장되지 않고 로그인 화면으로 돌아갑니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('계속하기'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('그만두기'),
            ),
          ],
        );
      },
    );

    if (shouldCancel == true && mounted) {
      await ref.read(authViewModelProvider.notifier).cancelGuestSignup();
    }
  }

  @override
  Widget build(BuildContext context) {
    final signIn = ref.watch(signUpProvider);
    final signInNotifier = ref.read(signUpProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _handleCancelSignup();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackAndProgress(percent: 0, onBack: _handleCancelSignup),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          '정보 기입',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      CustomInput(
                        title: '학번',
                        hintText: '20000000',
                        controller: studentIdController,
                        errorText:
                            isStudentIdValid || studentIdController.text.isEmpty
                            ? null
                            : '학번은 8~10자리 숫자여야 합니다.',
                        onChanged: (v) {
                          final valid = _validateStudentId(v);
                          setState(() => isStudentIdValid = valid);
                          signInNotifier.setStep1(v, signIn.email);
                        },
                        inputType: InputType.number,
                        value: signIn.studentId,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      CustomInput(
                        title: '학교 이메일',
                        hintText: 'hi@kumoh.ac.kr',
                        controller: emailController,
                        errorText: isEmailValid || emailController.text.isEmpty
                            ? null
                            : '학교 이메일은 @kumoh.ac.kr로 끝나야 합니다.',
                        onChanged: (v) {
                          final valid = _validateEmail(v);
                          setState(() => isEmailValid = valid);
                          signInNotifier.setStep1(signIn.studentId, v);
                        },
                        inputType: InputType.email,
                        value: signIn.email,
                      ),
                    ],
                  ),
                  CustomButton(
                    buttonText: '다음',
                    onActive: isStudentIdValid && isEmailValid,
                    onPressed: () async {
                      Navigator.pushNamed(context, '/signin2');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
