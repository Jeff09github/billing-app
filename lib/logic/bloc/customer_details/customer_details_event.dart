part of 'customer_details_bloc.dart';

abstract class CustomerDetailsEvent extends Equatable {
  const CustomerDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadCustomerDetails extends CustomerDetailsEvent {
  final Customer customer;

  const LoadCustomerDetails({required this.customer});

  @override
  List<Object> get props => [customer];
}

class UpdateCustomerDetails extends CustomerDetailsEvent {
  final Customer customer;

  const UpdateCustomerDetails({required this.customer});

  @override
  List<Object> get props => [customer];
}

