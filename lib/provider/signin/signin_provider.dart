import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/provider/signin/signin_state.dart';

final signUpProvider = StateNotifierProvider<SignUpNotifier, SignInState>(
      (ref) => SignUpNotifier(),
);

class SignUpNotifier extends StateNotifier<SignInState> {
  SignUpNotifier() : super(const SignInState());

  void setStep1(String id, String email) {
    state = state.copyWith(studentId: id, email: email);
  }

  void setStep3(String department) {
    state = state.copyWith(department: department);
  }

  void reset() {
    state = const SignInState();
  }
}
