part of 'customer_details_bloc.dart';

abstract class CustomerDetailsState extends Equatable {
  const CustomerDetailsState();

  @override
  List<Object> get props => [];
}

class CustomerDetailsLoading extends CustomerDetailsState {}

class CustomerDetailsSuccess extends CustomerDetailsState {
  final Customer customer;

  const CustomerDetailsSuccess({required this.customer});
  @override
  List<Object> get props => [customer];
}

class CustomerDetailsFailure extends CustomerDetailsState {}
