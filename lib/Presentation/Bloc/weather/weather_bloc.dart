import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app/Core/utils/resource/data_state.dart';
import 'package:flutter_news_app/Data/repositories/weather_repository_impl.dart';
import 'package:flutter_news_app/Domain/Models/weather/weather_response.dart';
import 'package:flutter_news_app/Domain/Repositories/weather_repository.dart';

import '../../../Domain/Models/weather/weather_request.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<GetWeatherEvent>((event, emit) async {
      WeatherRepository weatherRepo = WeatherRepositoryImpl();
      emit(WeatherLoading());
      final response = await weatherRepo.getWeather(
          request: WeatherRequest(lat: event.lat, long: event.long, appid: ''));
      if (response is DataSuccess) {
        final weather = response.data;
        emit(WeatherLoaded(weather!));
      } else {
        emit(WeatherError(response.toString()));
      }
    });
  }
}
