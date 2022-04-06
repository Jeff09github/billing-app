// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reading _$ReadingFromJson(Map<String, dynamic> json) => Reading(
      id: json['id'] as int?,
      customerId: json['customerId'] as int,
      reading: json['reading'] as String,
      billType: $enumDecode(_$BillTypeEnumMap, json['billType']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReadingToJson(Reading instance) => <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'reading': instance.reading,
      'billType': _$BillTypeEnumMap[instance.billType],
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$BillTypeEnumMap = {
  BillType.water: 'water',
  BillType.electricity: 'electricity',
};
