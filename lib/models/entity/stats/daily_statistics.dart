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

  factory DailyStatistics.fromDto(DailyStatisticsDataDto dto) {
    return DailyStatistics(
      slots: dto.statisticsList.map((e) => DailySlot.fromDto(e)).toList(),
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

  factory DailySlot.fromDto(DailySlotDto dto) {
    DateTime parse(String value) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime(1970, 1, 1);
      }
    }

    return DailySlot(
      start: parse(dto.slotStart),
      end: parse(dto.slotEnd),
      secondsStudied: dto.secondsStudied,
    );
  }
}


