part of 'customer_waterbill_history_bloc.dart';

abstract class CustomerWaterbillHistoryEvent extends Equatable {
  const CustomerWaterbillHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadWaterBillsInfo extends CustomerWaterbillHistoryEvent {
  final List<WaterBillInfo> waterbillsInfo;

  const LoadWaterBillsInfo({required this.waterbillsInfo});

  @override
  List<Object> get props => [waterbillsInfo];
}

class AddNewWaterBillInfo extends CustomerWaterbillHistoryEvent {
  final int customerId;
  final String newReading;
  final bool initial;

  const AddNewWaterBillInfo(
      {required this.customerId,
      required this.newReading,
      required this.initial});

  @override
  List<Object> get props => [customerId, newReading, initial];
}

class CreateNewWaterBill extends CustomerWaterbillHistoryEvent {
  final WaterBillInfo currentBillInfo;
  final WaterBillInfo previousBillInfo;

  const CreateNewWaterBill(
      {required this.currentBillInfo, required this.previousBillInfo});

  @override
  List<Object> get props => [currentBillInfo, previousBillInfo];
}
