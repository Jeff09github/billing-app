import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/enum.dart';

import '../resources/color_manager.dart';

class CustomersWaterBillsView extends StatefulWidget {
  const CustomersWaterBillsView({Key? key}) : super(key: key);

  @override
  _CustomersWaterBillsViewState createState() =>
      _CustomersWaterBillsViewState();
}

class _CustomersWaterBillsViewState extends State<CustomersWaterBillsView> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              size: 35.0,
            ),
            onSelected: _onChoiceSelected,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Choose>>[
              _buildPopupMenuItem(
                text: "Add Customer",
                value: Choose.addCustomer,
              ),
              _buildPopupMenuItem(
                text: "Create New Bill",
                value: Choose.createNewBill,
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<Choose> _buildPopupMenuItem({
    required String text,
    required Choose value,
  }) {
    return PopupMenuItem(
      child: Text(text),
      value: value,
      // onTap: onTap,
    );
  }

  void _onChoiceSelected(Choose choose) {
    showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext context) {
        switch (choose) {
          case Choose.addCustomer:
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration:
                            const InputDecoration(labelText: 'Full Name'),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Current CM'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('ADD'),
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          case Choose.createNewBill:
            return Container();
        }
      },
    );
  }
}
