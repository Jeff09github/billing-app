import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

const String tablePayments = 'payments';

class PaymentField {
  static const String id = 'id';
  static const String customerId = 'customerId';
  static const String amount = 'amount';
  static const String note = 'note';
  static const String createdAt = 'createdAt';
}

@JsonSerializable()
class Payment extends Equatable {
  int? id;
  final int customerId;
  final int amount;
  final String note;
  final String createdAt;

  Payment(
      {this.id,
      required this.customerId,
      required this.amount,
      required this.note,
      required this.createdAt});

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  Payment copy({
    int? id,
    int? customerId,
    int? amount,
    String? note,
    String? createdAt,
  }) =>
      Payment(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        amount: amount ?? this.amount,
        note: note ?? this.note,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        customerId,
        amount,
        note,
        createdAt,
      ];
}
