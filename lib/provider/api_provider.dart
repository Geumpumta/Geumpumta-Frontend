import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/service/retrofit/email_api.dart';
import 'package:geumpumta/service/retrofit/study_api.dart';

import '../service/retrofit/user_api.dart';
import 'dio_provider.dart';

final userApiProvider = Provider<UserApi>((ref) {
  final dio = ref.watch(dioProvider);
  return UserApi(dio);
});

final emailApiProvider = Provider<EmailApi>((ref){
  final dio = ref.watch(dioProvider);
  return EmailApi(dio);
});

final studyApiProvider = Provider<StudyApi>((ref){
  final dio = ref.watch(dioProvider);
  return StudyApi(dio);
});