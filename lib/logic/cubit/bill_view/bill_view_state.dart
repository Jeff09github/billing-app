part of 'bill_view_cubit.dart';

abstract class BillViewState extends Equatable {
  const BillViewState();

  @override
  List<Object?> get props => [];
}

class BillViewLoading extends BillViewState {}

class BillViewSuccess extends BillViewState {
  final WaterBill waterBill;
  final Customer customer;
  final List<BluetoothDevice> devices;
  final BluetoothDevice? device;
  final bool enablePrint;

  const BillViewSuccess({
    required this.waterBill,
    required this.customer,
    required this.devices,
    required this.device,
    required this.enablePrint,
  });

  @override
  List<Object?> get props =>
      [waterBill, customer, devices, device, enablePrint];
}

class BillViewFailure extends BillViewState {
  final WaterBill waterBill;
  final String errorMsg;

  const BillViewFailure({required this.waterBill, required this.errorMsg});

  @override
  List<Object?> get props => [waterBill, errorMsg];
}
