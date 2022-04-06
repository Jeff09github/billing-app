import 'package:maaa/data/provider/local_database.dart';
import 'package:maaa/data/repository/reading/base_reading_repository.dart';
import 'package:maaa/presentation/resources/enum.dart';

import '../../model/model.dart';

class ReadingRepository extends BaseReadingRepository {
  final LocalDatabase localDB;

  ReadingRepository({required this.localDB});

  @override
  Future<List<Reading>> getReadingList(
      {required int customerId, required BillType billType}) async {
    final result = await localDB.getReadingList(customerId, billType);
    return result.map((e) => Reading.fromJson(e)).toList();
  }

  @override
  Future<Reading> addReading(
    Reading reading,
    Customer customer,
  ) async {
    final resultId =
        await localDB.addReading(newReading: reading, customer: customer);
    return reading.copy(id: resultId);
  }
}
