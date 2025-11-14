import 'package:dio/dio.dart';
import 'package:geumpumta/models/dto/common/common_dto.dart';
import 'package:geumpumta/models/dto/study/end_study_request_dto.dart';
import 'package:geumpumta/models/dto/study/send_heart_beat_request_dto.dart';
import 'package:geumpumta/models/dto/study/send_heart_beat_response_dto.dart';
import 'package:geumpumta/models/dto/study/start_study_time_request_dto.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/dto/study/get_study_time_response_dto.dart';
import '../../models/dto/study/start_study_time_response_dto.dart';

@RestApi()
abstract class StudyApi {
  factory StudyApi(Dio dio, {String baseUrl}) = _StudyApi;

  @GET('/api/v1/study')
  Future<GetStudyTimeResponseDto> getStudyTime();

  @POST('/api/v1/study/start')
  Future<StartStudyTimeResponseDto> startStudyTime(
    @Body() StartStudyTimeRequestDto request,
  );

  @POST('/api/v1/study/heart-beat')
  Future<SendHeartBeatResponseDto> sendHeartBeat(
    @Body() SendHeartBeatRequestDto request,
  );

  @POST('/api/v1/study/end')
  Future<CommonDto> endStudy(@Body() EndStudyRequestDto request);
}
