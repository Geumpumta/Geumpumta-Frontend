import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/screens/signin/widgets/department_scroll_down.dart';
import 'package:geumpumta/viewmodel/auth/auth_viewmodel.dart';
import 'package:geumpumta/viewmodel/email/email_viewmodel.dart';
import 'package:geumpumta/widgets/custom_search_bar/custom_search_bar.dart';

import '../../provider/signin/signin_provider.dart';
import '../../widgets/back_and_progress/back_and_progress.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/error_dialog/error_dialog.dart';
import '../../widgets/loading_dialog/loading_dialog.dart';

class SignIn2Screen extends ConsumerStatefulWidget {
  const SignIn2Screen({super.key});

  @override
  ConsumerState<SignIn2Screen> createState() => _SignIn2ScreenState();
}

class _SignIn2ScreenState extends ConsumerState<SignIn2Screen> {
  final TextEditingController _searchController = TextEditingController();
  String department = Department.none.koreanName;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchText = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleCancelSignup() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('회원가입을 그만둘까요?'),
          content: const Text('이 계정의 회원가입을 취소하고 로그인 화면으로 돌아갑니다.'),
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
    final signUpState = ref.watch(signUpProvider);
    final signUpNotifier = ref.read(signUpProvider.notifier);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackAndProgress(percent: 0.3, onBack: _handleCancelSignup),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          '학과 선택',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      CustomSearchBar(
                        controller: _searchController,
                        value: _searchController.text,
                        onActive: () => print(_searchController.text),
                      ),
                      Expanded(
                        child: DepartmentScrollDown(
                          searchText: _searchText,
                          onDepartmentSelected: (dept) {
                            setState(() {
                              department = dept.koreanName;
                            });
                          },
                          selected: department,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  buttonText: '다음',
                  onActive: department != Department.none.koreanName,
                  onPressed: () async {
                    LoadingDialog.show(context);

                    try {
                      signUpNotifier.setStep3(department);
                      await emailViewModel.sendEmailVerification(signUpState.email);

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

                      Navigator.pushNamed(context, '/signin3');
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
