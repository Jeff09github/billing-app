import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maaa/logic/bloc/bloc.dart';
import 'package:maaa/logic/cubit/cubit.dart';
import 'package:maaa/presentation/resources/route_manager.dart';

import '../../../data/model/model.dart';
import '../../../resources/validation.dart';
import '../../resources/color_manager.dart';
import '../../resources/style_manager.dart';
import '../../widgets/single_form.dart';

class BillingHistory extends StatefulWidget {
  const BillingHistory({Key? key}) : super(key: key);

  @override
  State<BillingHistory> createState() => _BillingHistoryState();
}

class _BillingHistoryState extends State<BillingHistory>
    with AutomaticKeepAliveClientMixin {
  DataColumn _buildDataColumn({required String label}) {
    return DataColumn(
      label: Text(
        label,
        maxLines: 2,
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

  @override
  Widget build(BuildContext context) {
    super.build;
    return BlocBuilder<CustomerWaterbillHistoryBloc,
        CustomerWaterbillHistoryState>(
      builder: (context, state) {
        if (state is CustomerWaterbillHistoryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CustomerWaterbillHistorySuccess) {
          return Scaffold(
            backgroundColor: ColorManager.primary,
            body: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Scrollbar(
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: DataTable(
                      showCheckboxColumn: false,
                      columnSpacing: 10.0,
                      horizontalMargin: 0.0,
                      columns: <DataColumn>[
                        _buildDataColumn(label: 'Date'),
                        _buildDataColumn(label: 'Reading'),
                        _buildDataColumn(label: 'Bill'),
                      ],
                      rows: List.generate(state.waterbillsInfo.length, (index) {
                        return DataRow(
                          cells: <DataCell>[
                            _buildDataCellText(
                              text: DateFormat.yMd().format(
                                  state.waterbillsInfo[index].dateCreated),
                            ),
                            _buildDataCellText(
                              text: state.waterbillsInfo[index].reading,
                            ),
                            index == 0
                                ? _buildEmptyDataCell()
                                : _buildButtonDataCell(
                                    canDelete:
                                        state.waterbillsInfo.length - 1 == index
                                            ? true
                                            : false,
                                    currentWaterBillInfo:
                                        state.waterbillsInfo[index],
                                    previousWaterBillInfo:
                                        state.waterbillsInfo[index - 1],
                                  )
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.post_add_outlined,
                size: 35.0,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                showModalBottomSheet(
                  isDismissible: false,
                  isScrollControlled: true,
                  clipBehavior: Clip.hardEdge,
                  context: context,
                  builder: (context) {
                    return SingleTextForm(
                      keyboardInputType: TextInputType.number,
                      label: 'Enter New Reading',
                      validation: Validation().readingValidation,
                      success: (value) {
                        context.read<CustomerWaterbillHistoryBloc>().add(
                            AddNewWaterBillInfo(
                                customerId: context
                                    .read<CustomerDetailsBloc>()
                                    .getCustomerDetails
                                    .id!,
                                newReading: value,
                                initial: state.waterbillsInfo.isEmpty
                                    ? true
                                    : false));
                      },
                    );
                  },
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _showCreateBillModalSheet({
    required BuildContext context,
  }) {
    showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (_) {
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
                      getBoldStyle(fontSize : 24.0, color: ColorManager.primary),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
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

  DataCell _buildEmptyDataCell() {
    print('empty');
    return const DataCell(SizedBox());
  }

  DataCell _buildButtonDataCell({
    required WaterBillInfo currentWaterBillInfo,
    required WaterBillInfo previousWaterBillInfo,
    required bool canDelete,
  }) {
    if (currentWaterBillInfo.bill == null) {
      List<Widget> widgets = [];

      if (previousWaterBillInfo.bill != null || previousWaterBillInfo.initial) {
        widgets.add(
          customTextButton(
            text: 'Create',
            onPressed: () {
              context.read<CustomerWaterbillHistoryBloc>().add(
                    CreateNewWaterBill(
                      currentBillInfo: currentWaterBillInfo,
                      previousBillInfo: previousWaterBillInfo,
                    ),
                  );
            },
          ),
        );
      }

      if (canDelete) {
        widgets.add(const SizedBox(
          width: 8.0,
        ));
        widgets.add(
          OutlinedButton(
            onPressed: () {
              print('delete');
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(width: 2, color: Colors.white),
            ),
            child: Text(
              'Delete',
              style: getRegularStyle(
                fontSize: 12.0,
                color: ColorManager.secondary,
              ),
            ),
          ),
        );
      }

      return DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [...widgets],
          ),
        ),
      );
    } else {
      return DataCell(
        customTextButton(
          text: 'View',
          onPressed: () {
            context.read<BillViewCubit>().loadData(currentWaterBillInfo.bill!);
            Navigator.pushNamed(context, Routes.billView);
          },
        ),
      );
    }
  }

  Widget customTextButton(
      {required String text, required VoidCallback onPressed}) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: getRegularStyle(
            fontSize: 12.0,
            color: ColorManager.primary,
          ),
        ),
      ),
    );
  }
}
