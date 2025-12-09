import 'package:flutter/material.dart';
import 'package:geumpumta/models/entity/stats/daily_statistics.dart';

class DailyUsageChart extends StatelessWidget {
  const DailyUsageChart({super.key, required this.slots});

  final List<DailySlot> slots;

  @override
  Widget build(BuildContext context) {
    final hours = List.generate(12, (index) => index * 2);
    final focusTimes = List<double>.filled(hours.length, 0);

    // 각 slot이 어떤 구간에 걸치는지 계산하고 집중 시간 분배
    for (final slot in slots) {
      final slotStart = slot.start;
      final slotEnd = slot.end;
      
      // slotEnd가 다음 날로 넘어간 경우 24시로 처리
      final isNextDay = slotEnd.day > slotStart.day;
      final endHour = isNextDay ? 24 : slotEnd.hour;
      final startHour = slotStart.hour;
      final startMinute = slotStart.minute;
      final endMinute = isNextDay ? 0 : slotEnd.minute;
      
      // slot의 총 시간(시간 단위)
      final slotStartDecimal = startHour + startMinute / 60.0;
      final slotEndDecimal = endHour + endMinute / 60.0;
      final slotTotalHours = slotEndDecimal - slotStartDecimal;
      
      // slot의 집중 시간(시간 단위)
      final focusHours = slot.secondsStudied / 3600.0;
      
      // slot이 걸치는 모든 2시간 구간 찾기
      final startIntervalIndex = (startHour ~/ 2).clamp(0, hours.length - 1);
      final endIntervalIndex = ((endHour - 1) ~/ 2).clamp(0, hours.length - 1);
      
      // 각 구간에 걸친 시간과 집중 시간 계산
      for (int i = startIntervalIndex; i <= endIntervalIndex; i++) {
        final intervalStart = hours[i].toDouble();
        final intervalEnd = (hours[i] + 2).toDouble();
        
        // slot과 구간의 겹치는 부분 계산
        final overlapStart = slotStartDecimal > intervalStart ? slotStartDecimal : intervalStart;
        final overlapEnd = slotEndDecimal < intervalEnd ? slotEndDecimal : intervalEnd;
        final overlapHours = (overlapEnd - overlapStart).clamp(0.0, 2.0);
        
        if (overlapHours > 0 && slotTotalHours > 0) {
          // 겹치는 시간에 비례하여 집중 시간 분배
          final focusRatio = overlapHours / slotTotalHours;
          final allocatedFocus = focusHours * focusRatio;
          focusTimes[i] += allocatedFocus;
        }
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
                  return _buildBar(
                    focusTime: focusTime,
                    wastedTime: 0,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: focusHeight > 0 ? focusHeight : 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: focusHeight > 0
              ? Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0BAEFF),
                    borderRadius: BorderRadius.circular(4),
                  ),
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

