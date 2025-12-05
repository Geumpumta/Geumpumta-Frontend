class BoardListItemDto {
  final int id;
  final String title;
  final String createdAt;

  BoardListItemDto({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory BoardListItemDto.fromJson(Map<String, dynamic> json) {
    return BoardListItemDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

