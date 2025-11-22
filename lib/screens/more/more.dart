import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/screens/more/widgets/profile_section.dart';
import 'package:geumpumta/screens/more/widgets/notice_section.dart';
import 'package:geumpumta/screens/more/widgets/menu_section.dart';
import 'package:geumpumta/screens/more/widgets/logout_button.dart';
import 'package:geumpumta/routes/app_routes.dart';
import 'package:geumpumta/viewmodel/auth/auth_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 20,
        title: const Text(
          '더보기',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const ProfileSection(),
            const SizedBox(height: 32),
            const NoticeSection(),
            const SizedBox(height: 28),
            MenuSection(
              title: '서비스 이용',
              items: [
                MenuItemData(
                  title: '이벤트',
                  onTap: () => _navigateToPlaceholder(context, '이벤트'),
                ),
                MenuItemData(
                  title: '고객센터',
                  onTap: () => _navigateToPlaceholder(context, '고객센터'),
                ),
              ],
            ),
            const SizedBox(height: 28),
            MenuSection(
              title: '약관 및 정책',
              items: [
                MenuItemData(
                  title: '개인정보 처리방침',
                  onTap: () => _navigateToPlaceholder(context, '개인정보 처리방침'),
                ),
                MenuItemData(
                  title: '이용약관',
                  onTap: () => _navigateToPlaceholder(context, '이용약관'),
                ),
              ],
            ),
            const SizedBox(height: 28),
            MenuSection(
              title: '계정 관리',
              items: [
                MenuItemData(
                  title: '회원 탈퇴',
                  textColor: const Color(0xFFFF3B30),
                  iconColor: const Color(0xFFFF3B30),
                  onTap: () => _showDeleteAccountDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 40),
            LogoutButton(
              onPressed: () => _showLogoutDialog(context, ref),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _navigateToPlaceholder(BuildContext context, String title) {
    Navigator.pushNamed(
      context,
      AppRoutes.placeholder,
      arguments: {'title': title},
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(authViewModelProvider.notifier);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '로그아웃',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '정말 로그아웃 하시겠습니까?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await viewModel.logout(context);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('로그아웃되었습니다.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('로그아웃 중 오류가 발생했습니다: $e'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: const Text(
                '로그아웃',
                style: TextStyle(
                  color: Color(0xFF0BAEFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(authViewModelProvider.notifier);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '회원 탈퇴',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF3B30),
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '정말 회원탈퇴를 하시겠습니까?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        '최종 확인',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF3B30),
                        ),
                      ),
                      content: const Text(
                        '정말로 탈퇴하시겠습니까?\n이 작업은 되돌릴 수 없습니다.',
                        style: TextStyle(fontSize: 16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            '탈퇴하기',
                            style: TextStyle(
                              color: Color(0xFFFF3B30),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirmed == true) {
                  try {
                    final prefs = await SharedPreferences.getInstance();
                    final accessToken = prefs.getString('accessToken')??'';
                    await viewModel.deleteAccount(accessToken);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('회원탈퇴가 완료되었습니다.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('회원탈퇴 중 오류가 발생했습니다: $e'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text(
                '탈퇴하기',
                style: TextStyle(
                  color: Color(0xFFFF3B30),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

