class StartStudyTimeRequestDto {
  final DateTime startTime;
  final String gatewayIp;
  final String clientIp;

  StartStudyTimeRequestDto({
    required this.startTime,
    required this.gatewayIp,
    required this.clientIp,
  });

  Map<String, dynamic> toJson() {
    return {
      "startTime": startTime.toIso8601String(),
      "gatewayIp": gatewayIp,
      "clientIp":clientIp,
    };
  }
}
