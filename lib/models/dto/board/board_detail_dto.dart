class BoardDetailDto {
  final int id;
  final String title;
  final String content;
  final String createdAt;

  BoardDetailDto({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory BoardDetailDto.fromJson(Map<String, dynamic> json) {
    return BoardDetailDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

