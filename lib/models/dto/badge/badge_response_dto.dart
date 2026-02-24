class BadgeResponseDto {
  BadgeResponseDto({
    required this.success,
    this.data,
  });

  final bool success;
  final BadgeDto? data;

  factory BadgeResponseDto.fromJson(Map<String, dynamic> json) {
    return BadgeResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: json['data'] == null
          ? null
          : BadgeDto.fromJson(
              (json['data'] ?? const <String, dynamic>{}) as Map<String, dynamic>,
            ),
    );
  }
}

class BadgeDto {
  BadgeDto({
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
  final String? awardedAt;

  factory BadgeDto.fromJson(Map<String, dynamic> json) {
    return BadgeDto(
      code: (json['code'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      iconUrl: (json['iconUrl'] ?? json['iconUrl'] ?? '') as String,
      count: _parseInt(json['count']),
      owned: _parseBool(json['owned']),
      awardedAt: json['awardedAt'] as String?,
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == '1' || lower == 'y' || lower == 'yes';
    }
    return false;
  }
}

