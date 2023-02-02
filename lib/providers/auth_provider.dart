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
    state = state.copiedWithIsLoading(true);
    AuthResult? result = await _ref.read(auth_repository_provider).logged();
    if (result != null) {
      state = AuthModel(authSate: AuthSate.success, isLoading: false, user: result.user, token: result.token);
    }
    else {
      state = const AuthModel.unknown();
    }
  }

  void login(String email, String password) async {
    state = state.copiedWithIsLoading(true);
    AuthResult? result = await _ref.read(auth_repository_provider).login(email, password);

    if (result != null) {
      state = AuthModel(authSate: AuthSate.success, isLoading: false, user: result.user, token: result.token);
    }
    else {
      state = const AuthModel.unknown();
    }
  }
  
  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _ref.read(auth_repository_provider).logOut();
    state = const AuthModel.unknown();
  }
}

final auth_provider = StateNotifierProvider<AuthNotifier, AuthModel>((ref) {
  return AuthNotifier(ref);
});