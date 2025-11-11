class CommonDto {
  final bool success;
  final String? data;

  CommonDto({required this.success, required this.data});

  factory CommonDto.fromJson(Map<String, dynamic> json) => CommonDto(
    success: json['success'] == true || json['success'] == 'true',
    data: json['data'] ?? '',
  );
}
