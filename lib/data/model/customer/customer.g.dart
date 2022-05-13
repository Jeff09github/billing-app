// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as int?,
      fullName: json['fullName'] as String,
      billType: $enumDecode(_$BillTypeEnumMap, json['billType']),
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      dateUpdated: json['dateUpdated'] == null
          ? null
          : DateTime.parse(json['dateUpdated'] as String),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'billType': _$BillTypeEnumMap[instance.billType],
      'dateCreated': instance.dateCreated.toIso8601String(),
      'dateUpdated': instance.dateUpdated?.toIso8601String(),
    };

const _$BillTypeEnumMap = {
  BillType.water: 'water',
  BillType.electricity: 'electricity',
};
