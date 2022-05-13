part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerLoading extends CustomerState {}

class CustomerSuccess extends CustomerState {
  final List<CustomerProfile> customerProfiles;

  const CustomerSuccess({
    required this.customerProfiles,
  });

  @override
  List<Object> get props => [customerProfiles];
}

class CustomerFailure extends CustomerState {}
