import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/Presentation/Bloc/location/location_bloc.dart';
import 'package:flutter_news_app/Presentation/Bloc/weather/weather_bloc.dart';
import 'package:flutter_news_app/Presentation/Widgets/loading_widget.dart';

class WeatherBodyContent extends StatelessWidget {
  final Color? txtColor;
  const WeatherBodyContent({
    super.key,
    this.txtColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locationState) {
        if (locationState is LocationLoading) {
          return const LoadingWdg();
        } else if (locationState is LocationLoaded) {
          return BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, weatherState) {
            if (weatherState is WeatherInitial) {
              BlocProvider.of<WeatherBloc>(context).add(GetWeatherEvent(
                  lat: locationState.location.latitude.toString(),
                  long: locationState.location.longitude.toString()));
            }
            if (weatherState is WeatherLoading) {
              return const LoadingWdg();
            } else if (weatherState is WeatherLoaded) {
              final weather = weatherState.weather;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'http://openweathermap.org/img/w/${weather.weather.first.icon}.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Text(
                      '${weather.main.temp} F° - ${weather.weather.first.main}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: txtColor ?? Colors.white,
                          )),
                ],
              );
            } else if (weatherState is WeatherError) {
              return Text('Error: ${weatherState.errorMessage}');
            } else {
              return const SizedBox();
            }
          });
        } else if (locationState is LocationError) {
          return Text('Error: ${locationState.errorMessage}');
        } else {
          return ElevatedButton(
            onPressed: () {
              BlocProvider.of<LocationBloc>(context).add(GetLocationEvent());
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Get my weather'),
          );
        }
      },
    );
  }
}
