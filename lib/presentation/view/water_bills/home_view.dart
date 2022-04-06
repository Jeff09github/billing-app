import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maaa/logic/cubit/home_state/home_state_cubit.dart';
import 'package:maaa/presentation/resources/color_manager.dart';
import 'package:maaa/presentation/resources/style_manager.dart';
import 'package:maaa/presentation/view/water_bills/customer_list_view.dart';
import 'package:maaa/presentation/widgets/single_form.dart';
import 'package:maaa/resources/validation.dart';

import '../../../data/model/model.dart';
import '../../../logic/bloc/bloc.dart';

enum FormType { addCustomer, addReading, payment }

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: CustomAppBar(),
      ),
      body: const CustomerListView(),
      bottomNavigationBar: const CustomBottomNavigation(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

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

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.watch<HomeStateCubit>().state.tab;
    return BottomAppBar(
      clipBehavior: Clip.hardEdge,
      notchMargin: 5.0,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 50.0,
        child: Row(
          children: [
            _homeTabButton(
                selectedTab: selectedTab,
                value: HomeTab.waterBilling,
                icon: FontAwesomeIcons.droplet,
                label: 'Water Billing',
                context: context),
            _homeTabButton(
                selectedTab: selectedTab,
                value: HomeTab.electricBilling,
                icon: FontAwesomeIcons.boltLightning,
                label: 'Electric Billing',
                context: context),
          ],
        ),
      ),
    );
  }

  Expanded _homeTabButton({
    required HomeTab selectedTab,
    required HomeTab value,
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return Expanded(
      child: TextButton.icon(
        onPressed: () {
          context.read<HomeStateCubit>().setTab(value);
        },
        icon: FaIcon(
          icon,
          color: value != selectedTab ? Colors.grey : ColorManager.primary,
        ),
        label: Text(
          label,
          style: getBoldStyle(
              fontSize: 18.0,
              color: value != selectedTab ? Colors.grey : ColorManager.primary),
        ),
      ),
    );
  }
}
