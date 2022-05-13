import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:maaa/presentation/resources/enum.dart';

part 'customer.g.dart';

const String tableCustomers = 'customers';

class CustomerField {
  static const String id = 'id';
  static const String fullName = 'fullName';
  static const String billType = 'billType';
  static const String createdAt = 'dateCreated';
  static const String updatedAt = 'dateUpdated';
}

@JsonSerializable()
class Customer extends Equatable {
  final int? id;
  final String fullName;
  final BillType billType;
  final DateTime dateCreated;
  final DateTime? dateUpdated;

  const Customer({
    this.id,
    required this.fullName,
    required this.billType,
    required this.dateCreated,
    this.dateUpdated,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  Customer copy({
    int? id,
    String? fullName,
    BillType? billType,
    DateTime? dateCreated,
    DateTime? dateUpdated,
  }) =>
      Customer(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        billType: billType ?? this.billType,
        dateCreated: dateCreated ?? this.dateCreated,
        dateUpdated: dateUpdated ?? this.dateUpdated,
      );

  @override
  List<Object?> get props => [
        id,
        fullName,
        billType,
        dateCreated,
        dateUpdated,
      ];
}
