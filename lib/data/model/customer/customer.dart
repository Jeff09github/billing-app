import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:maaa/presentation/resources/enum.dart';

part 'customer.g.dart';

const String tableCustomers = 'customers';

class CustomerField {
  static const String id = 'id';
  static const String fullName = 'fullName';
  static const String billType = 'billType';
  static const String previousReading = 'previousReading';
  static const String currentReading = 'currentReading';
  static const String toPay = 'toPay';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

@JsonSerializable()
class Customer extends Equatable {
  final int? id;
  final String fullName;
  final BillType billType;
  final String? previousReading;
  final String? currentReading;
  final int toPay;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Customer({
    this.id,
    required this.fullName,
    required this.billType,
    this.previousReading,
    this.currentReading,
    required this.toPay,
    required this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  Customer copy({
    int? id,
    String? fullName,
    BillType? billType,
    String? previousReading,
    String? currentReading,
    int? toPay,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Customer(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        billType: billType ?? this.billType,
        previousReading: previousReading ?? this.previousReading,
        currentReading: currentReading ?? this.currentReading,
        toPay: toPay ?? this.toPay,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id,
        fullName,
        billType,
        previousReading,
        currentReading,
        toPay,
        createdAt,
        updatedAt,
      ];
}
