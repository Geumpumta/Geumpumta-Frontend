class EndStudyRequestDto {
  final int studySessionId;
  final DateTime endTime;

  EndStudyRequestDto({required this.studySessionId, required this.endTime});

  Map<String, dynamic> toJson() {
    return {
      "studySessionId": studySessionId.toString(),
      "endTime": endTime.toIso8601String(),
    };
  }
}
