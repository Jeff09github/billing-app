// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) => Bill(
      id: json['id'] as int?,
      customerId: json['customerId'] as int,
      readingId: json['readingId'] as int,
      type: $enumDecode(_$BillTypeEnumMap, json['type']),
      currentReading: json['currentReading'] as String,
      previousReading: json['previousReading'] as String,
      consumeCM: json['consumeCM'] as int,
      billAmount: json['billAmount'] as int,
      previousbalance: json['previousbalance'] as int,
      totalAmount: json['totalAmount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'readingId': instance.readingId,
      'type': _$BillTypeEnumMap[instance.type],
      'currentReading': instance.currentReading,
      'previousReading': instance.previousReading,
      'consumeCM': instance.consumeCM,
      'billAmount': instance.billAmount,
      'previousbalance': instance.previousbalance,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$BillTypeEnumMap = {
  BillType.water: 'water',
  BillType.electricity: 'electricity',
};
