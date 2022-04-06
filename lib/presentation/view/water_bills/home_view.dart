import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maaa/bloc/customer/customer_bloc.dart';
import 'package:maaa/presentation/resources/color_manager.dart';
import 'package:maaa/presentation/resources/style_manager.dart';
import 'package:maaa/presentation/view/water_bills/customer_list_view.dart';
import 'package:maaa/presentation/widgets/single_form.dart';
import 'package:maaa/resources/validation.dart';

import '../../../data/model/model.dart';

enum FormType { addCustomer, addReading, payment }

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: CustomerAppBar(),
      ),
      body: const CustomerListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isDismissible: false,
            isScrollControlled: true,
            clipBehavior: Clip.hardEdge,
            context: context,
            builder: (context) {
              return SingleTextForm(
                  keyboardInputType: TextInputType.name,
                  label: 'Enter Full Name',
                  validation: Validation().nameValidation,
                  success: (value) {
                    final _customer = Customer(
                        fullName: value, toPay: 0, createdAt: DateTime.now());
                    context.read<CustomerBloc>().add(
                          AddCustomer(customer: _customer),
                        );
                  });
            },
          );
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.person_add_alt_outlined,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  // Future<bool> addReading(
  //     {required String reading, required int customerId}) async {
  //   Reading? _reading;
  //   final _db = MaaaDatabase.instance;
  //   await Future.delayed(const Duration(milliseconds: 1000));
  //   _reading = await _db.addReading(
  //     reading: reading,
  //     billType: BillType.water,
  //     customerId: customerId,
  //   );
  //   if (_reading != null) {
  //     setState(() {});
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // void _onFormSelected(
  //     FormType formType, BuildContext context, Customer? customer) {
  //   late final Future<List<Customer>?> _customers;
  //   _customers = getAllCustomer();
  //   showModalBottomSheet<void>(
  // isDismissible: false,
  // isScrollControlled: true,
  // context: context,
  // clipBehavior: Clip.hardEdge,
  //     builder: (BuildContext context) {
  //       switch (formType) {
  //         case FormType.addCustomer:
  //           return SingleForm(
  //             label: 'Full Name',
  //             keyboardInputType: TextInputType.name,
  //             validation: isTextValid,
  //             success: (value) => addCustomer(fullName: value),
  //           );
  //         case FormType.payment:
  //           return FutureBuilder<List<Customer>?>(
  //               future: _customers,
  //               builder: (context, snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return const LinearProgressIndicator();
  //                 } else {
  //                   return Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       DropdownButtonFormField(
  //                         hint: const Text('Customer Payment Name'),
  //                         items: snapshot.data!
  //                             .map(
  //                               (e) => DropdownMenuItem(
  //                                 child: Text(e.fullName),
  //                                 value: e,
  //                               ),
  //                             )
  //                             .toList(),
  //                         onChanged: (value) {},
  //                       ),
  //                       SingleForm(
  //                         label: 'Amount',
  //                         keyboardInputType: TextInputType.number,
  //                         validation: isTextValid,
  //                         success: (value) => addCustomer(fullName: value),
  //                       ),
  //                     ],
  //                   );
  //                 }
  //               });
  //         case FormType.addReading:
  //           return SingleForm(
  //             label: 'Create New Reading',
  //             keyboardInputType: TextInputType.phone,
  //             validation: isCMValid,
  //             success: (value) =>
  //                 addReading(reading: value, customerId: customer!.id!),
  //           );
  //       }
  //     },
  //   );
  // }

}

class CustomerAppBar extends StatelessWidget {
  const CustomerAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            size: 35.0,
          ),
          // onSelected: (FormType formType) =>
          //     _onFormSelected(formType, context, null),
          itemBuilder: (BuildContext context) => _buildPopupMenuList(),
        ),
      ],
    );
  }

  List<PopupMenuItem<FormType>> _buildPopupMenuList() {
    final popupMenuList = [
      PopupMenuItem(
        child: _getPopupMenuItemText(data: 'Add Customer'),
        value: FormType.addCustomer,
      ),
      PopupMenuItem(
        child: _getPopupMenuItemText(data: 'Payment'),
        value: FormType.payment,
      ),
    ];
    return popupMenuList;
  }

  Text _getPopupMenuItemText({required String data}) {
    return Text(
      data,
      style: getBoldStyle(color: ColorManager.primary, fontSize: 18.0),
    );
  }
}
