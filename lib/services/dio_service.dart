import 'package:dio/dio.dart';
import 'package:flutter_pocketbase/services/shared_prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  var options = BaseOptions(
    baseUrl: 'https://svelte.viethung.fun',
    // connectTimeout: 5000,
    // receiveTimeout: 3000,
  );

  final Dio dio = Dio(options);

  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioError e, handler) async {
    // if (error.response?.statusCode == 403 ||
    //   error.response?.statusCode == 401) {
    //   await refreshToken();
    //   return _retry(error.request);
    // }
    // return error.response;
    if (e.response?.statusCode == 401 && e.response?.statusMessage == "Unauthorized") {
      try {
        final prefs = await ref.read(sharedPrefsProvider.future);
        final refreshToken = await prefs.getString('refresh_token');

        Response response = await dio.post("/api/v1/auth/refresh-token",  data: {
          "refresh_token": refreshToken
        });

        if (response.statusCode == 200) {
          await prefs.setString('token', response.data['token']);
          await prefs.setString('refresh_token', response.data['refresh_token']);

          dio.options.headers['Authorization'] = "Bearer ${response.data['token']}";

          e.requestOptions.headers["Authorization"] = "Bearer " + response.data['token'];

          final cloneReq = await dio.request(
            e.requestOptions.path,
            options: Options(
              method: e.requestOptions.method,
              headers: e.requestOptions.headers
            ),
            data: e.requestOptions.data,
            queryParameters: e.requestOptions.queryParameters
          );

          return handler.resolve(cloneReq);
        }
        
      } catch (e) {
        print(e);
      }
    }
    return handler.next(e);
  }));
  return dio;
});
