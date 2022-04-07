import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maaa/presentation/resources/color_manager.dart';
import 'package:maaa/presentation/resources/enum.dart';
import 'package:maaa/presentation/resources/style_manager.dart';

import '../../../data/model/model.dart';
import '../../../logic/bloc/bloc.dart';

class ReadingHistoryView extends StatelessWidget {
  final Customer customer;
  final BillType billType;

  const ReadingHistoryView(
      {Key? key, required this.customer, required this.billType})
      : super(key: key);

  void _onCreateTap({
    required BuildContext context,
    required Customer customer,
    required Reading currentReading,
    required Reading previousReading,
  }) {
    showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure?',
                  style:
                      getBoldStyle(fontSize: 24.0, color: ColorManager.primary),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // await _db.createBill(
                        //   customer: customer,
                        //   currentReading: currentReading,
                        //   previousReading: previousReading,
                        //   billType: BillType.water,
                        // );
                        // setState(() {});
                        // Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CANCEL'),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<ReadingBloc>()
        .add(LoadReadingList(customerId: customer.id!, billType: billType));
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Customer Details',
          style: getBoldStyle(color: Colors.white, fontSize: 36.0),
        ),
      ),
      body: BlocBuilder<ReadingBloc, ReadingState>(
        builder: (context, state) {
          if (state is ReadingLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReadingSuccess) {
            return Padding(
              padding: const EdgeInsets.only(left: 32.0,top: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Name: ${customer.fullName}',
                    style: getBoldStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  Text(
                    'To Pay: ${customer.toPay}.00',
                    style: getBoldStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  SingleChildScrollView(
                    child: DataTable(
                      showCheckboxColumn: false,
                      horizontalMargin: 0.0,
                      columns: <DataColumn>[
                        _buildDataColumn(label: 'Date'),
                        _buildDataColumn(label: 'Reading'),
                        _buildDataColumn(label: 'Billing'),
                      ],
                      rows: List.generate(
                        state.readings.length,
                        (index) => DataRow(
                          cells: <DataCell>[
                            _buildDataCellText(
                              text: DateFormat.yMd()
                                  .format(state.readings[index].createdAt),
                            ),
                            _buildDataCellText(
                              text: state.readings[index].reading,
                            ),
                            index == 0
                                ? _buildDataCellText(text: '')
                                : DataCell(
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'View',
                                        style: getRegularStyle(
                                          fontSize: 18.0,
                                          color: ColorManager.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showModalBottomSheet<void>(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return SingleForm(
          //       label: 'Enter ${widget.customer.fullName} payment amount',
          //       keyboardInputType: TextInputType.number,
          //       validation: Validation().amountValidation,
          //       success: (value) =>
          //           postPayment(amount: value, customer: widget.customer),
          //     );
          //   },
          // );
        },
        child: Icon(
          Icons.post_add,
          color: ColorManager.primary,
        ),
        backgroundColor: ColorManager.secondary,
      ),
    );
  }

  DataColumn _buildDataColumn({required String label}) {
    return DataColumn(
      label: Text(
        label,
        style: getBoldStyle(color: ColorManager.secondary, fontSize: 24.0),
      ),
    );
  }

  DataCell _buildDataCellText({required String text}) {
    return DataCell(
      Text(
        text,
        style: getRegularStyle(color: ColorManager.secondary, fontSize: 18.0),
      ),
    );
  }

  // Future<bool> postPayment(
  //     {required String amount, required Customer customer}) async {
  //   final _result = await _db.postPayment(amount: amount, customer: customer);
  //   return _result != null ? true : false;
  // }
}
