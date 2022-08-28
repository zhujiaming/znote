import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_log/interceptor/dio_log_interceptor.dart';
import 'package:znote/comm/log_utils.dart';
import 'package:znote/git/entity/http_resp.dart';
import 'package:znote/git/logic.dart';
import 'package:znote/main.dart';

class Engine {
  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) {
      _dio = Dio();
      _initDio(_dio!);
    }
    return _dio!;
  }

  static _initDio(Dio dio) {
    dio.options.baseUrl = "https://gitee.com/api/v5/repos";
    dio.options.headers[Headers.contentTypeHeader] =
        'application/x-www-form-urlencoded';
    dio.options.headers[Headers.acceptHeader] = '*/*';
    dio.options.headers['Accept-Encoding'] = 'gzip, deflate, br';
    dio.options.headers['Connection'] = 'keep-alive';
    dio.options.headers['User-Agent'] = 'PostmanRuntime/7.29.0';
    dio.interceptors.add(DioLogInterceptor()); //在应用上显示日志
  }

  static Future<Resp> _request(String method,
      {required String path,
      Map<String, dynamic>? queryParameters,
      dynamic data}) async {
    int? statusCode;
    String message = '';
    try {
      Response response = await dio.request(path,
          options: Options(method: method),
          queryParameters: queryParameters,
          data: data);
      statusCode = response.statusCode;
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        return Resp.success(response.data);
      } else {
        if (statusCode == 401) {
          // "401 Unauthorized: Access token does not exist"
          // await GitLogic.inst.auth();
          // _request(method, path: path)
        }
        message = response.statusMessage ?? response.data ?? '';
      }
    } catch (e) {
      LogUtil.e("$method ERROR,path:$path", e);
    }
    return Resp.error(statusCode ?? 9999, message);
  }

  static Future<Resp> post(String path, dynamic data) {
    return _request('post', path: path, data: data);
  }

  static Future<Resp> get(String path, Map<String, dynamic>? queryData) {
    return _request('get', path: path, queryParameters: queryData);
  }

}
