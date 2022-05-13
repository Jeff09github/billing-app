part of 'customer_waterbill_history_bloc.dart';

abstract class CustomerWaterbillHistoryState extends Equatable {
  const CustomerWaterbillHistoryState();

  @override
  List<Object> get props => [];
}

class CustomerWaterbillHistoryLoading extends CustomerWaterbillHistoryState {}

class CustomerWaterbillHistorySuccess extends CustomerWaterbillHistoryState {
  final List<WaterBillInfo> waterbillsInfo;

  const CustomerWaterbillHistorySuccess({required this.waterbillsInfo});

  @override
  List<Object> get props => [waterbillsInfo];
}

class CustomerWaterbillHistoryFailure extends CustomerWaterbillHistoryState {}
