// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerResponses _$CustomerResponsesFromJson(Map<String, dynamic> json) =>
    CustomerResponses(
      json['id'] as String,
      json['fullName'] as String,
      json['currentBillAmount'] as int,
      json['currentBillbalance'] as int,
      $enumDecode(_$BillTypeEnumMap, json['billType']),
      json['createdAt'] as String,
      json['updatedAt'] as String,
    );

Map<String, dynamic> _$CustomerResponsesToJson(CustomerResponses instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'currentBillAmount': instance.currentBillAmount,
      'currentBillbalance': instance.currentBillbalance,
      'billType': _$BillTypeEnumMap[instance.billType],
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$BillTypeEnumMap = {
  BillType.water: 'water',
  BillType.electricity: 'electricity',
};
