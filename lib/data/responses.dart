import 'package:json_annotation/json_annotation.dart';
import '../presentation/resources/enum.dart';

part 'responses.g.dart';

@JsonSerializable()
class CustomerResponses {
  final String id;
  final String fullName;
  final int currentBillAmount;
  final int currentBillbalance;
  final BillType billType;
  final String createdAt;
  final String updatedAt;

  CustomerResponses(this.id, this.fullName, this.currentBillAmount,
      this.currentBillbalance, this.billType, this.createdAt, this.updatedAt);

  factory CustomerResponses.fromJson(Map<String, dynamic> json) =>
      _$CustomerResponsesFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerResponsesToJson(this);
}
