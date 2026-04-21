import 'package:json_annotation/json_annotation.dart';
part 'success_response.g.dart';

@JsonSerializable()
class SuccessResponse {
  String? description;

  SuccessResponse({this.description});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$SuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessResponseToJson(this);
}
