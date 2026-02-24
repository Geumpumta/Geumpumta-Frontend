import 'package:geumpumta/models/dto/badge/set_representative_badge_request_dto.dart';
import 'package:geumpumta/models/entity/badge/my_badge.dart';
import 'package:geumpumta/service/retrofit/badge_api.dart';

class BadgeRepository {
  BadgeRepository(this._api);

  final BadgeApi _api;

  Future<MyBadge?> fetchMyBadge() async {
    final response = await _api.getMyBadge();
    if (!response.success || response.data == null) {
      return null;
    }
    return MyBadge.fromDto(response.data!);
  }

  Future<MyBadge?> setRepresentativeBadge(String badgeCode) async {
    final response = await _api.setRepresentativeBadge(
      SetRepresentativeBadgeRequestDto(badgeCode: badgeCode),
    );
    if (!response.success || response.data == null) {
      return null;
    }
    return MyBadge.fromDto(response.data!);
  }
}

