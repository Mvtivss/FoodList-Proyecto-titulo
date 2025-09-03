import 'package:flutter_application_1/domain/entities/location_entity.dart';

abstract class LocationRepository {
  Future<bool> hasPermission();
  Future<bool> requestPermission();
  Future<LocationEntity> getCurrentLocation();
  Stream<LocationEntity> getLocationStream();
  Future<bool> isServiceEnabled();
  Future<bool> requestService();
}
