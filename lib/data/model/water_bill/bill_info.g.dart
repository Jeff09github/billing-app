// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterBillInfo _$WaterBillInfoFromJson(Map<String, dynamic> json) =>
    WaterBillInfo(
      id: json['id'] as int?,
      customerId: json['customerId'] as int,
      reading: json['reading'] as String,
      bill: WaterBillInfo._waterBillFromString(json['bill'] as String?),
      initial: WaterBillInfo._boolFromInt(json['initial'] as int),
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      dateUpdated: json['dateUpdated'] == null
          ? null
          : DateTime.parse(json['dateUpdated'] as String),
    );

Map<String, dynamic> _$WaterBillInfoToJson(WaterBillInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'reading': instance.reading,
      'bill': WaterBillInfo._waterBilltoString(instance.bill),
      'initial': instance.initial,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'dateUpdated': instance.dateUpdated?.toIso8601String(),
    };
