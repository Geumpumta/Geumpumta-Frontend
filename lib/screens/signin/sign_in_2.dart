import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/viewmodel/email/email_viewmodel.dart';
import '../../provider/signin/signin_provider.dart';
import '../../widgets/back_and_progress/back_and_progress.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_input/custom_input.dart';
import '../../widgets/loading_dialog/loading_dialog.dart';
import '../../widgets/error_dialog/error_dialog.dart';

final isVerifyingProvider = StateProvider<bool>((ref) => false);

class SignIn2Screen extends ConsumerStatefulWidget {
  const SignIn2Screen({super.key});

  @override
  ConsumerState<SignIn2Screen> createState() => _SignIn2ScreenState();
}

class _SignIn2ScreenState extends ConsumerState<SignIn2Screen> {
  final codeController = TextEditingController();
  bool isCodeValid = false;

  bool _validateCode(String code) {
    final regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(code);
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailViewModel = ref.watch(emailViewModelProvider);
    final signUpState = ref.watch(signUpProvider);
    final isVerifying = ref.watch(isVerifyingProvider);

    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackAndProgress(percent: 0.3),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        '학교 이메일로 인증번호\n6자리를 보냈어요',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },

                        child: !isKeyboardVisible
                          ? Container(
                        key: const ValueKey('image_visible'),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Image.asset(
                            width: 150,
                            'assets/image/signin/verification_code_img.png',
                          ),
                        ),
                      )
                          : const SizedBox(
                        key: ValueKey('image_hidden'),
                      ),
                    ),
                    CustomInput(
                      title: '인증번호',
                      value: codeController.text,
                      controller: codeController,
                      hintText: '123456',
                      onChanged: (v) {
                        final valid = _validateCode(v);
                        setState(() {
                          isCodeValid = valid;
                        });
                      },
                      inputType: InputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      errorText: codeController.text.isEmpty || isCodeValid
                          ? null
                          : '인증번호는 6자리 숫자여야 합니다.',
                    ),
                  ],
                ),

                CustomButton(
                  buttonText: '확인',
                  onActive: isCodeValid && !isVerifying,
                  onPressed: () async {
                    ref.read(isVerifyingProvider.notifier).state = true;

                    LoadingDialog.show(context);

                    try {
                      final result = await emailViewModel.verifyCode(
                        signUpState.email,
                        codeController.text.trim(),
                      );

                      LoadingDialog.hide(context);

                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("인증 성공!"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.pushNamed(context, '/signin3');
                      } else {
                        ErrorDialog.show(context, "인증번호가 올바르지 않습니다.");
                      }
                    } catch (e) {
                      LoadingDialog.hide(context);
                      ErrorDialog.show(context, "인증 오류: $e");
                    } finally {
                      ref.read(isVerifyingProvider.notifier).state = false;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
