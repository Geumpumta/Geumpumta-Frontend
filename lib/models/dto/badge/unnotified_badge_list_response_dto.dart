class UnnotifiedBadgeListResponseDto {
  UnnotifiedBadgeListResponseDto({required this.success, required this.data});

  final bool success;
  final List<UnnotifiedBadgeDto> data;

  factory UnnotifiedBadgeListResponseDto.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    final List<UnnotifiedBadgeDto> badges;

    if (rawData is List) {
      badges = rawData
          .whereType<Map<String, dynamic>>()
          .map(UnnotifiedBadgeDto.fromJson)
          .toList();
    } else if (rawData is Map<String, dynamic>) {
      badges = [UnnotifiedBadgeDto.fromJson(rawData)];
    } else {
      badges = const <UnnotifiedBadgeDto>[];
    }

    return UnnotifiedBadgeListResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: badges,
    );
  }
}

class UnnotifiedBadgeDto {
  UnnotifiedBadgeDto({
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
  final String? awardedAt;

  factory UnnotifiedBadgeDto.fromJson(Map<String, dynamic> json) {
    return UnnotifiedBadgeDto(
      code: (json['code'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      iconUrl: (json['iconUrl'] ?? '') as String,
      awardedAt: json['awardedAt'] as String?,
    );
  }
}
