import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  Future<String> login(String email, String password) async {
    return Future.delayed(const Duration(milliseconds: 100))
      .then((value) => 'token');
  }
}

final auth_service_provider = Provider<AuthService>((ref) => AuthService());