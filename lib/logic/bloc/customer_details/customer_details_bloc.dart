import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/model/model.dart';
import '../../../data/repository/repository.dart';

part 'customer_details_event.dart';
part 'customer_details_state.dart';

class CustomerDetailsBloc
    extends Bloc<CustomerDetailsEvent, CustomerDetailsState> {
  final LocalDatabaseRepository localDatabaseRepository;

  CustomerDetailsBloc({
    required this.localDatabaseRepository,
  }) : super(CustomerDetailsLoading()) {
    on<LoadCustomerDetails>(_onLoadCustomerDetails);
    on<UpdateCustomerDetails>(_onUpdateCustomerDetails);
  }

  FutureOr<void> _onUpdateCustomerDetails(
      UpdateCustomerDetails event, Emitter<CustomerDetailsState> emit) async {
    final state = this.state;
    if (state is CustomerDetailsSuccess) {
      try {
        await localDatabaseRepository.updateCustomerDetails(event.customer);
        emit(CustomerDetailsSuccess(customer: event.customer));
      } catch (_) {
        emit(CustomerDetailsFailure());
      }
    }
  }

  FutureOr<void> _onLoadCustomerDetails(
      LoadCustomerDetails event, Emitter<CustomerDetailsState> emit) {
    print('On Load Customer');
    try {
      emit(CustomerDetailsSuccess(customer: event.customer));
    } catch (_) {
      emit(CustomerDetailsFailure());
    }
  }

  Customer get getCustomerDetails => (state as CustomerDetailsSuccess).customer;
}
