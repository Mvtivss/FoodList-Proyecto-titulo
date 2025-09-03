import 'package:flutter_application_1/domain/entities/location_entity.dart';
import 'package:flutter_application_1/domain/repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<LocationEntity> execute() => repository.getCurrentLocation();
}

class GetLocationStreamUseCase {
  final LocationRepository repository;

  GetLocationStreamUseCase(this.repository);

  Stream<LocationEntity> execute() => repository.getLocationStream();
}

class CheckLocationPermissionUseCase {
  final LocationRepository repository;

  CheckLocationPermissionUseCase(this.repository);

  Future<bool> execute() async {
    bool hasPermission = await repository.hasPermission();
    if (!hasPermission) {
      hasPermission = await repository.requestPermission();
    }
    return hasPermission;
  }
}
