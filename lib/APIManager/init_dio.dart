import 'package:dio/dio.dart';
import '../AppRoutes/constants.dart';
import 'app_interceptors.dart';

Dio initDio() {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: APIConstant.baseDomain,
      connectTimeout: APIConstant.timeoutDurationNormalAPIs,
      receiveTimeout: APIConstant.timeoutDurationNormalAPIs,
    ),
  );

  dio.interceptors.add(AppInterceptors());

  return dio;
}
