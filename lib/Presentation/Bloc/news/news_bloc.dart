import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app/Core/utils/resource/data_state.dart';
import 'package:flutter_news_app/Data/repositories/news_repository_impl.dart';
import 'package:flutter_news_app/Domain/Models/news/news_request.dart';
import 'package:flutter_news_app/Domain/Models/news/news_response.dart';
import 'package:flutter_news_app/Domain/Models/news/source_request.dart';
import 'package:flutter_news_app/Domain/Models/news/source_response.dart';
import 'package:flutter_news_app/Domain/Repositories/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsRepository newsRepo = NewsRepositoryImpl();

  NewsBloc() : super(NewsInitial()) {
    on<GetSourcesEvent>((event, emit) async {
      emit(SourceLoading());
      final response = await newsRepo.getSources(request: event.request);
      if (response is DataSuccess) {
        final weather = response.data;
        emit(SourceLoaded(weather!));
      } else {
        emit(SourceError(response.toString()));
      }
    });
    on<GetNewsByFilterEvent>((event, emit) async {
      emit(NewsLoading());
      final response = await newsRepo.getNews(request: event.request);
      if (response is DataSuccess) {
        final weather = response.data;
        emit(NewsLoaded(weather!));
      } else {
        emit(NewsError(response.toString()));
      }
    });
    on<GetAllNewsEvent>((event, emit) async {
      emit(NewsLoading());
      final response = await newsRepo.getNews(request: event.request);
      if (response is DataSuccess) {
        final weather = response.data;
        emit(NewsLoaded(weather!));
      } else {
        emit(NewsError(response.toString()));
      }
    });
  }
}
