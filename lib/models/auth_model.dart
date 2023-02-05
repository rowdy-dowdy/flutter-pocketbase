import 'package:flutter_pocketbase/models/user_model.dart';

enum AuthSate {
  initial,
  login,
  notLogin
}

class AuthModel {
  final AuthSate? authSate;
  final UserModel? user;
  final String? token;

  AuthModel({required this.authSate, required this.user, required this.token});

  const AuthModel.unknown()
    : authSate = AuthSate.initial,
      user = null,
      token = null;

  const AuthModel.failure()
    : authSate = AuthSate.notLogin,
      user = null,
      token = null;

}