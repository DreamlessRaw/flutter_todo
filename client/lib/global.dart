import 'package:dio/dio.dart';

class Global {
  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) {
      var options = BaseOptions(
          baseUrl: 'http://192.168.1.37:8080/',
          connectTimeout: 3000,
          receiveTimeout: 3000);
      _dio = Dio(options);
    }
    return _dio!;
  }
}
