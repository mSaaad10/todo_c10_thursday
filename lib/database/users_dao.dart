// Dao -> Data access object
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_c10_thursday/database/model/user_model.dart';

class UsersDao {
  static CollectionReference<User> getUsersCollection() {
    var db = FirebaseFirestore.instance;
    var usersCollection = db.collection('users').withConverter<User>(
          fromFirestore: (snapshot, options) =>
              User.fromFireStore(snapshot.data()),
          toFirestore: (user, options) => user.toFireStore(),
        );
    return usersCollection;
  }

  static Future<void> createUser(User user) {
    // insert user into fireStore
    var usersCollection = getUsersCollection();
    var doc =
        usersCollection.doc(user.id); // create doc with uid (authentication)
    return doc.set(user);
  }

  static Future<User?> getUser(String uid) async {
    var usersCollection = getUsersCollection();
    var docSnapshot = await usersCollection.doc(uid).get();
    return docSnapshot.data();
  }
}
