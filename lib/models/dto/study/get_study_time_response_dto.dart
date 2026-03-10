class StudyTimeData {
  final int totalStudySession;
  final bool isStudying;

  StudyTimeData({required this.totalStudySession, required this.isStudying});

  factory StudyTimeData.fromJson(Map<String, dynamic> json) => StudyTimeData(
    totalStudySession: json['totalStudySession'] as int,
    isStudying: _parseBool(json['isStudying']),
  );

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
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
