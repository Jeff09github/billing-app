import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model.dart';

part 'bill_info.g.dart';

const String tableWaterBillsInfo = 'waterBillsInfo';

class WaterBillsInfoField {
  static const String id = 'id';
  static const String customerId = 'customerId';
  static const String reading = 'reading';
  static const String bill = 'bill';
  static const String initial = 'initial';
  static const String dateCreated = 'dateCreated';
  static const String dateUpdated = 'dateUpdated';
}

@JsonSerializable()
class WaterBillInfo extends Equatable {
  final int? id;
  final int customerId;
  final String reading;

  @JsonKey(fromJson: _waterBillFromString, toJson: _waterBilltoString)
  final WaterBill? bill;

  @JsonKey(fromJson: _boolFromInt)
  final bool initial;

  final DateTime dateCreated;
  final DateTime? dateUpdated;

  const WaterBillInfo({
    this.id,
    required this.customerId,
    required this.reading,
    this.bill,
    required this.initial,
    required this.dateCreated,
    this.dateUpdated,
  });

  WaterBillInfo copy({
    int? id,
    int? customerId,
    String? reading,
    WaterBill? bill,
    bool? initial,
    DateTime? dateCreated,
    DateTime? dateUpdated,
  }) =>
      WaterBillInfo(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        reading: reading ?? this.reading,
        bill: bill ?? this.bill,
        initial: initial ?? this.initial,
        dateCreated: dateCreated ?? this.dateCreated,
        dateUpdated: dateUpdated ?? this.dateUpdated,
      );

  factory WaterBillInfo.fromJson(Map<String, dynamic> json) =>
      _$WaterBillInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WaterBillInfoToJson(this);

  @override
  List<Object?> get props =>
      [id, customerId, reading, bill, initial, dateCreated, dateUpdated];

  static WaterBill? _waterBillFromString(String? s) =>
      s == null ? null : WaterBill.fromJson(json.decode(s));

  static String? _waterBilltoString(WaterBill? waterBill) =>
      waterBill == null ? null : json.encode(waterBill.toJson());

  static bool _boolFromInt(int i) => i == 1 ? true : false;

}
