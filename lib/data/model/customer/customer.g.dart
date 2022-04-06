// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as int?,
      fullName: json['fullName'] as String,
      previousReading: json['previousReading'] as String?,
      currentReading: json['currentReading'] as String?,
      toPay: json['toPay'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'previousReading': instance.previousReading,
      'currentReading': instance.currentReading,
      'toPay': instance.toPay,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
