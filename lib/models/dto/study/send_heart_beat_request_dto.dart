class SendHeartBeatRequestDto {
  final int sessionId;
  final String ssid;
  final String bssid;

  SendHeartBeatRequestDto(
      {required this.sessionId, required this.ssid, required this.bssid});

  Map<String, dynamic> toJson() {
    return {
      "sessionId": sessionId.toString(),
      "ssid": ssid,
      "bssid": bssid,
    };
  }
}