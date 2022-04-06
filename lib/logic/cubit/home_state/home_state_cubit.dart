import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state_state.dart';

class HomeStateCubit extends Cubit<HomeState> {
  HomeStateCubit() : super(const HomeState());

  void setTab(HomeTab tab) => emit(HomeState(tab: tab));
  
}
