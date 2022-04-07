import 'package:maaa/data/provider/local_database.dart';
import 'package:maaa/data/repository/customer/base_customer_repository.dart';
import 'package:maaa/presentation/resources/enum.dart';

import '../../model/model.dart';

class CustomerRepository extends BaseCustomerRepository {
  final LocalDatabase localDB;

  CustomerRepository({required this.localDB});

  @override
  Future<List<Customer>> getCustomerList({required BillType billType}) async {
    final _result = await localDB.getCustomerList(billType: billType);
    print(_result);
    return _result.map((e) => Customer.fromJson(e)).toList();
  }

  @override
  Future<Customer?> addCustomer(Customer customer) async {
    return await localDB.addCustomer(customer: customer);
  }
}
