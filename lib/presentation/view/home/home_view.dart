import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maaa/logic/cubit/home_state/home_state_cubit.dart';
import 'package:maaa/presentation/resources/color_manager.dart';
import 'package:maaa/presentation/resources/enum.dart';
import 'package:maaa/presentation/resources/style_manager.dart';
import 'package:maaa/presentation/widgets/single_form.dart';
import 'package:maaa/resources/validation.dart';

import '../../../logic/bloc/bloc.dart';
import 'customer_list_view.dart';

enum FormType { addCustomer, addReading, payment }

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billtype = context.select((HomeStateCubit value) =>
        value.state.tab == HomeTab.electricBilling
            ? BillType.electricity
            : BillType.water);
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
        onPressed: context.watch<CustomerBloc>().state is CustomerLoading
            ? null
            : () {
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
                        success: (name) {
                          context
                              .read<CustomerBloc>()
                              .add(AddCustomer(name: name, billType: billtype));
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
        // PopupMenuButton(
        //   icon: const Icon(
        //     Icons.more_vert,
        //     size: 35.0,
        //   ),
        //   itemBuilder: (BuildContext context) => _buildPopupMenuList(),
        // ),
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
      child: Container(
        color: Colors.white,
        height: 50.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _homeTabButton(
                selectedTab: selectedTab,
                value: HomeTab.waterBilling,
                icon: FontAwesomeIcons.droplet,
                label: 'Water Billing',
                context: context),
            SizedBox(),
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

  Widget _homeTabButton({
    required HomeTab selectedTab,
    required HomeTab value,
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return TextButton.icon(
      onPressed: context.watch<CustomerBloc>().state is CustomerLoading
          ? null
          : () {
              context.read<HomeStateCubit>().setTab(value);
              context.read<CustomerBloc>().add(
                    LoadCustomerProfileList(
                        billType: value == HomeTab.waterBilling
                            ? BillType.water
                            : BillType.electricity),
                  );
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
    );
  }
}
