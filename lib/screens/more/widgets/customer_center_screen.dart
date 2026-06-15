import 'package:flutter/material.dart';
import 'package:geumpumta/widgets/back_and_title/back_and_title.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCenterScreen extends StatefulWidget {
  const CustomerCenterScreen({super.key});

  @override
  State<CustomerCenterScreen> createState() => _CustomerCenterScreenState();
}

class _CustomerCenterScreenState extends State<CustomerCenterScreen> {
  int? _expandedIndex;

  static const _faqItems = [
    _FaqItem(
      question: '앱을 탈퇴하면 데이터는 어떻게 되나요?',
      answer:
          '회원 탈퇴 시 공부 기록, 랭킹 정보, 프로필 등 모든 데이터가 즉시 삭제되며 복구가 불가능합니다. '
          '탈퇴 전에 필요한 데이터를 미리 백업해 두시기 바랍니다.',
    ),
    _FaqItem(
      question: '스터디 타이머가 정확히 작동하지 않아요.',
      answer:
          '배경 앱 새로 고침을 허용하고, 배터리 절약 모드를 해제해 보세요. '
          '앱을 완전히 종료 후 다시 실행하면 정상 작동하는 경우가 많습니다. '
          '문제가 지속되면 아래 문의하기를 통해 알려주세요.',
    ),
    _FaqItem(
      question: '랭킹은 어떻게 계산되나요?',
      answer:
          '랭킹은 해당 기간(일/주/월)의 총 공부 시간을 기준으로 계산됩니다. '
          '동점자의 경우 먼저 등록된 순서로 정렬됩니다.',
    ),
    _FaqItem(
      question: '배지는 어떻게 획득하나요?',
      answer:
          '다양한 조건을 달성하면 배지를 획득할 수 있습니다. 예를 들어 첫 공부 완료, '
          '연속 출석 달성, 누적 공부 시간 달성 등이 있습니다. '
          '더보기 → 활동 배지에서 모든 배지 목록을 확인하세요.',
    ),
    _FaqItem(
      question: '알림이 오지 않아요.',
      answer:
          '기기의 설정 → 알림에서 금품타 앱의 알림 권한이 허용되어 있는지 확인해 주세요. '
          '앱 내 알림 설정도 함께 확인해 주시기 바랍니다.',
    ),
    _FaqItem(
      question: '친구와 같은 그룹에서 경쟁하려면 어떻게 하나요?',
      answer:
          '회원가입 시 선택한 학과/부서 기준으로 그룹이 자동으로 구성됩니다. '
          '그룹 변경은 프로필 수정에서 가능합니다.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BackAndTitle(title: '고객센터'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactBanner(),
                    const SizedBox(height: 28),
                    _buildSectionLabel('자주 묻는 질문'),
                    const SizedBox(height: 12),
                    ..._faqItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return _buildFaqItem(
                        index: index,
                        item: item,
                        isExpanded: _expandedIndex == index,
                        onTap: () {
                          setState(() {
                            _expandedIndex =
                                _expandedIndex == index ? null : index;
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 28),
                    _buildSectionLabel('문의하기'),
                    const SizedBox(height: 12),
                    _buildContactCard(
                      icon: Icons.email_outlined,
                      title: '이메일 문의',
                      subtitle: 'totoro7378@naver.com',
                      onTap: () => _launchUrl(
                        context,
                        'mailto:totoro7378@naver.com',
                      ),
                    ),
                    _buildContactCard(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: '카카오톡 오픈채팅',
                      subtitle: '금품타 문의방',
                      onTap: () => _launchUrl(
                        context,
                        'https://open.kakao.com/o/sqASLdzi',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F8FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: Color(0xFF0BAEFF),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '운영 시간: 평일 오전 10시 ~ 오후 6시\n주말 및 공휴일은 답변이 지연될 수 있습니다.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0BAEFF), Color(0xFF0071FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '무엇을 도와드릴까요?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '아래 FAQ를 확인하거나\n직접 문의해 주세요.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.headset_mic_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required int index,
    required _FaqItem item,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? const Color(0xFF0BAEFF) : const Color(0xFFEFEFEF),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? const Color(0xFF0BAEFF)
                          : const Color(0xFFEFEFEF),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      'Q',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isExpanded ? Colors.white : const Color(0xFF999999),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.question,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isExpanded
                            ? const Color(0xFF0BAEFF)
                            : const Color(0xFF333333),
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: isExpanded
                        ? const Color(0xFF0BAEFF)
                        : const Color(0xFFCCCCCC),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F7FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      'A',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0BAEFF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.answer,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF555555),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEFEFEF)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF0BAEFF), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.open_in_new_rounded,
              color: Color(0xFFCCCCCC),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('링크를 열 수 없습니다.'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: const Color(0xFF333333),
          ),
        );
      }
    }
  }
}

class _FaqItem {
  const _FaqItem({required this.question, required this.answer});
  final String question;
  final String answer;
}
