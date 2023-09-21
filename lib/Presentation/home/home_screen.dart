import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/Core/utils/resource/globals.dart';
import 'package:flutter_news_app/Domain/Models/news/news_request.dart';
import 'package:flutter_news_app/Domain/Models/news/news_response.dart';
import 'package:flutter_news_app/Presentation/Bloc/news/news_bloc.dart';
import 'package:flutter_news_app/Presentation/Widgets/bottom_nav_bar.dart';
import 'package:flutter_news_app/Presentation/Widgets/custom_tag.dart';
import 'package:flutter_news_app/Presentation/Widgets/image_container.dart';
import 'package:flutter_news_app/Presentation/article/article_screen.dart';
import 'package:flutter_news_app/Presentation/discover/discover_screen.dart';
import 'package:flutter_news_app/Presentation/onboarding/widgets/weather_body_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
    getNews();
  }

  getNews() async {
    var favSources =
        await getPreference('favSources', type: 'list') as List<String>?;
    BlocProvider.of<NewsBloc>(context).add(GetAllNewsEvent(
      NewsRequest(
        sources: favSources?.join(','),
        country: favSources?.isEmpty ?? true ? 'us' : null,
        category: null,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withAlpha(150).withOpacity(0.3),
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            Text('News App'),
            Spacer(),
            WeatherBodyContent(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(index: 0),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, newsState) {
          if (newsState is NewsLoaded) {
            List<Article>? articles = newsState.news.articles;
            return ListView(padding: EdgeInsets.zero, children: [
              _NewsOfTheDay(
                article: articles![0],
              ),
              _BreakingNews(
                articles: articles.sublist(1),
              ),
            ]);
          } else if (newsState is NewsError) {
            return Center(
              child: Text(newsState.errorMessage),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class _BreakingNews extends StatelessWidget {
  const _BreakingNews({
    Key? key,
    required this.articles,
  }) : super(key: key);

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Breaking News',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'For your favorite sources',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/discover',
                    );
                  },
                  child: Text('More',
                      style: Theme.of(context).textTheme.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.36,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/article',
                          arguments: ArgsToArticleScreen(
                            article: articles[index],
                            category: "",
                          ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ImageContainer(
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              imageUrl: articles[index].urlToImage ?? "",
                            ),
                            TagWithAvatarContent(
                              img:
                                  "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=${articles[index].url}&size=64",
                              name: articles[index].source!.name ?? "Unknown",
                              imgSize: 20,
                              textSize: 12,
                              backColor: Colors.grey.withAlpha(180),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          articles[index].title!,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold, height: 1.5),
                        ),
                        const SizedBox(height: 5),
                        Text('${dateToString(articles[index].publishedAt!)} ',
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 5),
                        Text('by ${articles[index].author}',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsOfTheDay extends StatelessWidget {
  const _NewsOfTheDay({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      imageUrl: article.urlToImage ?? "",
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.black.withAlpha(0),
              Colors.black.withAlpha(0),
              Colors.black.withAlpha(150),
              Colors.black.withAlpha(50),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTag(
              backgroundColor: Colors.grey.withAlpha(150),
              children: [
                Text(
                  'News of the Day',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              article.title!,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                  color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/article',
                    arguments: ArgsToArticleScreen(
                      article: article,
                      category: "",
                    ));
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Row(
                children: [
                  Text(
                    'Learn More',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_right_alt,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
