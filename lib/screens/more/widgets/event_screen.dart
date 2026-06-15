import 'package:flutter/material.dart';
import 'package:geumpumta/widgets/back_and_title/back_and_title.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int? _expandedIndex;

  static const _events = [
    _EventItem(
      title: '시험기간 이벤트',
      description:
          '공부 시간 랭킹 TOP 8에게 상품권을 드려요!\n'
          '🥇 1등 — 배달의민족 상품권 5만원\n'
          '🥈 2등 — 키보드\n'
          '🥉 3~5등 — 스타벅스 상품권 1만원\n'
          '🎖 6~8등 — 할리스 상품권 5천원\n\n'
          '※ 교내 kumoh-wifi 연결 상태에서만 참여 가능합니다.\n'
          '※ 부정행위 적발 시 이벤트 대상에서 제외됩니다.',
      period: '6월 12일(금) ~ 6월 23일(화) 자정까지',
      status: _EventStatus.ongoing,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ongoingEvents =
        _events.where((e) => e.status == _EventStatus.ongoing).toList();
    final upcomingEvents =
        _events.where((e) => e.status == _EventStatus.upcoming).toList();
    final endedEvents =
        _events.where((e) => e.status == _EventStatus.ended).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BackAndTitle(title: '이벤트'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBanner(),
                    const SizedBox(height: 24),
                    _buildSection('진행 중인 이벤트', ongoingEvents),
                    const SizedBox(height: 24),
                    _buildSection('예정된 이벤트', upcomingEvents),
                    const SizedBox(height: 24),
                    _buildSection('종료된 이벤트', endedEvents),
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

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF0BAEFF), Color(0xFF0071FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 10,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '금품타 이벤트',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '다양한 이벤트에 참여하고\n특별한 혜택을 받아보세요!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String label, List<_EventItem> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (events.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEFEFEF)),
            ),
            child: const Center(
              child: Text(
                '해당 이벤트가 없습니다.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFBBBBBB),
                ),
              ),
            ),
          )
        else
          ...events.map((event) {
            final globalIndex = _events.indexOf(event);
            final isExpanded = _expandedIndex == globalIndex;
            return _buildAccordionCard(
              event: event,
              isExpanded: isExpanded,
              onTap: () {
                setState(() {
                  _expandedIndex = isExpanded ? null : globalIndex;
                });
              },
            );
          }),
      ],
    );
  }

  Widget _buildAccordionCard({
    required _EventItem event,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    final isEnded = event.status == _EventStatus.ended;
    final badgeColor = switch (event.status) {
      _EventStatus.ongoing => const Color(0xFF0BAEFF),
      _EventStatus.upcoming => const Color(0xFFFF9500),
      _EventStatus.ended => const Color(0xFF999999),
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: isEnded ? const Color(0xFFF8F8F8) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? badgeColor.withOpacity(0.4) : const Color(0xFFEFEFEF),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      event.status.label,
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isEnded
                            ? const Color(0xFF999999)
                            : const Color(0xFF333333),
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: isExpanded ? badgeColor : const Color(0xFFCCCCCC),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFFEFEFEF), height: 1),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isEnded
                          ? const Color(0xFFAAAAAA)
                          : const Color(0xFF555555),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: isEnded
                            ? const Color(0xFFCCCCCC)
                            : const Color(0xFF999999),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.period,
                        style: TextStyle(
                          fontSize: 11,
                          color: isEnded
                              ? const Color(0xFFCCCCCC)
                              : const Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _EventItem {
  const _EventItem({
    required this.title,
    required this.description,
    required this.period,
    required this.status,
  });

  final String title;
  final String description;
  final String period;
  final _EventStatus status;
}

enum _EventStatus {
  ongoing('진행중'),
  upcoming('예정'),
  ended('종료');

  const _EventStatus(this.label);
  final String label;
}
