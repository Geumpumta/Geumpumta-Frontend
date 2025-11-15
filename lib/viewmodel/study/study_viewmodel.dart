import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/study/end_study_request_dto.dart';
import 'package:geumpumta/models/dto/study/send_heart_beat_request_dto.dart';
import 'package:geumpumta/models/dto/study/start_study_time_request_dto.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/study/study_repository.dart';

final StudyViewmodelProivder =
    StateNotifierProvider<StudyViewmodel, AsyncValue<dynamic>>((ref) {
      final repo = ref.watch(studyRepositoryProvider);
      return StudyViewmodel(ref, repo);
    });

class StudyViewmodel extends StateNotifier<AsyncValue<dynamic>> {
  final Ref ref;
  final StudyRepository repo;

  StudyViewmodel(this.ref, this.repo):super(const AsyncData(null));

  Future<void> getStudyTime() async {
    state = const AsyncLoading();
    try {
      final response = await repo.getStudyTime();
      if (!response.success) {
        state = AsyncError(
          response.message ?? "알 수 없는 오류",
          StackTrace.current,
        );
        return;
      }
      state = AsyncData(response.data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> startStudyTime(StartStudyTimeRequestDto dto) async {
    state = const AsyncLoading();
    try{
      final response = await repo.startStudyTime(dto);
      if (!response.success) {
        state = AsyncError(
          response.message ?? "알 수 없는 오류",
          StackTrace.current,
        );
        return;
      }
      state = AsyncData(response.data);
    }catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> sendHeartBeat(SendHeartBeatRequestDto dto) async{
    try{
      final response = await repo.sendHeartBeat(dto);
      if (!response.success) {
        state = AsyncError(
          response.message ?? "알 수 없는 오류",
          StackTrace.current,
        );
        return;
      }
      state = AsyncData(response.data);
    }catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> endStudyTime(EndStudyRequestDto dto) async {
    state = const AsyncLoading();
    try{
      final response = await repo.endStudyTime(dto);
      if (!response.success) {
        state = AsyncError(
          response.message ?? "알 수 없는 오류",
          StackTrace.current,
        );
        return;
      }
      state = AsyncData(response.data);
    }catch (e, st) {
      state = AsyncError(e, st);
    }
  }

}
