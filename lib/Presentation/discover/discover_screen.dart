import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/Domain/Models/news/news_request.dart';
import 'package:flutter_news_app/Domain/Models/news/source_response.dart';
import 'package:flutter_news_app/Presentation/Bloc/news/news_bloc.dart';
import 'package:flutter_news_app/Presentation/Widgets/bottom_nav_bar.dart';
import 'package:flutter_news_app/Presentation/Widgets/image_container.dart';
import 'package:flutter_news_app/Presentation/Widgets/loading_widget.dart';
import 'package:flutter_news_app/Presentation/article/article_screen.dart';
import 'package:flutter_news_app/Presentation/onboarding/widgets/weather_body_content.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> tabs = Category.values
        .map((category) => category.toString().split('.').last)
        .toList();

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
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
        bottomNavigationBar: const BottomNavBar(index: 1),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [const _DiscoverNews(), _CategoryNews(tabs: tabs)],
        ),
      ),
    );
  }
}

class _CategoryNews extends StatefulWidget {
  const _CategoryNews({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<String> tabs;

  @override
  State<_CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<_CategoryNews>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    getNews();
    _tabController!.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController!.indexIsChanging) {
      getNews();
    }
  }

  getNews() {
    BlocProvider.of<NewsBloc>(context).add(GetNewsByFilterEvent(NewsRequest(
      country: 'us',
      category: widget.tabs[_tabController!.index].toLowerCase(),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.black,
          tabs: widget.tabs
              .map(
                (tab) => Tab(
                  icon: Text(
                    tab,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: widget.tabs
                .map(
                  (tab) => BlocBuilder<NewsBloc, NewsState>(
                    builder: (context, newsState) {
                      if (newsState is NewsInitial) {
                        BlocProvider.of<NewsBloc>(context)
                            .add(GetNewsByFilterEvent(NewsRequest(
                          category: tab.toLowerCase(),
                        )));
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (newsState is NewsLoading) {
                        return const LoadingWdg();
                      } else if (newsState is NewsLoaded) {
                        final news = newsState.news.articles;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: news?.length,
                          itemBuilder: ((context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/article',
                                    arguments: ArgsToArticleScreen(
                                        article: news[index], category: tab));
                              },
                              child: Row(
                                children: [
                                  ImageContainer(
                                    width: 80,
                                    height: 80,
                                    margin: const EdgeInsets.all(10.0),
                                    borderRadius: 5,
                                    imageUrl: news![index].urlToImage ?? "",
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          news[index].title!,
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.calendar_month_rounded,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${dateToString(news[index].publishedAt!)} ',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(width: 20),
                                            const Icon(
                                              Icons.newspaper_rounded,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 5),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Text(
                                                '${news[index].author}',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
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
                )
                .toList(),
          ),
        )
      ],
    );
  }
}

dateToString(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

class _DiscoverNews extends StatelessWidget {
  const _DiscoverNews({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Discover',
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            'News from all over the world',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Search',
              fillColor: Colors.grey.shade200,
              filled: true,
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              suffixIcon: const RotatedBox(
                quarterTurns: 1,
                child: Icon(
                  Icons.tune,
                  color: Colors.grey,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
