import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/screens/ranking/ranking.dart';
import 'package:geumpumta/screens/stats/widgets/build_motivation_content_with_highlight.dart';
import 'package:geumpumta/screens/stats/widgets/continuous_study_section.dart';
import 'package:geumpumta/screens/stats/widgets/usage_time_chart_section.dart';
import 'package:geumpumta/screens/stats/widgets/make_motivation_highlight_text.dart';
import '../../../viewmodel/stats/daily_stats_viewmodel.dart';
import '../../../viewmodel/stats/grass_stats_viewmodel.dart';

class DetailsInModal extends ConsumerStatefulWidget {
  const DetailsInModal({
    super.key,
    required this.nickname,
    required this.recordedTime,
    required this.imageUrl,
    this.targetUserId,
    this.periodOption = PeriodOption.daily,
    required this.selectedDate,
  });

  final String nickname;
  final Duration recordedTime;
  final String imageUrl;
  final int? targetUserId;
  final PeriodOption? periodOption;
  final DateTime selectedDate;

  @override
  ConsumerState<DetailsInModal> createState() => _DetailsInModalState();
}

class _DetailsInModalState extends ConsumerState<DetailsInModal> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDailyStats();
      ref.refresh(currentStreakProvider(null));
    });
  }

  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  void _fetchDailyStats() {
    final formatted = _formatDateForApi(widget.selectedDate);
    ref
        .read(dailyStatsViewModelProvider.notifier)
        .loadDailyStatistics(date: formatted);
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(widget.recordedTime.inHours);
    final minutes = twoDigits(widget.recordedTime.inMinutes.remainder(60));
    final seconds = twoDigits(widget.recordedTime.inSeconds.remainder(60));
    final formattedDuration = '$hours:$minutes:$seconds';

    Widget _buildBottomWidget() {
      if (widget.periodOption == PeriodOption.daily) {
        return UsageTimeChartSection(
          title: '사용 시간 그래프',
          targetUserId: widget.targetUserId,
        );
      }

      return MakeMotivationHighlightText(
        targetUserId: widget.targetUserId,
        periodOption: widget.periodOption!,
        selectedDate: widget.selectedDate,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                spacing: 10,
                children: [
                  ClipOval(
                    child: Image.network(
                      widget.imageUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Image.asset(
                          'assets/image/login/main_img.png',
                          width: 40,
                          height: 40,
                        );
                      },
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 3,
                    children: [
                      Text(
                        widget.nickname,
                        style: const TextStyle(
                          color: Color(0xFF898989),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        formattedDuration,
                        style: const TextStyle(
                          color: Color(0xFF0BAEFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF8F9F9),
                ),
                child: const Text(
                  '상대 순위 보기',
                  style: TextStyle(color: Color(0xFF898989)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          ContinuousStudySection(targetUserId: widget.targetUserId),

          const SizedBox(height: 30),

          _buildBottomWidget(),
        ],
      ),
    );
  }
}
