class LocationEntity {
  final double latitude;
  final double longitude;
  final double accuracy;
  final double speed;
  final double altitude;

  LocationEntity({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.speed,
    required this.altitude,
  });
}