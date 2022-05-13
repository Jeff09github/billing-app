import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bill.g.dart';

const String tableWaterBills = 'waterBills';

class FieldWaterBills {
  static const String previousReading = 'previousReading';
  static const String currentReading = 'currentReading';
  static const String consumption = 'consumption';
  static const String balance = 'balance';
  static const String charges = 'charges';
  static const String total = 'total';
  static const String dueDate = 'dueDate';
  static const String dateCreated = 'dateCreated';
}

@JsonSerializable()
class WaterBill extends Equatable {
  final String previousReading;
  final String currentReading;
  final int consumption; //Actual Consumption
  final double balance; //Balance from previous billing
  final double charges; //Current Charge
  final double total; //Total Amount Due
  final DateTime dueDate;
  final DateTime dateCreated;

  const WaterBill({
    required this.previousReading,
    required this.currentReading,
    required this.consumption,
    required this.balance,
    required this.charges,
    required this.total,
    required this.dueDate,
    required this.dateCreated,
  });

  WaterBill copyWith({
    String? previousReading,
    String? currentReading,
    int? consumption,
    double? balance,
    double? charges,
    double? total,
    DateTime? dueDate,
    DateTime? dateCreated,
  }) =>
      WaterBill(
        previousReading: previousReading ?? this.previousReading,
        currentReading: currentReading ?? this.currentReading,
        consumption: consumption ?? this.consumption,
        balance: balance ?? this.balance,
        charges: charges ?? this.charges,
        total: total ?? this.total,
        dueDate: dueDate ?? this.dueDate,
        dateCreated: dateCreated ?? this.dateCreated,
      );

  factory WaterBill.fromJson(Map<String, dynamic> json) =>
      _$WaterBillFromJson(json);

  Map<String, dynamic> toJson() => _$WaterBillToJson(this);

  @override
  List<Object?> get props => [
        previousReading,
        currentReading,
        consumption,
        balance,
        charges,
        total,
        dueDate,
        dateCreated,
      ];
}
