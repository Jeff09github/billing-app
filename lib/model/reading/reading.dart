import 'package:json_annotation/json_annotation.dart';
import 'package:maaa/presentation/resources/enum.dart';

part 'reading.g.dart';

const String tableReadings = 'readings';

class ReadingField {
  static const String id = 'id';
  static const String customerId = 'customerId';
  static const String reading = 'reading';
  static const String billType = 'billType';
  static const String createdAt = 'createdAt';
}

@JsonSerializable()
class Reading {
  int? id;
  final int customerId;
  final int reading;
  final BillType billType;
  final DateTime createdAt;

  Reading({
    this.id,
    required this.customerId,
    required this.reading,
    required this.billType,
    required this.createdAt,
  });

  factory Reading.fromJson(Map<String, dynamic> json) =>
      _$ReadingFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingToJson(this);

  Reading copy(
          {int? id,
          int? customerId,
          int? reading,
          BillType? billType,
          DateTime? createdAt}) =>
      Reading(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        reading: reading ?? this.reading,
        billType: billType ?? this.billType,
        createdAt: createdAt ?? this.createdAt,
      );
}
