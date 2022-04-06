import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maaa/data/provider/local_database.dart';
import 'package:maaa/presentation/resources/color_manager.dart';

import '../resources/route_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  String text = 'Billing App...';

  late AnimationController _animationController;
  late Animation<int> alpha;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _startTimer();
  }

  void _startAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    alpha = IntTween(begin: 1, end: text.length).animate(_animationController);
  }

  Future<void> _startTimer() async {
    await Future.delayed(const Duration(seconds: 5));
    await LocalDatabase.instance.database;
    _next();
    // timer = Timer(const Duration(seconds: 8), _next);
  }

  void _next() async {
    Navigator.pushReplacementNamed(context, Routes.selectionRoute);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          child: Text(text, style: Theme.of(context).textTheme.headline1),
          builder: (context, child) {
            return Text(text.substring(0, alpha.value),
                style: Theme.of(context).textTheme.headline1);
          },
        ),
      ),
    );
  }
}
