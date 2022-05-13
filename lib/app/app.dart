import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maaa/data/provider/bluetooth_therman_printer.dart';
import 'package:maaa/data/provider/local_database.dart';
import 'package:maaa/logic/bloc/customer_waterbill_history/customer_waterbill_history_bloc.dart';
import 'package:maaa/logic/cubit/cubit.dart';
import 'package:maaa/logic/cubit/home_state/home_state_cubit.dart';

import 'package:maaa/presentation/resources/route_manager.dart';
import '../logic/bloc/bloc.dart';
import '../data/repository/repository.dart';
import '../presentation/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp instance = MyApp._internal();

  factory MyApp() => instance;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final localDB = LocalDatabase.instance;
    final bluetoothThermalPrinter = BluetoothThermalPrinter();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => LocalDatabaseRepository(localDB: localDB),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CustomerBloc(
              localDatabaseRepository: context.read<LocalDatabaseRepository>(),
            )..add(const LoadCustomerProfileList()),
          ),
          BlocProvider(
            create: (context) => CustomerDetailsBloc(
              localDatabaseRepository: context.read<LocalDatabaseRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CustomerWaterbillHistoryBloc(
              customerBloc: context.read<CustomerBloc>(),
              localDatabaseRepository: context.read<LocalDatabaseRepository>(),
            ),
          ),
          // BlocProvider(
          //   create: (context) => CustomerReadingsBloc(
          //       localDatabaseRepository:
          //           context.read<LocalDatabaseRepository>(),
          //       customerDetailsBloc: context.read<CustomerDetailsBloc>()),
          // ),
          BlocProvider(
            create: (context) => HomeStateCubit(),
          ),
          BlocProvider(
            create: (context) => BillViewCubit(
                bluetoothThermalPrinter: bluetoothThermalPrinter,
                customerDetailsBloc: context.read<CustomerDetailsBloc>()),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) => RouteGenerator.getRoute(settings),
          initialRoute: Routes.splashRoute,
          theme: getApplicationTheme(),
        ),
      ),
    );
  }
}
