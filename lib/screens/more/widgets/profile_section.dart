import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/routes/app_routes.dart';
import 'package:geumpumta/viewmodel/user/user_viewmodel.dart';

class ProfileSection extends ConsumerWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);

    return userState.when(
      data: (user) => _ProfileSectionContent(
        nickname: user.nickName ?? '닉네임',
        department: user.department ?? '학과 정보 없음',
        profileImageUrl: user.profileImage,
      ),
      loading: () => const _ProfileSectionSkeleton(),
      error: (_, __) => const _ProfileSectionContent(
        nickname: '닉네임',
        department: '학과 정보 없음',
        profileImageUrl: null,
      ),
    );
  }
}

class _ProfileSectionContent extends StatelessWidget {
  const _ProfileSectionContent({
    required this.nickname,
    required this.department,
    this.profileImageUrl,
  });

  final String nickname;
  final String department;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0BAEFF).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFE6F7FF),
              shape: BoxShape.circle,
            ),
            child: profileImageUrl != null && profileImageUrl!.isNotEmpty
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
                  department.isEmpty ? '학과 정보 없음' : department,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Color(0xFF0BAEFF),
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profileEdit);
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

class _ProfileSectionSkeleton extends StatelessWidget {
  const _ProfileSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0BAEFF).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFE6F7FF),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: 120,
                  color: const Color(0xFFE6F7FF),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 80,
                  color: const Color(0xFFE6F7FF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

