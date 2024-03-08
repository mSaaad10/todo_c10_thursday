import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_c10_thursday/database/model/user_model.dart' as MyUser;
import 'package:todo_app_c10_thursday/database/users_dao.dart';
import 'package:todo_app_c10_thursday/firebase_error_codes/firebase_error_codes.dart';
import 'package:todo_app_c10_thursday/providers/auth_provider.dart';
import 'package:todo_app_c10_thursday/ui/login/login_screen.dart';
import 'package:todo_app_c10_thursday/ui/widgets/customm_text_form_field.dart';
import 'package:todo_app_c10_thursday/utils/dialog_utils.dart';
import 'package:todo_app_c10_thursday/utils/email_format.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'Register- Screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var fullNameController = TextEditingController();

  var emailController = TextEditingController();

  var userNameController = TextEditingController();

  var passwordController = TextEditingController();

  var passwordConfirmationController = TextEditingController();

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
                    lableText: 'Full Name',
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please enter a valid input';
                      }
                      return null;
                    },
                    controller: fullNameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                    lableText: 'User Name',
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please enter a valid input';
                      }
                      return null;
                    },
                    controller: userNameController,
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                    lableText: 'Password confirmation',
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please enter password';
                      }
                      if (input.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      if (passwordController.text !=
                          passwordConfirmationController.text) {
                        return 'Password  confirmation not match';
                      }
                      return null;
                    },
                    controller: passwordConfirmationController,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      createAccount();
                    },
                    child: Text('Create Account')),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    },
                    child: Text('Already have Account ?'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createAccount() async {
    var authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    if (formKey.currentState?.validate() == false) {
      return;
    }
    // create account
    try {
      DialogUtils.showLoadingDialog(context, 'Loading...');
      await authProvider.register(emailController.text, passwordController.text,
          fullNameController.text, userNameController.text);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, 'Registered successfully...',
          isDismissible: false, posActionTitle: 'Ok', posAction: () {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      });
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideDialog(context);
      if (e.code == FirebaseErrorCodes.weakPassword) {
        DialogUtils.showMessage(context, 'The password provided is too weak.',
            posActionTitle: 'Ok', isDismissible: false);
        //print('The password provided is too weak.');
      } else if (e.code == FirebaseErrorCodes.emailAlreadyInUse) {
        DialogUtils.showMessage(
            context, 'The account already exists for that email.',
            posActionTitle: 'Ok', isDismissible: false);
        //print('The account already exists for that email.');
      }
    } catch (e) {
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, 'Something went wrong...',
          posActionTitle: 'Ok', isDismissible: false);
    }
  }
}
