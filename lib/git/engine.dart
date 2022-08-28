import 'package:dio/dio.dart';
import 'package:dio_log/interceptor/dio_log_interceptor.dart';


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
    dio.options.baseUrl = "https://gitee.com/api/v5/";
    dio.options.headers[Headers.contentTypeHeader] = 'application/x-www-form-urlencoded';
    dio.options.headers[Headers.acceptHeader] = '*/*';
    dio.options.headers['Accept-Encoding'] = 'gzip, deflate, br';
    dio.options.headers['Connection'] = 'keep-alive';
    dio.interceptors.add(DioLogInterceptor());//在应用上显示日志
  }


  static post(String path,dynamic data) {
    return dio.post(path,data: data,);
  }
}
