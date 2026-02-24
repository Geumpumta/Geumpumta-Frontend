import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/badge/badge_response_dto.dart';
import 'package:geumpumta/models/dto/badge/set_representative_badge_request_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'badge_api.g.dart';

@RestApi()
abstract class BadgeApi {
  factory BadgeApi(Dio dio, {String baseUrl}) = _BadgeApi;

  /// 내 현재 대표 배지 조회
  @GET('/api/v1/badge/me')
  Future<BadgeResponseDto> getMyBadge();

  /// 대표 배지 설정
  @POST('/api/v1/badge/me/representative-badge')
  Future<BadgeResponseDto> setRepresentativeBadge(
    @Body() SetRepresentativeBadgeRequestDto request,
  );
}

