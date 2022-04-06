import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maaa/data/provider/local_database.dart';
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => CustomerRepository(localDB: localDB),
        ),
        RepositoryProvider(
          create: (_) => ReadingRepository(localDB: localDB),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CustomerBloc(
                customerRepository: context.read<CustomerRepository>())
              ..add(const LoadCustomerList()),
          ),
          BlocProvider(
            create: (context) => ReadingBloc(
                readingRepository: context.read<ReadingRepository>()),
          ),
          BlocProvider(
            create: (context) => HomeStateCubit(),
          ),
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
