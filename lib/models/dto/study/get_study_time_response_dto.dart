class StudyTimeData {
  final int totalStudySession;

  StudyTimeData({required this.totalStudySession});

  factory StudyTimeData.fromJson(Map<String, dynamic> json) =>
      StudyTimeData(totalStudySession: json['totalStudySession'] as int);
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
