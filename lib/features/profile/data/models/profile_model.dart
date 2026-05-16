import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final int? cityId;
  final int? userId;
  final String? userName;
  final String? email;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final int? totalEventsAssigned;
  final String? address;
  final String? primaryContactNo;
  final int? role;

  ProfileModel({
    this.cityId,
    this.userId,
    this.userName,
    this.email,
    this.gender,
    this.firstName,
    this.lastName,
    this.totalEventsAssigned,
    this.address,
    this.primaryContactNo,
    this.role,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
