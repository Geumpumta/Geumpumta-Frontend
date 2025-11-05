import 'package:flutter/material.dart';
import 'package:geumpumta/screens/stats/widgets/contribution_grass.dart';

class MonthlyStatsView extends StatefulWidget {
  const MonthlyStatsView({super.key});

  @override
  State<MonthlyStatsView> createState() => _MonthlyStatsViewState();
}

class _MonthlyStatsViewState extends State<MonthlyStatsView> {
  DateTime _selectedMonth = DateTime(2025, 9);

  String _getMonthString(DateTime date) {
    return '${date.year}년 ${date.month}월';
  }

  DateTime _getPreviousMonth(DateTime date) {
    if (date.month == 1) {
      return DateTime(date.year - 1, 12);
    }
    return DateTime(date.year, date.month - 1);
  }

  DateTime _getNextMonth(DateTime date) {
    if (date.month == 12) {
      return DateTime(date.year + 1, 1);
    }
    return DateTime(date.year, date.month + 1);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 월간 날짜 네비게이션
          _buildMonthNavigation(),
          const SizedBox(height: 16),
          
          // 월간 통계 카드
          _buildMonthlyStatsCard(),
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

  Widget _buildMonthNavigation() {
    final monthStr = _getMonthString(_selectedMonth);
    
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
                _selectedMonth = _getPreviousMonth(_selectedMonth);
              });
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            monthStr,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedMonth = _getNextMonth(_selectedMonth);
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

  Widget _buildMonthlyStatsCard() {
    // 해당 월 일수 계산
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final studyDays = 22; // 샘플 데이터고 추후 API 연동시 다시 
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildStatRow('월간 총 공부 시간', '16:00:14'),
          const SizedBox(height: 12),
          _buildStatRow('평균 공부 시간', '10:00:58'),
          const SizedBox(height: 12),
          _buildStatRow('이번 달 공부 일 수', '$studyDays / $daysInMonth'),
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
            Icons.emoji_events,
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
                TextSpan(text: '이번 달 가장 열심히 한 날은 '),
                TextSpan(
                  text: '16일',
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

