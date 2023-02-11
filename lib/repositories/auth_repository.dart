import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_pocketbase/models/user_model.dart';
import 'package:flutter_pocketbase/services/dio_service.dart';
import 'package:flutter_pocketbase/services/pocketbase_service.dart';
import 'package:flutter_pocketbase/services/shared_prefs_service.dart';

class AuthResult {
  final UserModel user;
  final String token;
  final String? refreshToken;

  AuthResult({
    required this.user,
    required this.token,
    this.refreshToken,
  });
}

class AuthRepository {
  Ref? _ref;
  PocketBase? pb;
  Dio? dio;

  AuthRepository(Ref ref) {
    _ref = ref;
    pb = ref.read(pocketbaseProvider);
    dio = ref.read(dioProvider);
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      Response response = await dio!.post('/api/v1/auth/login', data: {
        "email": email,
        "password": password
      });

      dio?.options.headers['Authorization'] = response.data['token'];

      final prefs = await _ref!.read(sharedPrefsProvider.future);
      await prefs.setString('token', response.data['token']);
      await prefs.setString('refresh_token', response.data['refresh_token']);

      UserModel user = UserModel.fromMap(response.data['user']);
      
      return user;
      
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> logged() async {
    try {
      final prefs = await _ref!.read(sharedPrefsProvider.future);
      final token = await prefs.getString('token');

      dio?.options.headers['Authorization'] = "Bearer ${token}";

      Response response = await dio!.get('/api/v1/auth/me');

      // print(response.data['user']);

      UserModel user = UserModel.fromMap(response.data['user']);

      return user;
      
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> logOut() async {
    // final pb = _ref.read(pocket_provider);
    return Future.delayed(const Duration(milliseconds: 100))
      .then((value) => null);
  }

  // Stream<UserModel> userData(String userId) {
  //   return firestore.collection('users').doc(userId).snapshots().map(
  //         (event) => UserModel.fromMap(
  //           event.data()!,
  //         ),
  //       );
  // }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref);
});