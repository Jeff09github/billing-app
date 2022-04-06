


import '../../model/model.dart';

abstract class BaseCustomerRepository{
  Future<List<Customer>> getCustomerList();
  Future<Customer?> addCustomer(Customer customer);
}