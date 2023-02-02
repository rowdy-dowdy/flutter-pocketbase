import 'package:flutter_pocketbase/models/user_model.dart';

enum AuthSate {
  aborted,
  success,
  failure
}

class AuthModel {
  final AuthSate? authSate;
  final bool isLoading;
  final UserModel? user;
  final String? token;

  AuthModel({required this.authSate, required this.isLoading, required this.user, required this.token});

  const AuthModel.unknown()
    : authSate = null,
      isLoading = false,
      user = null,
      token = null;

  AuthModel copiedWithIsLoading(bool isLoading) {
    return AuthModel(authSate: authSate, isLoading: isLoading, user: user, token: token);
  }
}