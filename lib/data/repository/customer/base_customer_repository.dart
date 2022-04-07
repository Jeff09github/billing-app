import '../../../presentation/resources/enum.dart';
import '../../model/model.dart';

abstract class BaseCustomerRepository {
  Future<List<Customer>> getCustomerList({required BillType billType});
  Future<Customer?> addCustomer(Customer customer);
}
