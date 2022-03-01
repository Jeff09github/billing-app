import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

const String tableCustomers = 'customers';

class CustomerField {
  static const String id = '_id';
  static const String fullName = 'fullName';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

@JsonSerializable()
class Customer {
  int id;
  String fullName;
  DateTime createdAt;
  DateTime updatedAt;

  Customer(
    this.id,
    this.fullName,
    this.createdAt,
    this.updatedAt,
  );

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
