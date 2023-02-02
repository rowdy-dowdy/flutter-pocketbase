import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var options = BaseOptions(
  baseUrl: 'https://base.viethung.fun',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);

Dio dio = Dio(options);

final dioProvider = Provider<Dio>((ref) {
  return dio;
});