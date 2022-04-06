// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: json['id'] as int?,
      customerId: json['customerId'] as int,
      amount: json['amount'] as int,
      note: json['note'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'amount': instance.amount,
      'note': instance.note,
      'createdAt': instance.createdAt,
    };
