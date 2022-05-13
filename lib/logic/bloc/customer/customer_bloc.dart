import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:maaa/data/model/customer_profile.dart';
import 'package:maaa/presentation/resources/enum.dart';

import '../../../data/model/model.dart';
import '../../../data/repository/repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final LocalDatabaseRepository localDatabaseRepository;

  List<CustomerProfile> _customerProfiles = [];

  CustomerBloc({
    required this.localDatabaseRepository,
  }) : super(CustomerLoading()) {
    on<LoadCustomerProfileList>(_onLoadCustomerProfileList);
    on<UpdateCustomerWaterBillsinfo>(_onUpdateCustomerWaterBillsinfo);
    on<AddCustomer>(_onAddCustomer);

    // on<AddReading>(_onAddReading);
  }

  FutureOr<void> _onLoadCustomerProfileList(
    LoadCustomerProfileList event,
    Emitter<CustomerState> emit,
  ) async {
    if (kDebugMode) {
      print('On LoadCustomerProfileList');
    }
    try {
      emit(CustomerLoading());
      _customerProfiles = [];
      await Future.delayed(const Duration(seconds: 2));
      final customers = await localDatabaseRepository.getCustomerList(
          billType: event.billType);

      for (Customer customer in customers) {
        final listOfBillingInfo =
            await localDatabaseRepository.getListOfWaterBillInfo(customer);
        _customerProfiles.add(CustomerProfile(
            customer: customer, waterBillsInfo: listOfBillingInfo));
      }
      emit(
        CustomerSuccess(customerProfiles: _customerProfiles),
      );
    } catch (e) {
      emit(CustomerFailure());
      throw Exception(e);
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
        final newCustomer = Customer(
            fullName: event.name,
            billType: event.billType,
            dateCreated: DateTime.now());
        final customer = await localDatabaseRepository.addCustomer(newCustomer);
        final newCustomerProfile =
            CustomerProfile(customer: customer!, waterBillsInfo: []);
        emit(CustomerSuccess(
            customerProfiles: [...state.customerProfiles, newCustomerProfile]));
      } catch (_) {
        emit(CustomerFailure());
      }
    }
  }

  FutureOr<void> _onUpdateCustomerWaterBillsinfo(
    UpdateCustomerWaterBillsinfo event,
    Emitter<CustomerState> emit,
  ) async {
    final state = this.state;
    if (state is CustomerSuccess) {
      print('On UpdateCustomerWaterBillsInfo');
      emit(CustomerLoading());
      try {
        List<CustomerProfile> _customerProfiles = [];
        for (CustomerProfile customerProfile in state.customerProfiles) {
          if (customerProfile.customer.id == event.customerId) {
            _customerProfiles.add(
                customerProfile.copyWith(waterBillsInfo: event.waterBillsInfo));
          } else {
            _customerProfiles.add(customerProfile);
          }
        }
        emit(CustomerSuccess(customerProfiles: _customerProfiles));
      } catch (e) {
        emit(CustomerFailure());
      }
    }
  }
}
