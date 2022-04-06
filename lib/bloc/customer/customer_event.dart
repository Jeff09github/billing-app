part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class LoadCustomerList extends CustomerEvent {
  const LoadCustomerList();

  @override
  List<Object> get props => [];
}

class AddCustomer extends CustomerEvent {
  final Customer customer;

  const AddCustomer({required this.customer});

  @override
  List<Object> get props => [customer];
}
