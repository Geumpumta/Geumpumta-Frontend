class SendHeartBeatResponseDto {
  final bool success;
  final String? data;
  final String? message;

  SendHeartBeatResponseDto({required this.success, this.data, this.message});

  factory SendHeartBeatResponseDto.fromJson(Map<String, dynamic> json) =>
      SendHeartBeatResponseDto(
        success: json['success'] == 'true' || json['success'] == true,
        data: json['data'],
        message: json['message'],
      );
}
