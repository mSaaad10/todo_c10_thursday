import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_c10_thursday/database/model/user_model.dart' as MyUser;
import 'package:todo_app_c10_thursday/database/users_dao.dart';

class MyAuthProvider extends ChangeNotifier {
  MyUser.User? databaseUser;
  User? firebaseAuthUser;

  Future<void> register(
      String email, String password, String fullName, String userName) async {
    var credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await UsersDao.createUser(MyUser.User(
      id: credential.user?.uid,
      fullName: fullName,
      userName: userName,
      email: email,
    ));
  }

  Future<void> login(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    var user = await UsersDao.getUser(credential.user!.uid);
    databaseUser = user;
    firebaseAuthUser = credential.user;
  }
}
