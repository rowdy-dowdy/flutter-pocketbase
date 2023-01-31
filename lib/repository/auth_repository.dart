import 'package:flutter_pocketbase/service/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final AuthService _auth_service;

  AuthRepository(this._auth_service);

  Future<String> login(String email, String password) async {
    return _auth_service.login(email, password);
  }
}

final auth_repository_provider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(auth_service_provider));
});