class StartStudyTimeRequestDto {
  final DateTime startTime;
  final String ssid;
  final String bssid;

  StartStudyTimeRequestDto({
    required this.startTime,
    required this.ssid,
    required this.bssid,
  });

  Map<String, dynamic> toJson() {
    return {
      "startTime": startTime.toIso8601String(),
      "ssid": ssid,
      "bssid": bssid,
    };
  }
}
