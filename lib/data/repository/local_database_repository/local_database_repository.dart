import 'package:maaa/presentation/resources/enum.dart';

import '../../model/model.dart';
import '../../provider/local_database.dart';
import 'base_local_database_repository.dart';

class LocalDatabaseRepository extends BaseLocalDatabaseRepository {
  final LocalDatabase localDB;
  LocalDatabaseRepository({required this.localDB});

  @override
  Future<Customer?> addCustomer(Customer customer) async {
    final result = await localDB.addCustomer(customer: customer);
    return customer.copy(id: result);
  }

  @override
  Future<Customer?> updateCustomerDetails(Customer customer) {
    // TODO: implement updateCustomerDetails
    throw UnimplementedError();
  }

  @override
  Future<List<Customer>> getCustomerList({required BillType billType}) async {
    final _result = await localDB.getCustomerList(billType: billType);
    return _result.map((e) => Customer.fromJson(e)).toList();
  }

  @override
  Future<WaterBillInfo> addWaterBillInfo(WaterBillInfo waterBillInfo) async {
    final result = await localDB.addWaterBillInfo(waterBillInfo: waterBillInfo);
    return waterBillInfo.copy(id: result);
  }

  @override
  Future<void> updateWaterbillInfo(WaterBillInfo waterBillInfo) async {
    await localDB.updateWaterBillInfo(waterBillInfo: waterBillInfo);
  }

  @override
  Future<List<WaterBillInfo>> getListOfWaterBillInfo(Customer customer) async {
    final result = await localDB.getListOfWaterBillInfo(customer: customer);
    return result.map((e) => WaterBillInfo.fromJson(e)).toList();
  }
}
