import 'package:flutter_pocketbase/models/auth_model.dart';
import 'package:flutter_pocketbase/models/user_model.dart';
import 'package:flutter_pocketbase/providers/states/login_state.dart';
import 'package:flutter_pocketbase/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<AuthModel> {
  AuthNotifier(this._ref) : super(const AuthModel.unknown()) {
    init();
  }

  final Ref _ref;

  Future<void> init() async {
    AuthResult? result = await _ref.read(auth_repository_provider).logged();
    if (result != null) {
      state = AuthModel(authSate: AuthSate.login, user: result.user, token: result.token);
    }
    else {
      state = const AuthModel.failure();
    }
  }

  Future<void> login(String email, String password) async {
    AuthResult? result = await _ref.read(auth_repository_provider).login(email, password);

    if (result != null) {
      state = AuthModel(authSate: AuthSate.login, user: result.user, token: result.token);
    }
    else {
      state = const AuthModel.failure();
    }
  }
  
  Future<void> logOut() async {
    await _ref.read(auth_repository_provider).logOut();
    state = const AuthModel.failure();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthModel>((ref) {
  return AuthNotifier(ref);
});