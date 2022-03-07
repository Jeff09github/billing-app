import 'package:json_annotation/json_annotation.dart';
import 'package:maaa/presentation/resources/enum.dart';

part 'bill.g.dart';

const String tableBills = 'bills';

class BillField {
  static const String id = 'id';
  static const String customerId = 'customerId';
  static const String type = 'type';
  static const String currentReading = 'currentReading';
  static const String previousReading = 'previousReading';
  static const String consumeCM = 'consumeCM';
  static const String billAmount = 'billAmount';
  static const String previousbalance = 'previousbalance';
  static const String totalAmount = 'totalAmount';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

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
