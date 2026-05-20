import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:geumpumta/viewmodel/auth/auth_viewmodel.dart';
import 'package:geumpumta/viewmodel/email/email_viewmodel.dart';
import 'package:geumpumta/viewmodel/user/user_viewmodel.dart';

import '../../provider/signin/signin_provider.dart';
import '../../widgets/back_and_progress/back_and_progress.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_input/custom_input.dart';
import '../../widgets/error_dialog/error_dialog.dart';
import '../../widgets/loading_dialog/loading_dialog.dart';

final isVerifyingProvider = StateProvider<bool>((ref) => false);

class SignIn3Screen extends ConsumerStatefulWidget {
  const SignIn3Screen({super.key});

  @override
  ConsumerState<SignIn3Screen> createState() => _SignIn3ScreenState();
}

class _SignIn3ScreenState extends ConsumerState<SignIn3Screen> {
  static const int _resendCooldownSeconds = 120;

  final codeController = TextEditingController();
  bool isCodeValid = false;
  Timer? _resendTimer;
  int _remainingResendSeconds = _resendCooldownSeconds;
  bool _isResending = false;

  bool _validateCode(String code) {
    final regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(code);
  }

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    codeController.dispose();
    super.dispose();
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    setState(() {
      _remainingResendSeconds = _resendCooldownSeconds;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remainingResendSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingResendSeconds = 0;
        });
        return;
      }

      setState(() {
        _remainingResendSeconds -= 1;
      });
    });
  }

  String get _reloadLabel {
    if (_isResending) {
      return '전송중';
    }
    if (_remainingResendSeconds == 0) {
      return '재전송';
    }

    final minutes = (_remainingResendSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingResendSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _handleResendEmail() async {
    if (_isResending || _remainingResendSeconds > 0) {
      return;
    }

    setState(() {
      _isResending = true;
    });

    final emailViewModel = ref.read(emailViewModelProvider);
    final signUpState = ref.read(signUpProvider);

    try {
      await emailViewModel.sendEmailVerification(signUpState.email);
      _startResendCooldown();

      if (!mounted) {
        return;
      }

      Flushbar(
        message: "인증 메일을 다시 전송했어요!",
        backgroundColor: Colors.green.shade600,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(10),
        duration: const Duration(seconds: 2),
        icon: const Icon(
          Icons.check_circle,
          color: Colors.white,
        ),
      ).show(context);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ErrorDialog.show(context, "메일 전송 실패: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  Future<void> _handleCancelSignup() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('회원가입을 그만둘까요?'),
          content: const Text('가입을 취소하면 로그인 화면으로 돌아가며 다른 계정으로 다시 시작할 수 있습니다.'),
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
    final emailViewModel = ref.watch(emailViewModelProvider);
    final userViewmodel = ref.watch(userViewModelProvider.notifier);
    final signUpState = ref.watch(signUpProvider);
    final isVerifying = ref.watch(isVerifyingProvider);
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _handleCancelSignup();
        }
      },
      child: GestureDetector(
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
                      BackAndProgress(percent: 0.6, onBack: _handleCancelSignup),
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
                                    'assets/image/signin/verification_code_img.png',
                                    width: 150,
                                  ),
                                ),
                              )
                            : const SizedBox(key: ValueKey('image_hidden')),
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
                        onReLoad: _handleResendEmail,
                        reloadLabel: _reloadLabel,
                        isReloadEnabled:
                            !_isResending && _remainingResendSeconds == 0,
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

                        if (!result) {
                          LoadingDialog.hide(context);
                          ErrorDialog.show(context, "인증번호가 올바르지 않습니다.");
                          return;
                        }

                        LoadingDialog.hide(context);

                        final res = await userViewmodel.completeRegistration(
                          context,
                          signUpState.email,
                          signUpState.studentId,
                          signUpState.department,
                        );

                        if (res == null || !res.success) {
                          return;
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
      ),
    );
  }
}
