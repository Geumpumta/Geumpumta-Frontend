class StartStudyTimeRequestDto {
  final String gatewayIp;
  final String clientIp;

  StartStudyTimeRequestDto({
    required this.gatewayIp,
    required this.clientIp,
  });

  Map<String, dynamic> toJson() {
    return {
      "gatewayIp": gatewayIp,
      "clientIp":clientIp,
    };
  }
}
