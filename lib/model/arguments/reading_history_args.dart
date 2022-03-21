import 'package:maaa/model/bill/bill.dart';
import 'package:maaa/model/customer/customer.dart';
import 'package:maaa/presentation/resources/enum.dart';

class ReadingHistoryArgs {
  final Customer customer;
  final BillType billType;

  ReadingHistoryArgs({required this.customer, required this.billType});
}

class BillArgs {
  final Bill bill;
  final Customer customer;

  BillArgs({required this.bill, required this.customer});
}
