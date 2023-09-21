import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/Core/utils/consts/strings.dart';
import 'package:flutter_news_app/Core/utils/resource/data_state.dart';
import 'package:flutter_news_app/Data/repositories/Base/base_api_repository.dart';
import 'package:flutter_news_app/Domain/Models/weather/weather_response.dart';
import 'package:flutter_news_app/Domain/Models/weather/weather_request.dart';
import 'package:flutter_news_app/Domain/Repositories/weather_repository.dart';

class WeatherRepositoryImpl extends BaseApiRepository
    implements WeatherRepository {
  final Dio _dio = Dio();

  var weatherUrl = '$weatherBaseUrl/weather';

  @override
  Future<DataState<WeatherResponse>> getWeather(
      {required WeatherRequest request}) async {
    return getStateOf<WeatherResponse>(
      request: () async {
        return await _dio.get(
            'https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=7deebb199a9c0678389a519419e69de5');
      },
      fromJson: (json) => WeatherResponse.fromJson(json),
    );
  }
}
