import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maaa/data/model/model.dart';
import 'package:maaa/presentation/widgets/custom_progressindicator.dart';

import '../../../logic/bloc/bloc.dart';
import '../../../logic/cubit/cubit.dart';
import '../../resources/color_manager.dart';
import '../../resources/route_manager.dart';
import '../../resources/style_manager.dart';

class CustomerListView extends StatelessWidget {
  const CustomerListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoading) {
          return const Center(
            child: CustomProgressIndicator(),
          );
        } else if (state is CustomerSuccess) {
          final tab = context.read<HomeStateCubit>().state.tab;

          if (state.customerProfiles.isEmpty) {
            return Center(
              child: Text(
                'No Customer Data.',
                style: getBoldStyle(color: Colors.white, fontSize: 36.0),
              ),
            );
          } else {
            return Scrollbar(
              isAlwaysShown: true,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          tab == HomeTab.waterBilling
                              ? 'Water Billing'
                              : 'Electric Billing',
                          textAlign: TextAlign.center,
                          style:
                              getBoldStyle(fontSize: 36.0, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        DataTable(
                          headingTextStyle:
                              getBoldStyle(color: Colors.white, fontSize: 18.0),
                          dataTextStyle: getRegularStyle(
                              color: Colors.white, fontSize: 14.0),
                          dividerThickness: 3.0,
                          columnSpacing: 0.0,
                          horizontalMargin: 0.0,
                          columns: <DataColumn>[
                            _buildDataColumn(label: 'Customer'),
                            _buildDataColumn(label: 'Date'),
                            _buildDataColumn(label: 'Previous Reading'),
                            _buildDataColumn(label: 'Present Reading'),
                            _buildDataColumn(label: 'Consume'),
                          ],
                          rows: List<DataRow>.generate(
                            state.customerProfiles.length,
                            (index) {
                              WaterBillInfo? currentBillInfo;

                              for (WaterBillInfo waterBillInfo in state
                                  .customerProfiles[index].waterBillsInfo) {
                                if (waterBillInfo.bill != null) {
                                  currentBillInfo = waterBillInfo;
                                }
                              }

                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Align(
                                      alignment: Alignment.center,
                                      child: TextButton(
                                        onPressed: () {
                                          context
                                              .read<CustomerDetailsBloc>()
                                              .add(
                                                LoadCustomerDetails(
                                                  customer: state
                                                      .customerProfiles[index]
                                                      .customer,
                                                ),
                                              );
                                          context
                                              .read<
                                                  CustomerWaterbillHistoryBloc>()
                                              .add(
                                                LoadWaterBillsInfo(
                                                  waterbillsInfo: state
                                                      .customerProfiles[index]
                                                      .waterBillsInfo,
                                                ),
                                              );
                                          Navigator.pushNamed(
                                            context,
                                            Routes.customerView,
                                          );
                                        },
                                        child: Text(
                                          state.customerProfiles[index].customer
                                              .fullName,
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
                                        currentBillInfo == null
                                            ? ''
                                            : DateFormat.yMd().format(
                                                currentBillInfo
                                                    .bill!.dateCreated),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(currentBillInfo == null
                                          ? ''
                                          : currentBillInfo
                                              .bill!.previousReading),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(currentBillInfo == null
                                          ? ''
                                          : currentBillInfo
                                              .bill!.currentReading),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        currentBillInfo == null
                                            ? ''
                                            : currentBillInfo.bill!.consumption
                                                .toString(),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
