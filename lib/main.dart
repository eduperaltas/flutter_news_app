import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/Core/config/app_themes.dart';
import 'package:flutter_news_app/Core/config/routes.dart';
import 'package:flutter_news_app/Presentation/Bloc/news/news_bloc.dart';
import 'package:flutter_news_app/Presentation/Bloc/weather/weather_bloc.dart';
import 'package:flutter_news_app/Presentation/Bloc/location/location_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(
          create: (context) => LocationBloc(),
        ),
        BlocProvider<WeatherBloc>(
          create: (context) => WeatherBloc(),
        ),
        BlocProvider<NewsBloc>(
          create: (context) => NewsBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: Apptheme.lightTheme,
        initialRoute: '/onboarding',
        routes: routes,
      ),
    );
  }
}
