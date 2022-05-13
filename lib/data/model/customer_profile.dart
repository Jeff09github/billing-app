import 'package:equatable/equatable.dart';
import 'package:maaa/data/model/model.dart';

class CustomerProfile extends Equatable {
  final Customer customer;
  final List<WaterBillInfo> waterBillsInfo;

  const CustomerProfile({required this.customer, required this.waterBillsInfo});

  CustomerProfile copyWith({
    Customer? customer,
    List<WaterBillInfo>? waterBillsInfo,
  }) =>
      CustomerProfile(
        customer: customer ?? this.customer,
        waterBillsInfo: waterBillsInfo ?? this.waterBillsInfo,
      );

  @override
  List<Object?> get props => [customer, waterBillsInfo];
}
