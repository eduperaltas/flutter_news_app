import 'dart:io' show HttpStatus;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/Core/utils/resource/data_state.dart';

abstract class BaseApiRepository {
  @protected
  Future<DataState<T>> getStateOf<T>({
    required Future<Response<Map<String, dynamic>>> Function() request,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final httpResponse = await request();
      if (httpResponse.statusCode == HttpStatus.ok) {
        final data = httpResponse.data;

        final result = fromJson(data!);

        return DataSuccess(result);
      } else {
        throw DioException(
          response: httpResponse,
          requestOptions: httpResponse.requestOptions,
        );
      }
    } on DioException catch (error) {
      return DataFailed(error);
    }
  }
}
