import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_response.g.dart';

@JsonSerializable()
class CityResponse {
  final int id;
  final String cityName;

  CityResponse({required this.id, required this.cityName});

  factory CityResponse.fromJson(Map<String, dynamic> json) =>
      _$CityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CityResponseToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityResponse &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cityName == other.cityName;

  @override
  int get hashCode => id.hashCode ^ cityName.hashCode;
}
