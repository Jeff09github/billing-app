import 'package:maaa/model/customer/customer.dart';
import 'package:maaa/presentation/resources/enum.dart';

class ReadingHistoryArgs {
  final Customer customer;
  final BillType billType;

  ReadingHistoryArgs(this.customer, this.billType);
}
