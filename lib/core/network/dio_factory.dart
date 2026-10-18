import 'package:dio/dio.dart';

import '../constants/app_config.dart';

Dio createNewsDio() => Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: AppDurations.request,
    receiveTimeout: AppDurations.request,
    sendTimeout: AppDurations.request,
    headers: {'Accept': 'application/json'},
  ),
);
