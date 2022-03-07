import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

const String tableCustomers = 'customers';

class CustomerField {
  static const String id = 'id';
  static const String fullName = 'fullName';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

@JsonSerializable()
class Customer {
  final int? id;
  final String fullName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Customer({
    this.id,
    required this.fullName,
    required this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  Customer copy({
    int? id,
    String? fullName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Customer(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
