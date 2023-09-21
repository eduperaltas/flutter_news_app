part of 'location_bloc.dart';

class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LocationModel location;

  const LocationLoaded(this.location);
}

class LocationError extends LocationState {
  final String errorMessage;

  const LocationError(this.errorMessage);
}
