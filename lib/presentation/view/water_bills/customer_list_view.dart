import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maaa/data/model/model.dart';

import '../../../logic/bloc/bloc.dart';
import '../../../data/arguments/reading_history_args.dart';
import '../../../resources/validation.dart';
import '../../resources/color_manager.dart';
import '../../resources/enum.dart';
import '../../resources/route_manager.dart';
import '../../resources/style_manager.dart';
import '../../widgets/single_form.dart';

class CustomerListView extends StatelessWidget {
  const CustomerListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CustomerSuccess) {
          if (state.customers.isEmpty) {
            return Center(
              child: Text(
                'No Customer Data.',
                style: getBoldStyle(color: Colors.white, fontSize: 36.0),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  headingTextStyle:
                      getBoldStyle(color: Colors.white, fontSize: 18.0),
                  dataTextStyle:
                      getRegularStyle(color: Colors.white, fontSize: 14.0),
                  dividerThickness: 3.0,
                  border: TableBorder.all(color: Colors.white),
                  columnSpacing: 0.0,
                  horizontalMargin: 0.0,
                  columns: <DataColumn>[
                    _buildDataColumn(label: 'Customer'),
                    _buildDataColumn(label: 'Previous Reading'),
                    _buildDataColumn(label: 'Current Reading'),
                    _buildDataColumn(label: 'New Reading'),
                  ],
                  rows: List<DataRow>.generate(
                    state.customers.length,
                    (index) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.customerReadingHistory,
                                    arguments: ReadingHistoryArgs(
                                        customer: state.customers[index],
                                        billType: BillType.water),
                                  );
                                },
                                child: Text(
                                  state.customers[index].fullName,
                                  style: getRegularStyle(
                                      color: ColorManager.primary),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                state.customers[index].previousReading ?? '',
                              ),
                            ),
                          ),
                          DataCell(
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                state.customers[index].currentReading ?? '',
                              ),
                            ),
                          ),
                          DataCell(
                            Align(
                              alignment: Alignment.center,
                              child: IconButton(
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
                                        validation:
                                            Validation().readingValidation,
                                        success: (value) {
                                          final reading = Reading(
                                              customerId:
                                                  state.customers[index].id!,
                                              reading: value,
                                              billType: BillType.water,
                                              createdAt: DateTime.now());
                                          context.read<ReadingBloc>().add(
                                                AddReading(
                                                    reading: reading,
                                                    customer:
                                                        state.customers[index]),
                                              );
                                          context.read<CustomerBloc>().add(
                                                const LoadCustomerList(),
                                              );
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          // DataCell(
                          //   Align(
                          //     alignment: Alignment.center,
                          //     child: TextButton(
                          //       onPressed: () {
                          //         showModalBottomSheet(
                          //           isDismissible: false,
                          //           isScrollControlled: true,
                          //           clipBehavior: Clip.hardEdge,
                          //           context: context,
                          //           builder: (context) {
                          //             return SingleForm(
                          //               keyboardInputType: TextInputType.number,
                          //               label: 'Enter New Reading',
                          //               validation:
                          //                   Validation().readingValidation,
                          //               success: (value) {

                          //               },
                          //             );
                          //           },
                          //         );
                          //       },
                          //       child: Text(
                          //         'CREATE',
                          //         style: getRegularStyle(
                          //           color: ColorManager.primary,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          }
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
      },
    );
  }

  DataColumn _buildDataColumn({required String label}) {
    return DataColumn(
      label: Expanded(
        child: Text(
          label,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ),
    );
  }
}
