import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void dispose() {
    studentIdController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signIn = ref.watch(signUpProvider);
    final signInNotifier = ref.read(signUpProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackAndProgress(percent: 0),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      '정보 기입',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  CustomInput(
                    title: '학번',
                    hintText: '20000000',
                    controller: studentIdController,
                    onChanged: (v) => signInNotifier.setStep1(v, signIn.email),
                    inputType: InputType.number,
                    value: signIn.studentId,
                  ),
                  CustomInput(
                    title: '학교 이메일',
                    hintText: 'hi@kumoh.ac.kr',
                    controller: emailController,
                    onChanged: (v) =>
                        signInNotifier.setStep1(signIn.studentId, v),
                    inputType: InputType.email,
                    value: signIn.email,
                  ),
                ],
              ),
              CustomButton(
                buttonText: '인증',
                onActive: signIn.isStep1Filled && studentIdController.text.isNotEmpty && emailController.text.isNotEmpty,
                onPressed: () => Navigator.pushNamed(context, '/signin2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
