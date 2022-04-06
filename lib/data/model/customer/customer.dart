import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

const String tableCustomers = 'customers';

class CustomerField {
  static const String id = 'id';
  static const String fullName = 'fullName';
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
  final String? previousReading;
  final String? currentReading;
  final int toPay;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Customer({
    this.id,
    required this.fullName,
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
    String? previousReading,
    String? currentReading,
    int? toPay,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Customer(
        id: id ?? this.id,
        previousReading: previousReading ?? this.previousReading,
        currentReading: currentReading ?? this.currentReading,
        fullName: fullName ?? this.fullName,
        toPay: toPay ?? this.toPay,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id,
        fullName,
        previousReading,
        currentReading,
        toPay,
        createdAt,
        updatedAt,
      ];
}
