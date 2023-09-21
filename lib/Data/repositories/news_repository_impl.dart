import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/Core/utils/consts/strings.dart';
import 'package:flutter_news_app/Core/utils/resource/data_state.dart';
import 'package:flutter_news_app/Data/repositories/Base/base_api_repository.dart';
import 'package:flutter_news_app/Domain/Models/news/news_response.dart';
import 'package:flutter_news_app/Domain/Models/news/news_request.dart';
import 'package:flutter_news_app/Domain/Models/news/source_response.dart';
import 'package:flutter_news_app/Domain/Models/news/source_request.dart';
import 'package:flutter_news_app/Domain/Repositories/news_repository.dart';

class NewsRepositoryImpl extends BaseApiRepository implements NewsRepository {
  final Dio _dio = Dio();

  var SourcesUrl = '$newsBaseUrl/sources';
  var TopHeadlinesUrl = '$newsBaseUrl/top-headlines';
  var everythingUrl = "$newsBaseUrl/everything";

  @override
  Future<DataState<SourceResponse>> getSources(
      {required SourceRequest request}) {
    return getStateOf<SourceResponse>(
      request: () async {
        String fullUrl =
            "$SourcesUrl?${request.category != null ? 'category=${request.category}&' : ''}${request.country != null ? 'country=${request.country}&' : ''}${request.language != null ? 'language=${request.language}&' : ''}apiKey=$newsApiKey";
        return await _dio.get(fullUrl);
      },
      fromJson: (json) => SourceResponse.fromJson(json),
    );
  }

  @override
  Future<DataState<NewsResponse>> getNews({required NewsRequest request}) {
    return getStateOf<NewsResponse>(
      request: () async {
        String fullUrl =
            "$TopHeadlinesUrl?${request.category != null ? 'category=${request.category}&' : ''}${request.country != null ? 'country=${request.country}&' : ''}${request.sources != null ? 'sources=${request.sources}&' : ''}apiKey=$newsApiKey";
        return await _dio.get(fullUrl);
      },
      fromJson: (json) => NewsResponse.fromJson(json),
    );
  }
}
