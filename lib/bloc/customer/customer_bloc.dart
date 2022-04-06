import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:maaa/data/repository/customer/customer_repository.dart';

import '../../data/model/model.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;
  List<Customer> _customers = [];

  CustomerBloc({required this.customerRepository}) : super(CustomerLoading()) {
    on<LoadCustomerList>(_onLoadCustomerList);
    on<AddCustomer>(_onAddCustomer);
  }

  Future<void> _onLoadCustomerList(
    LoadCustomerList event,
    Emitter<CustomerState> emit,
  ) async {
    if (kDebugMode) {
      print('On LoadCustomerList');
    }
    try {
      emit(CustomerLoading());
      await Future.delayed(const Duration(seconds: 2));
      _customers = await customerRepository.getCustomerList();
      emit(CustomerSuccess(customers: _customers));
    } catch (_) {
      emit(CustomerFailure());
    }
  }

  Future<void> _onAddCustomer(
    AddCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    if (kDebugMode) {
      print('On AddCustomer');
    }
    final state = this.state;
    if (state is CustomerSuccess) {
      emit(CustomerLoading());
      try {
        await Future.delayed(const Duration(seconds: 2));
        final customer = await customerRepository.addCustomer(event.customer);
        emit(CustomerSuccess(customers: [...state.customers, customer!]));
      } catch (_) {
        emit(CustomerFailure());
      }
    }
  }
}
