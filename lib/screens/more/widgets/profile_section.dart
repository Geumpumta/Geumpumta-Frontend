import 'package:flutter/material.dart';
import 'package:geumpumta/routes/app_routes.dart';

/// 프로필 섹션 위젯
/// 더보기 페이지의 프로필 정보를 표시하는 위젯
class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    this.nickname = '닉네임임임임당당',
    this.department = '컴퓨터공학과',
    this.profileImageUrl,
  });

  final String nickname;
  final String department;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0BAEFF).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 프로필 이미지
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7FF),
              shape: BoxShape.circle,
            ),
            child: profileImageUrl != null
                ? ClipOval(
                    child: Image.network(
                      profileImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildDefaultIcon(),
                    ),
                  )
                : _buildDefaultIcon(),
          ),
          const SizedBox(width: 18),
          // 닉네임 및 학과
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
                  department,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          // 편집 아이콘
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Color(0xFF0BAEFF),
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.profileEdit,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return const Icon(
      Icons.person,
      color: Color(0xFF0BAEFF),
      size: 32,
    );
  }
}

