part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerLoading extends CustomerState {}

class CustomerSuccess extends CustomerState {
  final List<Customer> customers;

  const CustomerSuccess({required this.customers});

  @override
  List<Object> get props => [customers];
}

class CustomerFailure extends CustomerState {}
