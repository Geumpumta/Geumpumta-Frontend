class CommonDto {
  final bool success;
  final String? data;
  final String? message;

  CommonDto({required this.success, this.data, this.message});

  factory CommonDto.fromJson(Map<String, dynamic> json) => CommonDto(
    success: json['success'] == true || json['success'] == 'true',
    data: json['data'],
    message: json['message'],
  );
}
