import 'package:flutter_news_app/Domain/Models/location_model.dart';
import 'package:flutter_news_app/Domain/Repositories/location_repository.dart';
import 'package:geolocator/geolocator.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<LocationModel> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition();
      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      throw Exception("Failed to get current location: $e");
    }
  }
}
