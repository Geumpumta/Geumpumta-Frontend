class SendHeartBeatRequestDto {
  final int sessionId;
  final String gatewayIp;
  final String clientIp;

  SendHeartBeatRequestDto(
      {required this.sessionId, required this.gatewayIp, required this.clientIp});

  Map<String, dynamic> toJson() {
    return {
      "sessionId": sessionId.toString(),
      "gatewayIp": gatewayIp,
      "clientIp": clientIp,
    };
  }
}