part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherResponse weather;

  const WeatherLoaded(this.weather);
}

class WeatherError extends WeatherState {
  final String errorMessage;

  const WeatherError(this.errorMessage);
}
