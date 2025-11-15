class StartStudyTimeRequestDto {
  final DateTime startTime;
  final String gatewayIp;
  final String bssid;

  StartStudyTimeRequestDto({
    required this.startTime,
    required this.gatewayIp,
    required this.bssid,
  });

  Map<String, dynamic> toJson() {
    return {
      "startTime": startTime.toIso8601String(),
      "ssid": gatewayIp,
      "bssid": bssid,
    };
  }
}
