part of 'news_bloc.dart';

class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final NewsResponse news;

  const NewsLoaded(this.news);
}

class NewsError extends NewsState {
  final String errorMessage;

  const NewsError(this.errorMessage);
}

class SourceInitial extends NewsState {}

class SourceLoading extends NewsState {}

class SourceLoaded extends NewsState {
  final SourceResponse sources;

  const SourceLoaded(this.sources);
}

class SourceError extends NewsState {
  final String errorMessage;

  const SourceError(this.errorMessage);
}
