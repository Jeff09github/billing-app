import '../../../presentation/resources/enum.dart';
import '../../model/model.dart';

abstract class BaseLocalDatabaseRepository {
  Future<List<Customer>> getCustomerList({required BillType billType});
  Future<Customer?> addCustomer(Customer customer);
  Future<Customer?> updateCustomerDetails(Customer customer);

  Future<WaterBillInfo> addWaterBillInfo(WaterBillInfo waterBillInfo);
  Future<void> updateWaterbillInfo(WaterBillInfo waterBillInfo);
  Future<List<WaterBillInfo>> getListOfWaterBillInfo(Customer customer);
}
