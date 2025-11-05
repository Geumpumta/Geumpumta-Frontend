import 'package:flutter/material.dart';

class DailyUsageChart extends StatelessWidget {
  const DailyUsageChart({super.key});

  @override
  Widget build(BuildContext context) {
    // 시간별 데이터 (2시간 간격, 0-24시)
    final hours = List.generate(12, (index) => index * 2);
    
    // 샘플 데이터: 각 2시간 구간별 집중 시간과 버린 시간 (시간 단위)
    final focusTimes = [0.0, 0.0, 0.0, 0.5, 1.0, 1.5, 2.0, 1.5, 1.0, 0.5, 0.0, 0.0];
    final wastedTimes = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.5, 0.0, 0.0, 0.0];
    
    final maxHeight = 120.0;
    final maxTime = 2.5; // 최대 2.5시간
    
    return Column(
      children: [
        // 범례
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLegendItem(const Color(0xFF0BAEFF), '집중 시간'),
            const SizedBox(width: 16),
            _buildLegendItem(const Color(0xFF999999), '버린 시간'),
          ],
        ),
        const SizedBox(height: 16),
        // Y축 레이블 및 그래프
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Y축 레이블
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: ['2h', '1.5h', '1h', '0.5h', '0']
                .reversed
                .map((label) => SizedBox(
                  height: maxHeight / 4,
                  child: Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
                ))
                .toList(),
            ),
            const SizedBox(width: 8),
            // 바 차트
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
                    maxTime: maxTime,
                    maxHeight: maxHeight,
                    hour: hours[index],
                  );
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // X축 레이블
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: hours.map((hour) => Text(
            hour.toString(),
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF999999),
            ),
          )).toList(),
        ),
      ],
    );
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
    required int hour,
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
                    // 버린 시간 (상단, 회색)
                    if (wastedHeight > 0)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: wastedHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF999999),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    // 집중 시간 (하단, 파란색)
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

