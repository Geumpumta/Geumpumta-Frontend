import 'package:flutter/material.dart';
import 'dart:math';

class ContributionGrass extends StatefulWidget {
  const ContributionGrass({super.key});

  @override
  State<ContributionGrass> createState() => _ContributionGrassState();
}

class _ContributionGrassState extends State<ContributionGrass> {
  DateTime _currentMonth = DateTime.now();
  final Random _random = Random(42);

  final List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _monthNames[_currentMonth.month - 1];
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfWeek = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    
    final totalCells = 5 * 7; // 35개 셀
    final startOffset = firstDayOfWeek - 1; // 월요일이 1이므로 -1

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _previousMonth,
              child: const Icon(
                Icons.chevron_left,
                size: 20,
                color: Color(0xFF999999),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              monthName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: _nextMonth,
              child: const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 캘린더 그리드
        SizedBox(
          width: 7 * (12.0 + 4),
          height: 5 * (12.0 + 4), 
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              // 빈 셀 처리 (다음 월 시작 전이나 이전 월 끝났을 때)
              if (index < startOffset || index >= startOffset + daysInMonth) {
                return Container();
              }
              final dayIndex = index - startOffset;
              final dateSeed = _currentMonth.year * 10000 + _currentMonth.month * 100 + dayIndex;
              final level = Random(dateSeed).nextInt(5); 
              
              return _buildGrassDot(level);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGrassDot(int level) {
    Color dotColor;
    
    switch (level) {
      case 0:
        dotColor = const Color(0xFFEBEDF0); // 회색 (활동 없음)
        break;
      case 1:
        dotColor = const Color(0xFFE3F2FD); // 매우 연한 파란색
        break;
      case 2:
        dotColor = const Color(0xFF90CAF9); // 연한 파란색
        break;
      case 3:
        dotColor = const Color(0xFF42A5F5); // 중간 파란색
        break;
      case 4:
      default:
        dotColor = const Color(0xFF0BAEFF); // 가장 진한색
        break;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: dotColor,
        borderRadius: BorderRadius.zero,
      ),
    );
  }
}

