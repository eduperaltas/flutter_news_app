import 'package:flutter/material.dart';
import 'package:flutter_news_app/Presentation/onboarding/widgets/dot_indicator.dart';
import 'package:flutter_news_app/Presentation/onboarding/widgets/fav_sources_body_content.dart';
import 'package:flutter_news_app/Presentation/onboarding/widgets/onboard_content.dart';
import 'package:flutter_news_app/Presentation/onboarding/widgets/weather_body_content.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({Key? key}) : super(key: key);

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  late PageController _pageController;
  int pageIndex = 0;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //skip button
        appBar: AppBar(
          actions: [
            pageIndex != 3
                ? TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: lstOnboardWdg.length,
                    onPageChanged: (index) {
                      setState(() {
                        pageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) => lstOnboardWdg[index],
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    // dots indicator with animated container depending on the controller
                    ...List.generate(
                        lstOnboardWdg.length,
                        (index) => DotIndicator(
                              isActive: index == pageIndex,
                            )),

                    const Spacer(),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ElevatedButton(
                          onPressed: () {
                            if (pageIndex == 3) {
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

final List<OnboardContent> lstOnboardWdg = [
  const OnboardContent(
    img: 'assets/svg/welcome.svg',
    title: 'Welcome to News App',
    description:
        'The News App is a Flutter application that provides news headlines from all over the world.',
  ),
  const OnboardContent(
    img: 'assets/svg/read.svg',
    title: 'Read News',
    description: 'Read the latest news from all over the world in one place.',
  ),
  const OnboardContent(
    img: 'assets/svg/weather.svg',
    title: 'Get the current weather',
    description: 'Get the current weather in your location.',
    body: WeatherBodyContent(
      txtColor: Colors.black,
    ),
  ),
  OnboardContent(
    img: 'assets/svg/filter.svg',
    title: 'The final step, to customize your experience',
    description: 'Select your favorite news sources and enjoy reading.',
    body: FavSourceBodyContent(
      selectedSources: [],
    ),
  ),
];
