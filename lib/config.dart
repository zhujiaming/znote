import 'package:dio_log/interceptor/dio_log_interceptor.dart';
import 'package:dio_log/utils/log_pool_manager.dart';

class Config {

  static const String userName = "ah_zjm@163.com";
  static const String password = "zjm6253321";

  static const String clientId =
      "584f288684626a09db1098df1158845cd4de670fc2b013269fcc79cf411d9447";
  static const String clientSecret =
      "ff4bd06b35b783d408258a17e5e198a7ccd058506cfd58c5597025e4dc6a3e78";
  static const String scope = "projects gists";
}

class LogConfig{
  //针对 dio_log 工具的设置
  initDioLog() {
    /// Sets the maximum number of entries for logging 设置记录日志的最大条数
    LogPoolManager.getInstance().maxCount = 500;
    ///Add the isError method implementation to LogPoolManager so that request messages defined as errors are displayed in red font
    LogPoolManager.getInstance().isError = (res) => res.resOptions==null;
    ///Disabling Log Printing
    DioLogInterceptor.enablePrintLog = false;
  }
}
