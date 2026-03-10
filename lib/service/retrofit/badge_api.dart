import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/badge/badge_response_dto.dart';
import 'package:geumpumta/models/dto/badge/my_badge_list_response_dto.dart';
import 'package:geumpumta/models/dto/badge/set_representative_badge_request_dto.dart';
import 'package:geumpumta/models/dto/badge/unnotified_badge_list_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'badge_api.g.dart';

@RestApi()
abstract class BadgeApi {
  factory BadgeApi(Dio dio, {String baseUrl}) = _BadgeApi;

  /// 내 활동 배지 전체 조회
  @GET('/api/v1/badge/me')
  Future<MyBadgeListResponseDto> getMyBadge();

  /// 미확인 배지 조회
  @GET('/api/v1/badge/unnotified')
  Future<UnnotifiedBadgeListResponseDto> getUnnotifiedBadges();

  /// 대표 배지 설정
  @POST('/api/v1/badge/me/representative-badge')
  Future<BadgeResponseDto> setRepresentativeBadge(
    @Body() SetRepresentativeBadgeRequestDto request,
  );
}
