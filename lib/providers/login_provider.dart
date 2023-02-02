import 'package:flutter_pocketbase/providers/states/login_state.dart';
import 'package:flutter_pocketbase/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._ref) : super(const LoginStateInitial());

  final Ref _ref;

  void login(String email, String password) async {
    state = const LoginStateLoading();

    try {
      print('login');
      await _ref.read(auth_repository_provider).login(email, password);
      state = const LoginStateSuccess();
      print('login success');
    } catch (e) {
      state = const LoginStateError();
    }
  }
}

final login_provider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});