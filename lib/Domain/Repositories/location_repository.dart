import 'package:flutter_news_app/Domain/Models/location_model.dart';

abstract class LocationRepository {
  Future<LocationModel> getCurrentLocation();
}
