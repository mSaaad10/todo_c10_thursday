import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_c10_thursday/database/model/task.dart';
import 'package:todo_app_c10_thursday/database/tasks_dao.dart';
import 'package:todo_app_c10_thursday/providers/auth_provider.dart';
import 'package:todo_app_c10_thursday/utils/dialog_utils.dart';

class TaskItemWidget extends StatefulWidget {
  Task task;

  TaskItemWidget({required this.task});

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: .3,
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              deleteTask();
            },
            backgroundColor: Colors.red,
            padding: EdgeInsets.all(22),
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(18),
        margin: EdgeInsets.all(18),
        //width: double.infinity,
        //height: 18,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    widget.task.title!,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    widget.task.description!,
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Theme.of(context).primaryColor),
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 40,
                  weight: 30,
                )),
          ],
        ),
      ),
    );
  }

  void deleteTask() {
    DialogUtils.showMessage(context, 'Are you sure to delete this task',
        posActionTitle: 'Yes', posAction: () {
      deleteTaskFromFireStore();
    }, negActionTitle: 'No');
  }

  void deleteTaskFromFireStore() async {
    var authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    //DialogUtils.showLoadingDialog(context, 'Deleting tasks...');
    await TasksDao.deleteTask(authProvider.databaseUser!.id!, widget.task.id!);
    // DialogUtils.hideDialog(context);
    // Navigator.pop(context);
    // DialogUtils.showMessage(context, 'Task Deleted successfully', posActionTitle: 'Ok',);
  }
}
