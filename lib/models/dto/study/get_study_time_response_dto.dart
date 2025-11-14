class StudyTimeData {
  final String totalStudySession;

  StudyTimeData({required this.totalStudySession});

  factory StudyTimeData.fromJson(Map<String, dynamic> json) =>
      StudyTimeData(totalStudySession: json['totalStudySession']);
}

class GetStudyTimeResponseDto {
  final bool success;
  final StudyTimeData data;

  GetStudyTimeResponseDto({required this.success, required this.data});

  factory GetStudyTimeResponseDto.fromJson(Map<String, dynamic> json) =>
      GetStudyTimeResponseDto(
        success: json['success'] == 'true' || json['success'] == true,
        data: StudyTimeData.fromJson(json['data']),
      );
}
