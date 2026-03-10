import 'package:geumpumta/models/dto/badge/unnotified_badge_list_response_dto.dart';

class UnnotifiedBadge {
  UnnotifiedBadge({
    required this.code,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.awardedAt,
  });

  final String code;
  final String name;
  final String description;
  final String iconUrl;
  final DateTime? awardedAt;

  factory UnnotifiedBadge.fromDto(UnnotifiedBadgeDto dto) {
    return UnnotifiedBadge(
      code: dto.code,
      name: dto.name,
      description: dto.description,
      iconUrl: dto.iconUrl,
      awardedAt: dto.awardedAt == null || dto.awardedAt!.isEmpty
          ? null
          : DateTime.tryParse(dto.awardedAt!),
    );
  }
}
