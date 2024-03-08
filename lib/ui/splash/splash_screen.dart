import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app_c10_thursday/ui/register/register_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'Splash-Screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFDFECDB),
      child: Image.asset('assets/images/logo.png'),
    );
  }
}
