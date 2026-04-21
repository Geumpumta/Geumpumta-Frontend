import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/department.dart';
import 'package:geumpumta/provider/userState/user_info_state.dart';
import 'package:geumpumta/routes/app_routes.dart';
import 'package:geumpumta/widgets/text_header/text_header.dart';

class ProfilePageScreen extends ConsumerWidget {
  const ProfilePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoStateProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final nickname = user.nickName ?? '닉네임';
    final department = user.department.koreanName ?? '학과 정보 없음';
    final profileImageUrl = user.profileImage;
    final studentId = user.studentId;
    final email = user.email;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const TextHeader(text: '프로필'),
                Positioned(
                  left: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF0F0F0),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: profileImageUrl != null &&
                                        profileImageUrl.isNotEmpty
                                    ? ClipOval(
                                        child: Image.network(
                                          profileImageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              ProfilePageScreen._buildDefaultIcon(),
                                        ),
                                      )
                                    : ProfilePageScreen._buildDefaultIcon(),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nickname,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _buildSubtitle(studentId, department),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF999999),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _ProfileInfoRow(
                                      icon: Icons.calendar_today_outlined,
                                      text: '학과 · $department',
                                    ),
                                    if (email != null && email.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      _ProfileInfoRow(
                                        icon: Icons.mail_outline,
                                        text: email,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                AppRoutes.profileEdit,
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFF0F0F0),
                                foregroundColor: const Color(0xFF333333),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('프로필 수정'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ActivityBadgeEntry(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _buildSubtitle(String? studentId, String department) {
    final parts = <String>[];
    if (studentId != null && studentId.isNotEmpty) {
      parts.add('#$studentId');
    }
    parts.add(department);
    return parts.join(' · ');
  }

  static Widget _buildDefaultIcon() {
    return const Icon(
      Icons.person,
      color: Color(0xFF0BAEFF),
      size: 36,
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
    required this.icon,
    required this.text,
    this.subText,
    this.isLink = false,
  });

  final IconData icon;
  final String text;
  final String? subText;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF999999)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isLink
                      ? const Color(0xFF0BAEFF)
                      : const Color(0xFF333333),
                  decoration: isLink ? TextDecoration.underline : null,
                ),
              ),
              if (subText != null) ...[
                const SizedBox(height: 2),
                Text(
                  subText!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityBadgeEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.activityBadge),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '활동 배지',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF0BAEFF),
            ),
          ],
        ),
      ),
    );
  }
}
