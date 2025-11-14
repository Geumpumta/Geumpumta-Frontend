class StudyTimeData {
  final int studySessionId;

  StudyTimeData({required this.studySessionId});

  factory StudyTimeData.fromJson(Map<String, dynamic> json) {
    return StudyTimeData(
      studySessionId: json['studySessionId'] as int,
    );
  }
}

class StartStudyTimeResponseDto {
  final bool success;
  final StudyTimeData data;

  StartStudyTimeResponseDto({
    required this.success,
    required this.data,
  });

  factory StartStudyTimeResponseDto.fromJson(Map<String, dynamic> json) {
    return StartStudyTimeResponseDto(
      success: json['success'] == true || json['success'].toString() == 'true',
      data: StudyTimeData.fromJson(json['data']),
    );
  }
}
