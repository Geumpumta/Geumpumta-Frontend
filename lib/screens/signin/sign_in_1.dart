import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/viewmodel/email/email_viewmodel.dart';
import 'package:geumpumta/widgets/error_dialog/error_dialog.dart';
import '../../provider/signin/signin_provider.dart';
import '../../widgets/back_and_progress/back_and_progress.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_input/custom_input.dart';
import '../../widgets/loading_dialog/loading_dialog.dart';

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
  void initState() {
    super.initState();
    _showPrivacyPopup();
  }

  @override
  void dispose() {
    studentIdController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _showPrivacyPopup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false, // 바깥 터치로 닫히지 않게
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "개인정보 수집 및 이용 안내",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            content: const Text(
              "입력하시는 학번과 학교 이메일은\n"
              "계정 생성과 본인 확인을 위해서만 사용되며,\n"
              "그 외의 목적으로는 사용되지 않습니다.\n\n"
              "확인을 눌러 계속 진행해주세요.",
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "확인",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  bool _validateEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@kumoh\.ac\.kr$');
    return regex.hasMatch(email);
  }

  bool _validateStudentId(String id) {
    final regex = RegExp(r'^\d{8,10}$');
    return regex.hasMatch(id);
  }

  @override
  Widget build(BuildContext context) {
    final signIn = ref.watch(signUpProvider);
    final signInNotifier = ref.read(signUpProvider.notifier);
    final emailViewModel = ref.watch(emailViewModelProvider);

    return Scaffold(
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
                    const BackAndProgress(percent: 0),
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
                  buttonText: '인증',
                  onActive: isStudentIdValid && isEmailValid,
                  onPressed: () async {
                    LoadingDialog.show(context);

                    try {
                      await emailViewModel.sendEmailVerification(
                        emailController.text.trim(),
                      );

                      LoadingDialog.hide(context);

                      Flushbar(
                        message: "인증 메일을 전송했어요!",
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

                      Navigator.pushNamed(
                        context,
                        '/signin2',
                        arguments: emailController.text.trim(),
                      );
                    } catch (e) {
                      LoadingDialog.hide(context);
                      ErrorDialog.show(context, "메일 전송 실패: $e");
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
