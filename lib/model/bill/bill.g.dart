// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) => Bill(
      json['id'] as String,
      json['customerId'] as String,
      $enumDecode(_$BillTypeEnumMap, json['type']),
      json['currentReading'] as int,
      json['previousReading'] as int,
      json['consumeCM'] as int,
      json['billAmount'] as int,
      json['previousbalance'] as int,
      json['totalAmount'] as int,
      DateTime.parse(json['createdAt'] as String),
      DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'type': _$BillTypeEnumMap[instance.type],
      'currentReading': instance.currentReading,
      'previousReading': instance.previousReading,
      'consumeCM': instance.consumeCM,
      'billAmount': instance.billAmount,
      'previousbalance': instance.previousbalance,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$BillTypeEnumMap = {
  BillType.water: 'water',
  BillType.electricity: 'electricity',
};
