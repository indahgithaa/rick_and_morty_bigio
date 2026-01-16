import 'package:dio/dio.dart';

class DioClient {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  }
}
