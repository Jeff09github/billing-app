import 'package:json_annotation/json_annotation.dart';
import 'package:maaa/presentation/resources/enum.dart';

part 'bill.g.dart';

const String tableBills = 'bills';

class BillField {
  static const String id = 'id';
  static const String customerId = 'customerId';
  static const String readingId = 'readingId';
  static const String type = 'type';
  static const String currentReading = 'currentReading';
  static const String previousReading = 'previousReading';
  static const String consumeCM = 'consumeCM';
  static const String billAmount = 'billAmount';
  static const String previousbalance = 'previousbalance';
  static const String totalAmount = 'totalAmount';
  static const String createdAt = 'createdAt';
}

@JsonSerializable()
class Bill {
  int? id;
  int customerId;
  int readingId;
  BillType type;
  int currentReading;
  int previousReading;
  int consumeCM;
  int billAmount;
  int previousbalance;
  int totalAmount;
  DateTime createdAt;

  Bill({
    this.id,
    required this.customerId,
    required this.readingId,
    required this.type,
    required this.currentReading,
    required this.previousReading,
    required this.consumeCM,
    required this.billAmount,
    required this.previousbalance,
    required this.totalAmount,
    required this.createdAt,}
  );

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  Map<String, dynamic> toJson() => _$BillToJson(this);
}
