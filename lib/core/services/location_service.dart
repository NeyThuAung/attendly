import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import '../../features/attendance/domain/entity/location_entity.dart';
import '../failures/app_failures.dart';
import '../data_state/data_state.dart';

abstract interface class LocationService {
  Future<DataState<GeoLocationEntity>> getCurrentLocation();
}

@LazySingleton(as: LocationService)
class LocationServiceImpl implements LocationService {
  @override
  Future<DataState<GeoLocationEntity>> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Failed(LocationFailure('Location services are disabled on device.'));
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Failed(LocationFailure('Location permissions are denied.'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Failed(LocationFailure('Location permissions are permanently denied.'));
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      String address = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      try {
        List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          address = '${place.street}, ${place.locality}, ${place.country}';
        }
      } catch (_) {
        // Fallback to coordinates string if geocoding fails
      }

      return Success(
        GeoLocationEntity(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        ),
      );
    } catch (e) {
      return Failed(LocationFailure(e.toString()));
    }
  }
}
