import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repository/auth/auth_repository.dart';

final loginViewModelProvider = ChangeNotifierProvider<LoginViewModel>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginViewModel(repo);
});

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  LoginViewModel(this._repository);

  Future<void> loginWithKakao() async {
    await _repository.loginWithKakao();
  }

  Future<void> loginWithGoogle() async {
    await _repository.loginWithGoogle();
  }
}
