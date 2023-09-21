import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app/Data/repositories/location_repository_impl.dart';
import 'package:flutter_news_app/Domain/Models/location_model.dart';
import 'package:flutter_news_app/Domain/Repositories/location_repository.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<GetLocationEvent>((event, emit) async {
      LocationRepository locationRepo = LocationRepositoryImpl();
      emit(LocationLoading());
      try {
        final location = await locationRepo.getCurrentLocation();
        emit(LocationLoaded(location));
      } catch (e) {
        emit(LocationError(e.toString()));
      }
    });
  }
}
