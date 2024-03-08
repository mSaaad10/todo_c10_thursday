import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_c10_thursday/firebase_options.dart';
import 'package:todo_app_c10_thursday/providers/auth_provider.dart';
import 'package:todo_app_c10_thursday/ui/home/home_screen.dart';
import 'package:todo_app_c10_thursday/ui/login/login_screen.dart';
import 'package:todo_app_c10_thursday/ui/register/register_screen.dart';
import 'package:todo_app_c10_thursday/ui/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => MyAuthProvider(), child: MyApplication()));
}

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        SplashScreen.routeName: (context) => SplashScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
      },
      initialRoute: RegisterScreen.routeName,
      theme: ThemeData(useMaterial3: false),
    );
  }
}
