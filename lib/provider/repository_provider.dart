import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/repository/email/email_repository.dart';
import 'package:geumpumta/repository/rank/rank_repository.dart';

import '../repository/auth/auth_repository.dart';
import '../repository/user/user_repository.dart';
import 'api_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.watch(userApiProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return UserRepository(api,authRepo);
});

final emailRepositoryProvider = Provider<EmailRepository>((ref){
  final api = ref.watch(emailApiProvider);
  return EmailRepository(emailApi: api);
});

final rankRepositoryProvider = Provider<RankRepository>((ref){
  final api = ref.watch(rankApiProvider);
  return RankRepository(rankApi: api);
});