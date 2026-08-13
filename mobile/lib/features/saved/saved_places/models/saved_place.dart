import 'package:equatable/equatable.dart';

import 'place_icon_type.dart';

/// ===============================================================
/// Saved Place Model
/// ---------------------------------------------------------------
/// Represents a location saved by the user.
///
/// This model is shared between:
///
/// • Local Repository
/// • FastAPI Backend
/// • PostgreSQL Database
/// • Riverpod Provider
/// • UI
///
/// ===============================================================

class SavedPlace extends Equatable {
  /// Unique identifier.
  final String id;

  /// Custom name given by the user.
  final String name;

  /// Complete formatted address.
  final String address;

  /// Latitude.
  final double latitude;

  /// Longitude.
  final double longitude;

  /// Selected icon.
  final PlaceIconType icon;

  /// Creation time.
  final DateTime createdAt;

  /// Last updated time.
  final DateTime updatedAt;

  const SavedPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Returns a copy with updated values.
  SavedPlace copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    PlaceIconType? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavedPlace(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Serialize to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'icon': icon.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Deserialize from JSON.
  factory SavedPlace.fromJson(Map<String, dynamic> json) {
    return SavedPlace(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      icon: PlaceIconTypeExtension.fromString(
        json['icon'] as String,
      ),
      createdAt: DateTime.parse(
        json['created_at'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] as String,
      ),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        icon,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'SavedPlace('
        'id: $id, '
        'name: $name, '
        'address: $address, '
        'latitude: $latitude, '
        'longitude: $longitude, '
        'icon: ${icon.value}'
        ')';
  }
}