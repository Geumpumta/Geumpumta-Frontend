import 'package:flutter/material.dart';
import 'package:geumpumta/screens/stats/widgets/contribution_grass.dart';

class WeeklyStatsView extends StatefulWidget {
  const WeeklyStatsView({super.key});

  @override
  State<WeeklyStatsView> createState() => _WeeklyStatsViewState();
}

class _WeeklyStatsViewState extends State<WeeklyStatsView> {
  DateTime _selectedWeekStart = DateTime(2025, 9, 16); // 9월 16일 기준으로 했는데 추후 현재 시간으로 변경해야함!

  String _getWeekRangeString(DateTime weekStart) {
    final month = weekStart.month;
    final year = weekStart.year;
    
    final firstDayOfMonth = DateTime(year, month, 1);

    int daysFromFirstMonday = 0;
    if (firstDayOfMonth.weekday != 1) {
      // 첫날이 월요일이 아닌 경우
      daysFromFirstMonday = 8 - firstDayOfMonth.weekday; // 다음 월요일까지
    }
    final firstMonday = firstDayOfMonth.add(Duration(days: daysFromFirstMonday));
    
    // 현재 주의 월요일이 첫 번째 월요일로부터 몇 주 후인지 계산
    final weeksDiff = weekStart.difference(firstMonday).inDays ~/ 7;
    final weekNumber = weeksDiff + 1;
    
    // 주차가 0 이하이면 이전 달의 마지막 주로 간주
    if (weekNumber <= 0) {
      return '$year년 $month월 1주';
    }
    
    return '$year년 $month월 ${weekNumber}주';
  }

  DateTime _getPreviousWeek(DateTime date) {
    // 해당 주의 월요일 찾기
    int daysFromMonday = date.weekday - 1;
    DateTime monday = date.subtract(Duration(days: daysFromMonday));
    // 이전 주 월요일
    return monday.subtract(const Duration(days: 7));
  }

  DateTime _getNextWeek(DateTime date) {
    // 해당 주의 월요일 찾기
    int daysFromMonday = date.weekday - 1;
    DateTime monday = date.subtract(Duration(days: daysFromMonday));
    // 다음 주 월요일
    return monday.add(const Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 주간 날짜 네비게이션
          _buildWeekNavigation(),
          const SizedBox(height: 16),
          
          // 주간 통계 카드
          _buildWeeklyStatsCard(),
          const SizedBox(height: 24),
          
          // 연속 공부 현황
          _buildContinuousStudySection(),
          const SizedBox(height: 24),
          
          // 하단 메시지
          _buildMotivationalMessage(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildWeekNavigation() {
    final weekStr = _getWeekRangeString(_selectedWeekStart);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedWeekStart = _getPreviousWeek(_selectedWeekStart);
              });
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            weekStr,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedWeekStart = _getNextWeek(_selectedWeekStart);
              });
            },
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildStatRow('주간 총 공부 시간', '16:00:14'),
          const SizedBox(height: 12),
          _buildStatRow('평균 공부 시간', '10:00:58'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF0BAEFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildContinuousStudySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '연속 공부 현황',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          const ContributionGrass(),
          const SizedBox(height: 16),
          const Center(
            child: Column(
              children: [
                Text(
                  '7일',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '연속 공부',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalMessage() {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Color(0xFF0BAEFF),
            size: 32,
          ),
          const SizedBox(height: 12),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
              children: [
                TextSpan(text: '이번 주 가장 열심히 한 날은 '),
                TextSpan(
                  text: '화요일',
                  style: TextStyle(
                    color: Color(0xFF0BAEFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' 입니다'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

