import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_c10_thursday/database/model/task.dart';
import 'package:todo_app_c10_thursday/database/users_dao.dart';

class TasksDao {
  static CollectionReference<Task> getTasksCollection(String uid) {
    return UsersDao.getUsersCollection()
        .doc(uid)
        .collection(Task.collectionName)
        .withConverter<Task>(
          fromFirestore: (snapshot, options) =>
              Task.fromFireStore(snapshot.data()),
          toFirestore: (task, options) => task.toFireStore(),
        );
  }

  static Future<void> addTask(Task task, String uid) {
    var tasksCollection = getTasksCollection(uid);
    var docRef = tasksCollection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<List<Task>> getAllTasks(String uid) async {
    var tasksSnapShot = await getTasksCollection(uid).get();

    var tasksList = tasksSnapShot.docs.map((e) => e.data()).toList();
    return tasksList;
  }

  static Stream<List<Task>> listenForTasks(
      String uid, DateTime selectedDate) async* {
    // var tasksCollection = getTasksCollection(uid);
    // var stream = await tasksCollection.snapshots();
    // stream.map((event) => event.docs.map
    //   ((e) => e.data()).toList());
    // var finalSelectedDate = selectedDate.copyWith(
    //   hour: 0,
    // minute: 0,
    //   millisecond: 0,
    //   microsecond: 0,
    //   second: 0,m
    //
    // );
    var tasksCollection = getTasksCollection(uid);
    var stream = tasksCollection
        .where(
          'dateTime',
          isEqualTo: selectedDate,
        )
        .snapshots();
    yield* stream.map(
        (querySnapShot) => querySnapShot.docs.map((e) => e.data()).toList());
  }

  static Future<void> deleteTask(String uid, String taskId) {
    var tasksCollection = getTasksCollection(uid);
    return tasksCollection.doc(taskId).delete();
  }
}
