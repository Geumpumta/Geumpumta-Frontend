class EndStudyRequestDto {
  final int studySessionId;

  EndStudyRequestDto({required this.studySessionId});

  Map<String, dynamic> toJson() {
    return {
      "studySessionId": studySessionId.toString(),
    };
  }
}
