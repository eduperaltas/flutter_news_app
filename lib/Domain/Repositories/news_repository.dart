import 'package:flutter_news_app/Core/utils/resource/data_state.dart';
import 'package:flutter_news_app/Domain/Models/news/news_request.dart';
import 'package:flutter_news_app/Domain/Models/news/news_response.dart';
import 'package:flutter_news_app/Domain/Models/news/source_request.dart';
import 'package:flutter_news_app/Domain/Models/news/source_response.dart';

abstract class NewsRepository {
  Future<DataState<SourceResponse>> getSources({
    required SourceRequest request,
  });

  Future<DataState<NewsResponse>> getNews({
    required NewsRequest request,
  });
}
