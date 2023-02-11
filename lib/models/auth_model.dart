import 'package:flutter_pocketbase/models/user_model.dart';

enum AuthSate {
  initial,
  login,
  notLogin
}

class AuthModel {
  final AuthSate? authSate;
  final UserModel? user;

  AuthModel({required this.authSate, required this.user});

  const AuthModel.unknown()
    : authSate = AuthSate.initial,
      user = null;

  const AuthModel.failure()
    : authSate = AuthSate.notLogin,
      user = null;

}