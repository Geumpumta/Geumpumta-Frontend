import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/board/board_detail_response_dto.dart';
import 'package:geumpumta/models/dto/board/board_list_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'board_api.g.dart';

@RestApi()
abstract class BoardApi {
  factory BoardApi(Dio dio, {String baseUrl}) = _BoardApi;

  @GET('/api/v1/board/list')
  Future<BoardListResponseDto> getBoardList();

  @GET('/api/v1/board/{boardId}')
  Future<BoardDetailResponseDto> getBoardDetail(
    @Path('boardId') int boardId,
  );
}

