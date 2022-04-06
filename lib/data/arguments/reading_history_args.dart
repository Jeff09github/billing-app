

import '../../presentation/resources/enum.dart';
import '../model/model.dart';

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
