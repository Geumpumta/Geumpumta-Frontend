import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/repository/email/email_repository.dart';

import '../repository/user/user_repository.dart';
import 'api_provider.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.watch(userApiProvider);
  return UserRepository(api);
});

final emailRepositoryProvider = Provider<EmailRepository>((ref){
  final api = ref.watch(emailApiProvider);
  return EmailRepository(emailApi: api);
});