import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maaa/data/model/model.dart';
import 'package:maaa/data/repository/local_database_repository/local_database_repository.dart';
import 'package:maaa/logic/bloc/bloc.dart';

part 'customer_waterbill_history_event.dart';
part 'customer_waterbill_history_state.dart';

class CustomerWaterbillHistoryBloc
    extends Bloc<CustomerWaterbillHistoryEvent, CustomerWaterbillHistoryState> {
  final CustomerBloc customerBloc;
  final LocalDatabaseRepository localDatabaseRepository;
  CustomerWaterbillHistoryBloc(
      {required this.localDatabaseRepository, required this.customerBloc})
      : super(CustomerWaterbillHistoryLoading()) {
    on<LoadWaterBillsInfo>(_onLoadWaterBillsInfo);
    on<AddNewWaterBillInfo>(_onAddNewWaterBillInfo);
    on<CreateNewWaterBill>(_onCreateNewWaterBill);
  }

  FutureOr<void> _onLoadWaterBillsInfo(
      LoadWaterBillsInfo event, Emitter<CustomerWaterbillHistoryState> emit) {
    try {
      emit(CustomerWaterbillHistorySuccess(
          waterbillsInfo: event.waterbillsInfo));
    } catch (_) {
      emit(CustomerWaterbillHistoryFailure());
    }
  }

  FutureOr<void> _onAddNewWaterBillInfo(AddNewWaterBillInfo event,
      Emitter<CustomerWaterbillHistoryState> emit) async {
    final state = this.state;
    if (state is CustomerWaterbillHistorySuccess) {
      emit(CustomerWaterbillHistoryLoading());
      try {
        final newWaterBillInfo = WaterBillInfo(
          customerId: event.customerId,
          reading: event.newReading,
          initial: event.initial,
          dateCreated: DateTime.now(),
        );
        final result =
            await localDatabaseRepository.addWaterBillInfo(newWaterBillInfo);

        final updatedWaterBillsInfo = [...state.waterbillsInfo, result];

        customerBloc.add(UpdateCustomerWaterBillsinfo(
            waterBillsInfo: updatedWaterBillsInfo,
            customerId: event.customerId));
        emit(
          CustomerWaterbillHistorySuccess(
              waterbillsInfo: updatedWaterBillsInfo),
        );
      } catch (_) {
        emit(CustomerWaterbillHistoryFailure());
      }
    }
  }

  FutureOr<void> _onCreateNewWaterBill(CreateNewWaterBill event,
      Emitter<CustomerWaterbillHistoryState> emit) async {
    final state = this.state;
    if (state is CustomerWaterbillHistorySuccess) {
      emit(CustomerWaterbillHistoryLoading());
      try {
        double _balance = 0.0;
        if (!event.previousBillInfo.initial) {
          _balance = event.previousBillInfo.bill!.total;
        }

        final consumption = int.parse(event.currentBillInfo.reading) -
            int.parse(event.previousBillInfo.reading);
        final charges = (consumption * 80).toDouble();
        final total = _balance + charges;

        final waterBill = WaterBill(
          previousReading: event.previousBillInfo.reading,
          currentReading: event.currentBillInfo.reading,
          consumption: consumption,
          balance: _balance,
          charges: charges,
          total: total,
          dueDate: DateTime.now().add(const Duration(days: 3)),
          dateCreated: DateTime.now(),
        );

        List<WaterBillInfo> updateWaterBillsInfo = [];

        for (WaterBillInfo waterBillInfo in state.waterbillsInfo) {
          if (waterBillInfo.id == event.currentBillInfo.id) {
            final updateWaterBillInfo = waterBillInfo.copy(bill: waterBill);

            await localDatabaseRepository
                .updateWaterbillInfo(updateWaterBillInfo);
            updateWaterBillsInfo.add(updateWaterBillInfo);
          } else {
            updateWaterBillsInfo.add(waterBillInfo);
          }
        }

        emit(
          CustomerWaterbillHistorySuccess(waterbillsInfo: updateWaterBillsInfo),
        );
        customerBloc.add(UpdateCustomerWaterBillsinfo(
            waterBillsInfo: updateWaterBillsInfo,
            customerId: event.currentBillInfo.customerId));
      } catch (e) {
        emit(CustomerWaterbillHistoryFailure());
        throw Exception(e);
      }
    }
  }
}
