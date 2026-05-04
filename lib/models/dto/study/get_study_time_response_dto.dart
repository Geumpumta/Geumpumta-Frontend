class StudyTimeData {
  final int totalStudySession;
  final bool isStudying;
  final DateTime? startTime;

  StudyTimeData({
    required this.totalStudySession,
    required this.isStudying,
    required this.startTime,
  });

  factory StudyTimeData.fromJson(Map<String, dynamic> json) => StudyTimeData(
    totalStudySession: json['totalStudySession'] as int,
    isStudying: _parseBool(json['isStudying']),
    startTime: _parseDateTime(json['startTime']),
  );

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}

class GetStudyTimeResponseDto {
  final bool success;
  final StudyTimeData data;
  final String? message;

  GetStudyTimeResponseDto({
    required this.success,
    required this.data,
    this.message,
  });

  factory GetStudyTimeResponseDto.fromJson(Map<String, dynamic> json) =>
      GetStudyTimeResponseDto(
        success: json['success'] == 'true' || json['success'] == true,
        data: StudyTimeData.fromJson(json['data']),
        message: json['message'] as String?,
      );
}
