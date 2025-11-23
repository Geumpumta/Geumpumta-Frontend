import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/email/email_repository.dart';


final emailViewModelProvider =
Provider<EmailViewmodel>((ref) {
  final repo = ref.watch(emailRepositoryProvider);
  return EmailViewmodel(repo);
});

class EmailViewmodel {
  final EmailRepository _repo;

  EmailViewmodel(this._repo);

  Future<void> sendEmailVerification(String email) async {
    await _repo.sendEmailVerification(email);
  }

  Future<bool> verifyCode(String email, String code) async {
    return await _repo.verifyCode(email, code);
  }
}
