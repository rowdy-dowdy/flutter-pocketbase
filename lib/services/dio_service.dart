import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  var options = BaseOptions(
  baseUrl: 'http://127.0.0.1:5173',
    // connectTimeout: 5000,
    // receiveTimeout: 3000,
  );

  final Dio dio = Dio(options);

  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioError e, handler) {
      // if (error.response?.statusCode == 403 ||
      //   error.response?.statusCode == 401) {
      //   await refreshToken();
      //   return _retry(error.request);
      // }
      // return error.response;
      print(e.message);
      print(e.response?.data['Unauthorized']);
      return  handler.next(e);
    }
  ));
  return dio;
});