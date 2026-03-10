class SetRepresentativeBadgeRequestDto {
  SetRepresentativeBadgeRequestDto({required this.badgeCode});

  final String badgeCode;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'badgeCode': badgeCode,
    };
  }
}

