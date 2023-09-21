part of 'news_bloc.dart';

class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class GetSourcesEvent extends NewsEvent {
  final SourceRequest request;

  const GetSourcesEvent(this.request);
}

class GetAllNewsEvent extends NewsEvent {
  final NewsRequest request;

  const GetAllNewsEvent(this.request);
}

class GetNewsByFilterEvent extends NewsEvent {
  final NewsRequest request;

  const GetNewsByFilterEvent(this.request);
}
