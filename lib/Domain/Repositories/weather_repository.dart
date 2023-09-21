import 'package:flutter_news_app/Core/utils/resource/data_state.dart';
import 'package:flutter_news_app/Domain/Models/weather/weather_request.dart';
import 'package:flutter_news_app/Domain/Models/weather/weather_response.dart';

abstract class WeatherRepository {
  Future<DataState<WeatherResponse>> getWeather({
    required WeatherRequest request,
  });
}
