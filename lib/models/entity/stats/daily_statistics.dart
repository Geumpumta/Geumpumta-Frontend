import 'package:geumpumta/models/dto/stats/daily_statistics_response_dto.dart';

class DailyStatistics {
  final List<DailySlot> slots;
  final int totalStudySeconds;
  final int maxFocusSeconds;

  DailyStatistics({
    required this.slots,
    required this.totalStudySeconds,
    required this.maxFocusSeconds,
  });

  factory DailyStatistics.fromDto(DailyStatisticsDataDto dto, DateTime date) {
    return DailyStatistics(
      slots: dto.statisticsList.map((e) => DailySlot.fromDto(e, date)).toList(),
      totalStudySeconds: dto.dayMaxFocusAndFullTimeStatistics.totalStudySeconds,
      maxFocusSeconds: dto.dayMaxFocusAndFullTimeStatistics.maxFocusSeconds,
    );
  }
}

class DailySlot {
  final DateTime start;
  final DateTime end;
  final int secondsStudied;

  DailySlot({
    required this.start,
    required this.end,
    required this.secondsStudied,
  });

  factory DailySlot.fromDto(DailySlotDto dto, DateTime date) {
    // slotStart와 slotEnd가 "HH:mm" 형식
    final partsStart = dto.slotStart.split(':');
    final partsEnd = dto.slotEnd.split(':');
    
    final startHour = int.parse(partsStart[0]);
    final startMin = int.parse(partsStart[1]);
    final endHour = int.parse(partsEnd[0]);
    final endMin = int.parse(partsEnd[1]);
    
    final start = DateTime(
      date.year,
      date.month,
      date.day,
      startHour,
      startMin,
    );
    
    // slotEnd가 "00:00"인 경우 다음 날로 처리 (예: 22:00~00:00)
    final end = endHour == 0 && endMin == 0
        ? DateTime(
            date.year,
            date.month,
            date.day + 1,
            endHour,
            endMin,
          )
        : DateTime(
            date.year,
            date.month,
            date.day,
            endHour,
            endMin,
          );

    return DailySlot(
      start: start,
      end: end,
      secondsStudied: dto.secondsStudied,
    );
  }
}


