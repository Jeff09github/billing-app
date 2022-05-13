import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maaa/logic/bloc/bloc.dart';
import 'package:maaa/presentation/resources/color_manager.dart';
import 'package:maaa/presentation/widgets/custom_progressindicator.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({Key? key}) : super(key: key);

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build;
    return BlocBuilder<CustomerDetailsBloc, CustomerDetailsState>(
      builder: (context, state) {
        if (state is CustomerDetailsLoading) {
          return const CustomProgressIndicator();
        } else if (state is CustomerDetailsSuccess) {
          return Scaffold(
            backgroundColor: ColorManager.primary,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_pin_rounded,
                    size: 100.0,
                    color: ColorManager.secondary,
                  ),
                  Text(state.customer.fullName),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Customer Details Failed'),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
