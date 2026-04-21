import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_response.g.dart';

@JsonSerializable()
class LocationResponse {
  final String cityName;
  final String country;
  final String region;

  LocationResponse({
    required this.cityName,
    required this.country,
    required this.region,
  });

  Map<String, dynamic> toJson() => _$LocationResponseToJson(this);

  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationResponseFromJson(json);

  static List<LocationResponse> fromApiResponse(List<dynamic> response) {
    return response
        .map((location) {
          if (location is String && location.isNotEmpty) {
            // Split by commas and pipes
            final parts = location.split('|');
            if (parts.length == 2) {
              final cityAndRegion = parts[0].split(',');
              final country = parts[1];

              return LocationResponse(
                cityName: cityAndRegion.isNotEmpty ? cityAndRegion[0] : "",
                region: cityAndRegion.length > 1 ? cityAndRegion[1] : "",
                country: country,
              );
            }
          }
          return null;
        })
        .where((location) => location != null)
        .cast<LocationResponse>()
        .toList();
  }
}
