// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      cityId: (json['cityId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      password: json['password'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      address: json['address'] as String?,
      primaryContactNo: json['primaryContactNo'] as String?,
      createdOn: json['createdOn'] as String?,
      createdBy: (json['createdBy'] as num?)?.toInt(),
      isActive: json['isActive'] as bool?,
      role: (json['role'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'cityId': instance.cityId,
      'userId': instance.userId,
      'userName': instance.userName,
      'password': instance.password,
      'email': instance.email,
      'gender': instance.gender,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'address': instance.address,
      'primaryContactNo': instance.primaryContactNo,
      'createdOn': instance.createdOn,
      'createdBy': instance.createdBy,
      'isActive': instance.isActive,
      'role': instance.role,
    };
