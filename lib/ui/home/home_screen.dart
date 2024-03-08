import 'package:flutter/material.dart';
import 'package:todo_app_c10_thursday/ui/home/add_task_bottom_sheet.dart';
import 'package:todo_app_c10_thursday/ui/home/settings_tab/settings_tab.dart';
import 'package:todo_app_c10_thursday/ui/home/tasks_list_tab/tasks_list_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'Home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Widget> tabs = [
    TasksListTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xFFDFECDB),
      appBar: AppBar(
        title: Text('Route ToDo App'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddTaskBottomSheet();
          },
          child: Icon(Icons.add),
          shape:
              StadiumBorder(side: BorderSide(width: 4, color: Colors.white))),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.menu), label: 'Tasks List'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings')
          ],
        ),
      ),
      body: tabs[selectedIndex],
    );
  }

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddTaskBottomSheet(),
    );
  }
}
