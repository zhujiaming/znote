import 'package:dio/dio.dart';

import 'apis.dart';

class HttpClient {
  static final Dio _dio = Dio();

  static void init() {
    _dio.options.baseUrl = Apis.host;
  }

  static post(String path, {data, Options? options}) async {
    return await _dio.post(path, data: data, options: options);
  }

  static get(String path,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.get(path,
        queryParameters: queryParameters, options: options);
  }
}
