import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_body_request.g.dart';

@JsonSerializable()
class ScanBodyRequest {
  @JsonKey(name: "qRcode")
  final String qrCode;
  final int eventId;

  ScanBodyRequest({required this.qrCode, required this.eventId});

  Map<String, dynamic> toJson() => _$ScanBodyRequestToJson(this);

  factory ScanBodyRequest.fromJson(Map<String, dynamic> json) =>
      _$ScanBodyRequestFromJson(json);
}
