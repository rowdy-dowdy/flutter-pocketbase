import 'package:dio/dio.dart';
import 'package:flutter_pocketbase/services/shared_prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  var options = BaseOptions(
    baseUrl: 'http://127.0.0.1:5173',
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

        await dio.post("/api/v1/auth/refresh-token",  data: {
          "refresh_token": refreshToken
        })
        .then((value) async {
          if (value.statusCode == 200) {
            // await prefs.setString('token', value.data['token']);
            // await prefs.setString('refresh_token', value.data['refresh_token']);

            e.requestOptions.headers["Authorization"] = "Bearer " + value.data['token'];

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
        });
      } catch (e) {
        print(e);
      }
    }
    return handler.next(e);
  }));
  return dio;
});
