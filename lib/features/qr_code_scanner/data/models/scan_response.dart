import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_response.g.dart';

@JsonSerializable()
class ScanResponse {
  final String? message;
  final String? name;
  final int? no;
  final String? eventName;
  final int? scanned;

  ScanResponse(
      {this.name, this.message, this.no, this.eventName, this.scanned});

  Map<String, dynamic> toJson() => _$ScanResponseToJson(this);

  factory ScanResponse.fromJson(Map<String, dynamic> json) =>
      _$ScanResponseFromJson(json);
}
