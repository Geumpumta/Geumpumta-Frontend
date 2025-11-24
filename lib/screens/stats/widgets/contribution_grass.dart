import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/entity/stats/grass_statistics.dart';
import 'package:geumpumta/viewmodel/stats/grass_stats_viewmodel.dart';

class ContributionGrass extends ConsumerStatefulWidget {
  const ContributionGrass({super.key, this.targetUserId});

  final int? targetUserId;

  @override
  ConsumerState<ContributionGrass> createState() => _ContributionGrassState();
}

class _ContributionGrassState extends ConsumerState<ContributionGrass> {
  DateTime _currentMonth = DateTime.now();

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchGrass());
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    _fetchGrass();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    _fetchGrass();
  }

  void _fetchGrass() {
    final formatted = _formatDateForApi(_currentMonth);
    ref
        .read(grassStatsViewModelProvider.notifier)
        .loadGrassStatistics(
          date: formatted,
          targetUserId: widget.targetUserId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final grassState = ref.watch(grassStatsViewModelProvider);

    final monthName = _monthNames[_currentMonth.month - 1];
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfWeek =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;

    final totalCells = 5 * 7;
    final startOffset = firstDayOfWeek - 1;

    final Map<int, int> levelByDay = {};
    grassState.whenOrNull(
      data: (GrassStatistics stats) {
        for (final entry in stats.entries) {
          if (entry.date.year == _currentMonth.year &&
              entry.date.month == _currentMonth.month) {
            levelByDay[entry.date.day] = entry.level;
          }
        }
      },
    );

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
              if (index < startOffset || index >= startOffset + daysInMonth) {
                return Container();
              }
              final day = index - startOffset + 1;
              final level = levelByDay[day] ?? 0;
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
        dotColor = const Color(0xFFEBEDF0);
        break;
      case 1:
        dotColor = const Color(0xFFE3F2FD);
        break;
      case 2:
        dotColor = const Color(0xFF90CAF9);
        break;
      case 3:
        dotColor = const Color(0xFF42A5F5);
        break;
      case 4:
      default:
        dotColor = const Color(0xFF0BAEFF);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: dotColor,
        borderRadius: BorderRadius.zero,
      ),
    );
  }

  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month-01';
  }
}

