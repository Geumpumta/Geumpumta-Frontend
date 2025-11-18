import 'package:geumpumta/models/dto/stats/grass_statistics_response_dto.dart';

class GrassStatistics {
  final List<GrassEntry> entries;

  GrassStatistics({required this.entries});

  factory GrassStatistics.fromDto(GrassStatisticsDataDto dto) {
    return GrassStatistics(
      entries: dto.grassStatistics.map((e) => GrassEntry.fromDto(e)).toList(),
    );
  }
}

class GrassEntry {
  final DateTime date;
  final int level;

  GrassEntry({
    required this.date,
    required this.level,
  });

  factory GrassEntry.fromDto(GrassStatisticItemDto dto) {
    DateTime parsed;
    try {
      parsed = DateTime.parse(dto.date);
    } catch (_) {
      parsed = DateTime(1970, 1, 1);
    }
    return GrassEntry(
      date: parsed,
      level: dto.level,
    );
  }
}


