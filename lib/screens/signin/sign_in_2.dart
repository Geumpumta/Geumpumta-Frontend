import 'package:flutter/material.dart';
import 'package:geumpumta/widgets/custom_input/custom_input.dart';
import '../../widgets/back_and_progress/back_and_progress.dart';
import '../../widgets/custom_button/custom_button.dart';

class SignIn2Screen extends StatefulWidget {
  const SignIn2Screen({super.key});

  @override
  State<SignIn2Screen> createState() => _SignIn2ScreenState();
}

class _SignIn2ScreenState extends State<SignIn2Screen> {
  String code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Image.asset(
                        'assets/image/signin/verification_code_img.png',
                      ),
                    ),
                  ),
                  CustomInput(
                    title: '인증번호',
                    value: code,
                    hintText: '123456',
                    onChanged: (v) => setState(() => code = v),
                    inputType: InputType.number,
                  ),
                ],
              ),
              CustomButton(
                buttonText: '확인',
                onActive: code.isNotEmpty,
                onPressed: () => Navigator.pushNamed(context, '/signin3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
