import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_c10_thursday/database/tasks_dao.dart';
import 'package:todo_app_c10_thursday/providers/auth_provider.dart';
import 'package:todo_app_c10_thursday/ui/widgets/task_item_widget.dart';

class TasksListTab extends StatefulWidget {
  @override
  State<TasksListTab> createState() => _TasksListTabState();
}

class _TasksListTabState extends State<TasksListTab> {
  var selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<MyAuthProvider>(context);
    return Container(
      child: Column(
        children: [
          EasyDateTimeLine(
            initialDate: DateTime.now(),
            onDateChange: (newDate) {
              //`selectedDate` the new date selected.
              selectedDate = newDate;
              setState(() {});
            },
            headerProps: const EasyHeaderProps(
              monthPickerType: MonthPickerType.switcher,
              dateFormatter: DateFormatter.fullDateDMY(),
            ),
            dayProps: const EasyDayProps(
              dayStructure: DayStructure.dayStrDayNum,
              activeDayStyle: DayStyle(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff3371FF),
                      Color(0xff8426D6),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: StreamBuilder(
            stream: TasksDao.listenForTasks(
                authProvider.databaseUser!.id!, selectedDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Text('Something went wrong'),
                      ElevatedButton(
                          onPressed: () {
                            // try again
                          },
                          child: Text('Try Again'))
                    ],
                  ),
                );
              }
              var tasksList = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) =>
                    TaskItemWidget(task: tasksList![index]),
                itemCount: tasksList?.length,
              );
            },
          )),
        ],
      ),
    );
  }
}
