import 'package:geumpumta/models/dto/common/common_dto.dart';
import 'package:geumpumta/models/dto/study/end_study_request_dto.dart';
import 'package:geumpumta/models/dto/study/get_study_time_response_dto.dart';
import 'package:geumpumta/models/dto/study/send_heart_beat_request_dto.dart';
import 'package:geumpumta/models/dto/study/send_heart_beat_response_dto.dart';
import 'package:geumpumta/models/dto/study/start_study_time_request_dto.dart';
import 'package:geumpumta/models/dto/study/start_study_time_response_dto.dart';
import 'package:geumpumta/service/retrofit/study_api.dart';

class StudyRepository {
  final StudyApi api;

  StudyRepository({required this.api});

  Future<GetStudyTimeResponseDto> getStudyTime() async {
    try {
      return await api.getStudyTime();
    } catch (e, st) {
      print('[StudyRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }

  Future<StartStudyTimeResponseDto> startStudyTime(
    StartStudyTimeRequestDto dto,
  ) async {
    try {
      return await api.startStudyTime(dto);
    } catch (e, st) {
      print('[StudyRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }

  Future<SendHeartBeatResponseDto> sendHeartBeat(
    SendHeartBeatRequestDto dto,
  ) async {
    try {
      return await api.sendHeartBeat(dto);
    } catch (e, st) {
      print('[StudyRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }

  Future<CommonDto> endStudyTime(EndStudyRequestDto dto) async {
    try {
      return await api.endStudy(dto);
    } catch (e, st) {
      print('[StudyRepository] 오류 발생: $e\n$st');
      rethrow;
    }
  }
}
