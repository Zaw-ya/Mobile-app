import 'package:json_annotation/json_annotation.dart';

part 'client_confirmation_service_response.g.dart';

@JsonSerializable()
class ClientConfirmationServiceResponse {
  int? totalGuestsNumber;
  int? acceptedGuestsNumber;
  int? declienedGuestsNumber;
  int? noAnswerGuestsNumber;
  int? failedGuestsNumber;
  int? notSentGuestsNumber;
  int? attendedGuestsNumber;

  ClientConfirmationServiceResponse(
      {this.totalGuestsNumber,
      this.acceptedGuestsNumber,
      this.declienedGuestsNumber,
      this.noAnswerGuestsNumber,
      this.failedGuestsNumber,
      this.notSentGuestsNumber,
      this.attendedGuestsNumber});

  factory ClientConfirmationServiceResponse.fromJson(
          Map<String, dynamic> json) =>
      _$ClientConfirmationServiceResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ClientConfirmationServiceResponseToJson(this);
}
