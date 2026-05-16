// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      cityId: (json['cityId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      totalEventsAssigned: (json['totalEventsAssigned'] as num?)?.toInt(),
      address: json['address'] as String?,
      primaryContactNo: json['primaryContactNo'] as String?,
      role: (json['role'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'cityId': instance.cityId,
      'userId': instance.userId,
      'userName': instance.userName,
      'email': instance.email,
      'gender': instance.gender,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'totalEventsAssigned': instance.totalEventsAssigned,
      'address': instance.address,
      'primaryContactNo': instance.primaryContactNo,
      'role': instance.role,
    };
