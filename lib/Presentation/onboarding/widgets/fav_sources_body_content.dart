import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/Core/utils/resource/globals.dart';
import 'package:flutter_news_app/Domain/Models/news/source_request.dart';
import 'package:flutter_news_app/Domain/Models/news/source_response.dart';
import 'package:flutter_news_app/Presentation/Bloc/news/news_bloc.dart';
import 'package:flutter_news_app/Presentation/Widgets/loading_widget.dart';
import 'package:flutter_news_app/Presentation/Widgets/searchBar/searchBar.dart';

class FavSourceBodyContent extends StatefulWidget {
  List<String> selectedSources;

  FavSourceBodyContent({Key? key, required this.selectedSources})
      : super(key: key);

  @override
  State<FavSourceBodyContent> createState() => _FavSourceBodyContentState();
}

class _FavSourceBodyContentState extends State<FavSourceBodyContent> {
  int currentPage = 1;
  final TextEditingController _searchController = TextEditingController();
  List<String> filters = [];
  List<String> selectFilters = [];
  List<Source> filteredSources = [];
  List<Source> allSources = [];

  @override
  void initState() {
    super.initState();
    loadMoreData();
  }

  getSource(String? language, String? country, String? category) {
    BlocProvider.of<NewsBloc>(context).add(GetSourcesEvent(
      SourceRequest(
        language: language,
        country: country,
        category: category,
        page: currentPage.toString(),
      ),
    ));
  }

  void loadMoreData() {
    setState(() {
      currentPage++;
    });
    getSource(null, null, null);
  }

  _onSearchTextChanged(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredSources = allSources;
      } else {
        filteredSources = allSources.where((source) {
          final title = source.name.toLowerCase();
          final searchLower = searchText.toLowerCase();
          return title.contains(searchLower);
        }).toList();
      }
    });
  }

  _onFilterPressed() {}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        children: [
          //Filters
          CustomSearchBar(
            searchController: _searchController,
            onSearchTextChanged: _onSearchTextChanged,
            onFilterPressed: _onFilterPressed,
            filtersLen: selectFilters.length.toString(),
          ),
          BlocBuilder<NewsBloc, NewsState>(
            bloc: BlocProvider.of<NewsBloc>(context),
            builder: (context, newsState) {
              if (newsState is SourceLoading && currentPage == 1) {
                return const LoadingWdg();
              } else if (newsState is SourceLoaded) {
                allSources = newsState.sources.sources;
                final gridItemCount = filteredSources.isNotEmpty
                    ? filteredSources.length
                    : allSources.length;

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: gridItemCount,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final sourceObj = filteredSources.isNotEmpty
                          ? filteredSources[index]
                          : allSources[index];
                      final isSelected =
                          widget.selectedSources.contains(sourceObj.id);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              widget.selectedSources.remove(sourceObj.id);
                              setPreference(
                                  'favSources', widget.selectedSources);
                            } else {
                              widget.selectedSources.add(sourceObj.id);
                              setPreference(
                                  'favSources', widget.selectedSources);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.all(5),
                          transformAlignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black45 : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSourceImage(sourceObj.url),
                              const SizedBox(height: 8),
                              Text(
                                sourceObj.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (newsState is SourceError) {
                return Text('Error: ${newsState.errorMessage}');
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildSourceImage(String sourceUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        height: 50,
        width: 50,
        imageUrl:
            "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=${sourceUrl}&size=64",
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }
}
