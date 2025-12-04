class SendHeartBeatData {
  final bool sessionActive;
  final String message;

  SendHeartBeatData({required this.sessionActive, required this.message});

  factory SendHeartBeatData.fromJson(Map<String, dynamic> json) =>
      SendHeartBeatData(
        sessionActive:
            json['sessionActive'] == 'true' || json['sessionActive'] == true,
        message: json['message'],
      );
}

class SendHeartBeatResponseDto {
  final bool success;
  final SendHeartBeatData data;

  SendHeartBeatResponseDto({required this.success, required this.data});

  factory SendHeartBeatResponseDto.fromJson(Map<String, dynamic> json) =>
      SendHeartBeatResponseDto(
        success: json['success'] == 'true' || json['success'] == true,
        data: SendHeartBeatData.fromJson(json['data']),
      );
}
