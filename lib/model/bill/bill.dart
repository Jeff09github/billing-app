import 'package:json_annotation/json_annotation.dart';
import 'package:maaa/presentation/resources/enum.dart';

part 'bill.g.dart';

@JsonSerializable()
class Bill {
  String id;
  String customerId;
  BillType type;
  int currentReading;
  int previousReading;
  int consumeCM;
  int billAmount;
  int previousbalance;
  int totalAmount;
  DateTime createdAt;
  DateTime updatedAt;

  Bill(
    this.id,
    this.customerId,
    this.type,
    this.currentReading,
    this.previousReading,
    this.consumeCM,
    this.billAmount,
    this.previousbalance,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
  );

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  Map<String, dynamic> toJson() => _$BillToJson(this);
}
