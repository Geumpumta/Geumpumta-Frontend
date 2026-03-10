/// 활동 배지 엔티티
class ActivityBadge {
  const ActivityBadge({
    required this.id,
    required this.name,
    required this.description,
    this.subDescription,
    this.isUnlocked = false,
    this.iconCodePoint,
  });

  final String id;
  final String name;
  final String description;
  final String? subDescription;
  final bool isUnlocked;
  final int? iconCodePoint;

  /// 잠금 해제된 배지만 대표 배지로 선택 가능
  bool get canSelectAsRepresentative => isUnlocked;
}
