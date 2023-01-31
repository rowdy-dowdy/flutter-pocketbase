import 'package:flutter_pocketbase/provider/state/login_state.dart';
import 'package:flutter_pocketbase/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController(this._ref) : super(const LoginStateInitial());

  final Ref _ref;

  void login(String email, String password) async {
    state = const LoginStateLoading();

    try {
      await _ref.read(auth_repository_provider).login(email, password);
      state = const LoginStateSuccess();
    } catch (e) {
      state = const LoginStateError();
    }
  }
}

final login_controller_provider = StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref);
});