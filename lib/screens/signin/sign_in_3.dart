import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/screens/signin/widgets/department_scroll_down.dart';
import 'package:geumpumta/viewmodel/auth/auth_viewmodel.dart';
import 'package:geumpumta/viewmodel/user/user_viewmodel.dart';
import 'package:geumpumta/widgets/custom_search_bar/custom_search_bar.dart';
import '../../provider/signin/signin_provider.dart';
import '../../widgets/back_and_progress/back_and_progress.dart';
import '../../widgets/custom_button/custom_button.dart';

class SignIn3Screen extends ConsumerStatefulWidget {
  const SignIn3Screen({super.key});

  @override
  ConsumerState<SignIn3Screen> createState() => _SignIn3ScreenState();
}

class _SignIn3ScreenState extends ConsumerState<SignIn3Screen> {
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
    final userViewmodel = ref.watch(userViewModelProvider.notifier);
    final signUpState = ref.watch(signUpProvider);

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
                      BackAndProgress(percent: 0.6, onBack: _handleCancelSignup),
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
                            print('선택된 학과: ${dept.koreanName}');
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
                  buttonText: '확인',
                  onActive: department != Department.none.koreanName,
                  onPressed: () async {
                    final res = await userViewmodel.completeRegistration(
                      context,
                      signUpState.email,
                      signUpState.studentId,
                      department,
                    );

                    if (res == null || !res.success) {
                      return;
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
