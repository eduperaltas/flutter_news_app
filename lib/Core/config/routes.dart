import 'package:flutter/cupertino.dart';
import 'package:flutter_news_app/Presentation/article/article_screen.dart';
import 'package:flutter_news_app/Presentation/discover/discover_screen.dart';
import 'package:flutter_news_app/Presentation/home/home_screen.dart';
import 'package:flutter_news_app/Presentation/onboarding/onbording_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/onboarding': (context) => const OnBordingScreen(),
  '/article': (context) => const ArticleScreen(),
  '/home': (context) => const HomeScreen(),
  '/discover': (context) => const DiscoverScreen(),
};
