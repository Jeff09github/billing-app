part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class LoadCustomerProfileList extends CustomerEvent {
  final BillType billType;

  const LoadCustomerProfileList({this.billType = BillType.water});

  @override
  List<Object> get props => [billType];
}

class UpdateCustomerWaterBillsinfo extends CustomerEvent {
  final List<WaterBillInfo> waterBillsInfo;
  final int customerId;

  const UpdateCustomerWaterBillsinfo(
      {required this.waterBillsInfo, required this.customerId});

  @override
  List<Object> get props => [waterBillsInfo, customerId];
}

class AddCustomer extends CustomerEvent {
  final String name;
  final BillType billType;

  const AddCustomer({required this.name, required this.billType});

  @override
  List<Object> get props => [name, billType];
}

// class AddReading extends CustomerEvent {
//   final Reading reading;
//   final Customer customer;

//   const AddReading({
//     required this.reading,
//     required this.customer,
//   });

//   @override
//   List<Object> get props => [reading, customer];
// }
