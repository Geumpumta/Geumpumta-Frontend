class UpdateProfileRequestDto {
  final String nickname;
  final String imageUrl;
  final String publicId;

  UpdateProfileRequestDto({
    required this.nickname,
    required this.imageUrl,
    required this.publicId,
  });

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'imageUrl': imageUrl,
        'publicId': publicId,
      };
}


