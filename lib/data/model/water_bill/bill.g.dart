// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterBill _$WaterBillFromJson(Map<String, dynamic> json) => WaterBill(
      previousReading: json['previousReading'] as String,
      currentReading: json['currentReading'] as String,
      consumption: json['consumption'] as int,
      balance: (json['balance'] as num).toDouble(),
      charges: (json['charges'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      dateCreated: DateTime.parse(json['dateCreated'] as String),
    );

Map<String, dynamic> _$WaterBillToJson(WaterBill instance) => <String, dynamic>{
      'previousReading': instance.previousReading,
      'currentReading': instance.currentReading,
      'consumption': instance.consumption,
      'balance': instance.balance,
      'charges': instance.charges,
      'total': instance.total,
      'dueDate': instance.dueDate.toIso8601String(),
      'dateCreated': instance.dateCreated.toIso8601String(),
    };
