import 'package:equatable/equatable.dart';

class SelectedLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String address;

  const SelectedLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object> get props => [
        latitude,
        longitude,
        address,
      ];
}