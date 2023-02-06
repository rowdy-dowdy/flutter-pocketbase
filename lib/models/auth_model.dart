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
  final String? refreshToken;

  AuthModel({required this.authSate, required this.user, required this.token, required this.refreshToken});

  const AuthModel.unknown()
    : authSate = AuthSate.initial,
      user = null,
      token = null,
      refreshToken = null;

  const AuthModel.failure()
    : authSate = AuthSate.notLogin,
      user = null,
      token = null,
      refreshToken = null;

}