import 'dart:async';
import 'package:flutter_application_1/domain/entities/location_entity.dart';
import 'package:flutter_application_1/domain/repositories/location_repository.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  final LocationRepository _repository;
  StreamSubscription? _locationSubscription;
  LocationEntity? _currentLocation;
  bool _isLoading = false;
  String? _error;

  LocationProvider(this._repository);

  LocationEntity? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  LatLng? get currentLatLng => _currentLocation != null ? LatLng(_currentLocation!.latitude, _currentLocation!.longitude) : null;

  Future<void> initializeLocation() async {
    try {
      _isLoading = true;
      notifyListeners();

      bool hasPermission = await _repository.hasPermission();
      if (!hasPermission) {
        hasPermission = await _repository.requestPermission();
        if (!hasPermission) {
          _error = 'Location permission denied';
          notifyListeners();
          return;
        }
      }

      _currentLocation = await _repository.getCurrentLocation();
      _startLocationUpdates();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = _repository.getLocationStream().listen(
      (location) {
        _currentLocation = location;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
