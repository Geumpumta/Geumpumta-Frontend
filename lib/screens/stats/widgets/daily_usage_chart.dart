import 'package:flutter/material.dart';
import 'package:geumpumta/models/entity/stats/daily_statistics.dart';

class DailyUsageChart extends StatelessWidget {
  const DailyUsageChart({super.key, required this.slots});

  final List<DailySlot> slots;

  @override
  Widget build(BuildContext context) {
    final hours = List.generate(12, (index) => index * 2);
    final focusTimes = List<double>.filled(hours.length, 0);
    final wastedTimes = List<double>.filled(hours.length, 0);

    for (final slot in slots) {
      // 시작 시간에 맞춰 정확한 인덱스 계산
      final startHour = slot.start.hour;
      final endHour = slot.end.hour;
      
      // 시작 시간이 속한 2시간 구간 찾기
      final startIndex = (startHour ~/ 2).clamp(0, hours.length - 1);
      final endIndex = (endHour ~/ 2).clamp(0, hours.length - 1);
      
      // 같은 구간이면 해당 구간에 추가
      if (startIndex == endIndex) {
        focusTimes[startIndex] += slot.secondsStudied / 3600.0;
      } else {
        // 여러 구간에 걸쳐 있으면 시작 구간에 추가
        focusTimes[startIndex] += slot.secondsStudied / 3600.0;
      }
    }

    final maxHeight = 120.0;
    final rawMax = focusTimes.fold<double>(
      0,
      (prev, value) => value > prev ? value : prev,
    );
    double maxTime = rawMax < 0.5 ? 0.5 : rawMax;
    maxTime = (maxTime * 2).ceil() / 2; // round up to nearest 0.5h
    maxTime = maxTime.clamp(0.5, 6.0);

    // Y축 레이블을 0, 0.5h, 1h, 1.5h, 2h로 고정
    const divisions = 4;
    const fixedMaxTime = 2.0;
    final yLabels = List<double>.generate(
      divisions + 1,
      (index) => fixedMaxTime * (divisions - index) / divisions,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLegendItem(const Color(0xFF0BAEFF), '집중 시간'),
            const SizedBox(width: 16),
            _buildLegendItem(const Color(0xFF999999), '버린 시간'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: yLabels
                  .map(
                    (value) => SizedBox(
                      height: maxHeight / divisions,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _formatLabel(value),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(hours.length, (index) {
                  final focusTime = focusTimes[index];
                  final wastedTime = wastedTimes[index];
                  return _buildBar(
                    focusTime: focusTime,
                    wastedTime: wastedTime,
                    maxTime: fixedMaxTime,
                    maxHeight: maxHeight,
                  );
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: hours
              .map(
                (hour) => Text(
                  hour.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF999999),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  String _formatLabel(double value) {
    if (value == 0) return '0';
    final formatted =
        value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
    return '${formatted}h';
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildBar({
    required double focusTime,
    required double wastedTime,
    required double maxTime,
    required double maxHeight,
  }) {
    final focusHeight = (focusTime / maxTime) * maxHeight;
    final wastedHeight = (wastedTime / maxTime) * maxHeight;
    final totalHeight = focusHeight + wastedHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: totalHeight > 0 ? totalHeight : 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: totalHeight > 0
              ? Stack(
                  children: [
                    if (wastedHeight > 0)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: wastedHeight,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF999999),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    if (focusHeight > 0)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: focusHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF0BAEFF),
                            borderRadius: wastedHeight > 0
                                ? const BorderRadius.vertical(
                                    bottom: Radius.circular(4),
                                  )
                                : BorderRadius.circular(4),
                          ),
                        ),
                      ),
                  ],
                )
              : Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
        ),
      ],
    );
  }
}

