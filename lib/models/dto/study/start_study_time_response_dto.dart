class StudyTimeData {
  final int studySessionId;

  StudyTimeData({required this.studySessionId});

  factory StudyTimeData.fromJson(Map<String, dynamic> json) {
    return StudyTimeData(studySessionId: json['studySessionId'] as int);
  }
}

class StartStudyTimeResponseDto {
  final bool success;
  final StudyTimeData? data;
  final String? code;
  final String? message;

  StartStudyTimeResponseDto({
    required this.success,
    required this.data,
    this.code,
    this.message,
  });

  factory StartStudyTimeResponseDto.fromJson(Map<String, dynamic> json) {
    return StartStudyTimeResponseDto(
      success: json['success'] == true || json['success'].toString() == 'true',
      data: json['data'] != null
          ? StudyTimeData.fromJson(json['data'])
          : StudyTimeData(studySessionId: -1),
      code: json['code'],
      message: json['msg'],
    );
  }
}
