import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/common/common_dto.dart';
import 'package:geumpumta/models/dto/study/end_study_request_dto.dart';
import 'package:geumpumta/models/dto/study/get_study_time_response_dto.dart';
import 'package:geumpumta/models/dto/study/send_heart_beat_request_dto.dart';
import 'package:geumpumta/models/dto/study/send_heart_beat_response_dto.dart';
import 'package:geumpumta/models/dto/study/start_study_time_request_dto.dart';
import 'package:geumpumta/models/dto/study/start_study_time_response_dto.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/study/study_repository.dart';
import 'package:network_info_plus/network_info_plus.dart';

final studyViewmodelProvider = Provider<StudyViewmodel>((ref) {
  final repo = ref.watch(studyRepositoryProvider);
  return StudyViewmodel(ref, repo);
});

class StudyViewmodel extends StateNotifier<AsyncValue<dynamic>> {
  final Ref ref;
  final StudyRepository repo;

  StudyViewmodel(this.ref, this.repo) : super(const AsyncData(null));

  Future<GetStudyTimeResponseDto?> getStudyTime() async {
    try {
      final response = await repo.getStudyTime();
      if (!response.success) {
        throw Exception(response.message);
      }
      return response;
    } catch (e, st) {
      print('[StudyViewmodel] 오류 발생: $e\n$st');
    }
    return null;
  }

  Future<StartStudyTimeResponseDto?> startStudyTime(
      StartStudyTimeRequestDto dto) async {

    try {
      final response = await repo.startStudyTime(dto);

      return response;
    } catch (e, st) {
      print('[StudyViewmodel] 예외 발생: $e\n$st');

      return null;
    }
  }



  Future<SendHeartBeatResponseDto?> sendHeartBeat(
    SendHeartBeatRequestDto dto,
  ) async {
    try {
      final response = await repo.sendHeartBeat(dto);
      if (!response.success) {
        throw Exception(response..data.message);
      }
      return response;
    } catch (e, st) {
      print('[StudyViewmodel] 오류 발생: $e\n$st');
    }
    return null;
  }

  Future<CommonDto?> endStudyTime(EndStudyRequestDto dto) async {
    try {
      final response = await repo.endStudyTime(dto);
      if (!response.success) {
        throw Exception(response.message);
      }
      return response;
    } catch (e, st) {
      print('[StudyViewmodel] 오류 발생: $e\n$st');
    }
    return null;
  }

  Future<Map<String, String?>> getWIFIInfo() async {
    final networkInfo = NetworkInfo();

    try {
      final gatewayIp = await networkInfo.getWifiGatewayIP();
      final ip = await networkInfo.getWifiIP();
      print('gatewayIp : $gatewayIp, ip : $ip');

      return {"gatewayIp": gatewayIp, "ip": ip};
    } catch (e, st) {
      print("WIFI error: $e\n$st");
      return {"gatewayIp": null, "ip": null};
    }
  }
}
