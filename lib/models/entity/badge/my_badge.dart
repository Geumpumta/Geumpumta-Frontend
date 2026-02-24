import 'package:geumpumta/models/dto/badge/badge_response_dto.dart';

class MyBadge {
  MyBadge({
    required this.code,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.count,
    required this.owned,
    required this.awardedAt,
  });

  final String code;
  final String name;
  final String description;
  final String iconUrl;
  final int count;
  final bool owned;
  final DateTime? awardedAt;

  factory MyBadge.fromDto(BadgeDto dto) {
    return MyBadge(
      code: dto.code,
      name: dto.name,
      description: dto.description,
      iconUrl: dto.iconUrl,
      count: dto.count,
      owned: dto.owned,
      awardedAt: dto.awardedAt == null || dto.awardedAt!.isEmpty
          ? null
          : DateTime.tryParse(dto.awardedAt!),
    );
  }
}

