class ImageUploadResponseDto {
  final bool success;
  final ImageUploadDataDto data;

  ImageUploadResponseDto({required this.success, required this.data});

  factory ImageUploadResponseDto.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponseDto(
      success: json['success'] == true || json['success'] == 'true',
      data: ImageUploadDataDto.fromJson(
        (json['data'] ?? const <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }
}

class ImageUploadDataDto {
  final String imageUrl;
  final String publicId;

  ImageUploadDataDto({required this.imageUrl, required this.publicId});

  factory ImageUploadDataDto.fromJson(Map<String, dynamic> json) {
    return ImageUploadDataDto(
      imageUrl: json['imageUrl'] as String? ?? '',
      publicId: json['publicId'] as String? ?? '',
    );
  }
}


