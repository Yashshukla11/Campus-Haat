import 'package:dio/dio.dart';

class HttpService {
  final Dio _dio = Dio();
  final String _baseUrl =
      'http://chprod-env.eba-psapqnmi.ap-south-1.elasticbeanstalk.com/webapi';

  HttpService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 3);
  }

  Future<Response> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
