import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_c10_thursday/database/users_dao.dart';
import 'package:todo_app_c10_thursday/firebase_error_codes/firebase_error_codes.dart';
import 'package:todo_app_c10_thursday/providers/auth_provider.dart';
import 'package:todo_app_c10_thursday/ui/home/home_screen.dart';
import 'package:todo_app_c10_thursday/ui/register/register_screen.dart';
import 'package:todo_app_c10_thursday/ui/widgets/customm_text_form_field.dart';
import 'package:todo_app_c10_thursday/utils/dialog_utils.dart';
import 'package:todo_app_c10_thursday/utils/email_format.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'Login- Screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/main_background.png'))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('REgister Screen'),
        ),
        body: Container(
          padding: EdgeInsets.all(18),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                    lableText: 'Email',
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please enter a valid input';
                      }
                      if (!isEmailFormatted(input)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    controller: emailController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                    lableText: 'Password',
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please enter password';
                      }
                      if (input.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    controller: passwordController,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: Text('Login')),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, RegisterScreen.routeName);
                    },
                    child: Text("Don't have Account"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    var authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    if (formKey.currentState?.validate() == false) {
      return;
    }
    try {
      DialogUtils.showLoadingDialog(context, 'Loading...',
          isDismissible: false);
      await authProvider.login(emailController.text, passwordController.text);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(
        context,
        'User logged in successfully...',
        isDismissible: false,
        posActionTitle: 'Ok',
        negActionTitle: 'Cancel',
        posAction: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        },
      );
      // Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      //print(credential.user?.uid);
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideDialog(context);
      if (e.code == FirebaseErrorCodes.userNotFound ||
          e.code == FirebaseErrorCodes.wrongPassword) {
        DialogUtils.showMessage(
          context,
          'Wrong email or password',
          posActionTitle: 'Ok',
        );
      }
    }
  }
}
