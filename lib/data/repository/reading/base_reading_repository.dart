import 'package:maaa/presentation/resources/enum.dart';

import '../../model/model.dart';

abstract class BaseReadingRepository {
  Future<List<Reading>> getReadingList(
      {required int customerId, required BillType billType});
  Future<Reading> addReading(Reading reading, Customer customer);
}
