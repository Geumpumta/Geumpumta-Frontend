import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/routes/app_routes.dart';
import 'package:geumpumta/viewmodel/auth/auth_viewmodel.dart';

import '../../widgets/back_and_progress/back_and_progress.dart';
import '../../widgets/custom_button/custom_button.dart';

class SignInTermsScreen extends ConsumerStatefulWidget {
  const SignInTermsScreen({super.key});

  @override
  ConsumerState<SignInTermsScreen> createState() => _SignInTermsScreenState();
}

class _SignInTermsScreenState extends ConsumerState<SignInTermsScreen> {
  bool _serviceTerms = false;
  bool _privacyTerms = false;
  bool _schoolVerificationTerms = false;
  bool _marketingTerms = false;

  bool get _allRequiredChecked =>
      _serviceTerms && _privacyTerms && _schoolVerificationTerms;

  bool get _allChecked =>
      _serviceTerms &&
      _privacyTerms &&
      _schoolVerificationTerms &&
      _marketingTerms;

  Future<void> _handleCancelSignup() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('회원가입을 그만둘까요?'),
          content: const Text('약관 동의를 중단하고 로그인 화면으로 돌아갑니다.'),
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

  void _toggleAll(bool? value) {
    final checked = value ?? false;
    setState(() {
      _serviceTerms = checked;
      _privacyTerms = checked;
      _schoolVerificationTerms = checked;
      _marketingTerms = checked;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: SafeArea(
          child: Column(
            children: [
              BackAndProgress(percent: 0, onBack: _handleCancelSignup),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '약관 동의',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '금품타 이용을 위해 필요한 약관을 확인하고 동의해주세요.',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _AgreementTile(
                        title: '전체 동의',
                        description: '필수 및 선택 약관에 모두 동의합니다.',
                        value: _allChecked,
                        onChanged: _toggleAll,
                        isAllAgreement: true,
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFE9E9E9)),
                      const SizedBox(height: 12),
                      _AgreementTile(
                        title: '서비스 이용약관 동의',
                        description: '금품타 서비스 이용 규칙과 회원 권리 및 의무를 확인했습니다.',
                        value: _serviceTerms,
                        onChanged: (value) {
                          setState(() => _serviceTerms = value ?? false);
                        },
                        isRequired: true,
                      ),
                      _AgreementTile(
                        title: '개인정보 수집 및 이용 동의',
                        description: '학번과 학교 이메일은 계정 생성과 본인 확인을 위해서만 사용됩니다.',
                        value: _privacyTerms,
                        onChanged: (value) {
                          setState(() => _privacyTerms = value ?? false);
                        },
                        isRequired: true,
                      ),
                      _AgreementTile(
                        title: '학교 이메일 인증 및 소속 확인 동의',
                        description: '학교 이메일 인증을 통해 재학생 여부와 소속 학과를 확인합니다.',
                        value: _schoolVerificationTerms,
                        onChanged: (value) {
                          setState(
                            () => _schoolVerificationTerms = value ?? false,
                          );
                        },
                        isRequired: true,
                      ),
                      _AgreementTile(
                        title: '이벤트 및 혜택 안내 수신 동의',
                        description: '서비스 소식, 이벤트, 혜택 안내를 받을 수 있습니다.',
                        value: _marketingTerms,
                        onChanged: (value) {
                          setState(() => _marketingTerms = value ?? false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              CustomButton(
                buttonText: '다음',
                onActive: _allRequiredChecked,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signin1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgreementTile extends StatelessWidget {
  const _AgreementTile({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.isAllAgreement = false,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool isRequired;
  final bool isAllAgreement;

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: const Color(0xFF111111),
      fontSize: isAllAgreement ? 18 : 16,
      fontWeight: isAllAgreement ? FontWeight.w800 : FontWeight.w700,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFF0BAEFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: titleStyle,
                      children: [
                        TextSpan(text: title),
                        if (!isAllAgreement) ...[
                          TextSpan(
                            text: isRequired ? ' (필수)' : ' (선택)',
                            style: TextStyle(
                              color: isRequired
                                  ? const Color(0xFF0BAEFF)
                                  : const Color(0xFF8A8A8A),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
