part of 'home_state_cubit.dart';

enum HomeTab { waterBilling, electricBilling }

class HomeState extends Equatable {
  final HomeTab tab;

  const HomeState({this.tab = HomeTab.waterBilling});

  @override
  List<Object> get props => [tab];
}
