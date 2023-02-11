import 'package:flutter_pocketbase/models/auth_model.dart';
import 'package:flutter_pocketbase/models/user_model.dart';
import 'package:flutter_pocketbase/repositories/auth_repository.dart';
import 'package:flutter_pocketbase/services/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart';

class AuthNotifier extends StateNotifier<AuthModel> {
  AuthNotifier(this._ref) : super(const AuthModel.unknown()) {
    init();
  }

  final Ref _ref;

  Future<void> init() async {
    UserModel? result = await _ref.read(authRepositoryProvider).logged();
    print(result);
    if (result != null) {
      state = AuthModel(authSate: AuthSate.login, user: result);

      // connect socket io
      _ref.read(socketProvider).emit("join", result.id);
    }
    else {
      state = const AuthModel.failure();
    }
  }

  Future<void> login(String email, String password) async {
    UserModel? result = await _ref.read(authRepositoryProvider).login(email, password);

    if (result != null) {
      state = AuthModel(authSate: AuthSate.login, user: result);

      // connect socket io
      _ref.read(socketProvider).emit("join", result.id);
    }
    else {
      state = const AuthModel.failure();
    }
  }
  
  Future<void> logOut() async {
    await _ref.read(authRepositoryProvider).logOut();
    state = const AuthModel.failure();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthModel>((ref) {
  return AuthNotifier(ref);
});