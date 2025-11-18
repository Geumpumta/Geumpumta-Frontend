import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/service/retrofit/daily_statistics_api.dart';
import 'package:geumpumta/service/retrofit/email_api.dart';
import 'package:geumpumta/service/retrofit/grass_statistics_api.dart';
import 'package:geumpumta/service/retrofit/monthly_statistics_api.dart';
import 'package:geumpumta/service/retrofit/profile_api.dart';
import 'package:geumpumta/service/retrofit/study_api.dart';
import 'package:geumpumta/service/retrofit/user_api.dart';
import 'package:geumpumta/service/retrofit/weekly_statistics_api.dart';

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

final profileApiProvider = Provider<ProfileApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileApi(dio);
});

final weeklyStatisticsApiProvider = Provider<WeeklyStatisticsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return WeeklyStatisticsApi(dio);
});

final monthlyStatisticsApiProvider = Provider<MonthlyStatisticsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return MonthlyStatisticsApi(dio);
});

final dailyStatisticsApiProvider = Provider<DailyStatisticsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return DailyStatisticsApi(dio);
});

final grassStatisticsApiProvider = Provider<GrassStatisticsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return GrassStatisticsApi(dio);
});