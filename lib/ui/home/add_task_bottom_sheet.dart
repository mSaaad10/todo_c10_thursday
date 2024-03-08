import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_c10_thursday/database/model/task.dart';
import 'package:todo_app_c10_thursday/database/tasks_dao.dart';
import 'package:todo_app_c10_thursday/providers/auth_provider.dart';
import 'package:todo_app_c10_thursday/ui/widgets/customm_text_form_field.dart';
import 'package:todo_app_c10_thursday/utils/dialog_utils.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Task',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextFormField(
              lableText: 'Task title',
              controller: titleController,
              validator: (input) {
                if (input == null || input.trim().isEmpty) {
                  return 'Please enter task title';
                }
                return null;
              },
            ),
            SizedBox(
              height: 12,
            ),
            CustomTextFormField(
              lableText: 'Task description',
              controller: descriptionController,
              maxLines: 4,
              validator: (input) {
                if (input == null || input.trim().isEmpty) {
                  return 'Please enter task description';
                }
                return null;
              },
            ),
            SizedBox(
              height: 18,
            ),
            InkWell(
                onTap: () {
                  showTaskDatePicker();
                },
                child: Text(
                  finalSelectedDate == null
                      ? 'Select Date'
                      : '${finalSelectedDate?.day} / ${finalSelectedDate?.month} / ${finalSelectedDate?.year}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                )),
            SizedBox(
              height: 8,
            ),
            Visibility(
                visible: showDateError,
                child: Text(
                  'Please Select Date',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                )),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: () {
                  addTask();
                },
                child: Text('Add Task')),
          ],
        ),
      ),
    );
  }

  DateTime? finalSelectedDate;

  bool showDateError = false;

  void showTaskDatePicker() async {
    var choosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    finalSelectedDate = choosenDate;
    showDateError = false;

    setState(() {});
  }

  void addTask() async {
    var authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    if (!isValidForm()) {
      return;
    }
    //add task to database
    Task task = Task(
      title: titleController.text,
      description: descriptionController.text,
      dateTime: Timestamp.fromDate(finalSelectedDate!),
    );
    DialogUtils.showLoadingDialog(context, 'Creating task...');
    await TasksDao.addTask(task, authProvider.databaseUser!.id!);
    DialogUtils.hideDialog(context);
    DialogUtils.showMessage(context, 'Task Created successfully',
        posActionTitle: 'Ok', posAction: () {
      Navigator.pop(context);
    });
  }

  bool isValidForm() {
    bool isValid = true;
    if (formKey.currentState?.validate() == false) {
      isValid = false;
    }
    if (finalSelectedDate == null) {
      isValid = false;
      showDateError = true;
      setState(() {});
    }
    return isValid;
  }
}
