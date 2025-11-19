import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/repository/email/email_repository.dart';
import 'package:geumpumta/repository/rank/rank_repository.dart';
import 'package:geumpumta/repository/profile/profile_repository.dart';
import 'package:geumpumta/repository/stats/daily_statistics_repository.dart';
import 'package:geumpumta/repository/stats/grass_statistics_repository.dart';
import 'package:geumpumta/repository/stats/monthly_statistics_repository.dart';
import 'package:geumpumta/repository/stats/weekly_statistics_repository.dart';
import 'package:geumpumta/repository/study/study_repository.dart';

import '../repository/auth/auth_repository.dart';
import '../repository/user/user_repository.dart';
import 'api_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.watch(userApiProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return UserRepository(api, authRepo);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final api = ref.watch(profileApiProvider);
  return ProfileRepository(api);
});

final emailRepositoryProvider = Provider<EmailRepository>((ref) {
  final api = ref.watch(emailApiProvider);
  return EmailRepository(emailApi: api);
});

final rankRepositoryProvider = Provider<RankRepository>((ref) {
  final api = ref.watch(rankApiProvider);
  return RankRepository(rankApi: api);
});

final studyRepositoryProvider = Provider<StudyRepository>((ref) {
  final api = ref.watch(studyApiProvider);
  return StudyRepository(api: api);
});

final weeklyStatisticsRepositoryProvider = Provider<WeeklyStatisticsRepository>(
  (ref) {
    final api = ref.watch(weeklyStatisticsApiProvider);
    return WeeklyStatisticsRepository(api);
  },
);

final monthlyStatisticsRepositoryProvider =
    Provider<MonthlyStatisticsRepository>((ref) {
      final api = ref.watch(monthlyStatisticsApiProvider);
      return MonthlyStatisticsRepository(api);
    });

final dailyStatisticsRepositoryProvider = Provider<DailyStatisticsRepository>((
  ref,
) {
  final api = ref.watch(dailyStatisticsApiProvider);
  return DailyStatisticsRepository(api);
});

final grassStatisticsRepositoryProvider = Provider<GrassStatisticsRepository>((
  ref,
) {
  final api = ref.watch(grassStatisticsApiProvider);
  return GrassStatisticsRepository(api);
});
