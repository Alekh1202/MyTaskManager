import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskapp/task_screen/task_view_screen.dart';
import 'task_screen/cubit/task_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  final taskBox = await Hive.openBox<String>('taskBox');
  runApp(MyApp(taskBox: taskBox));
}

class MyApp extends StatelessWidget {
  final Box<String> taskBox;
  const MyApp({super.key, required this.taskBox});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskCubit(taskBox)..loadTasks(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Tracker',
        theme: ThemeData(
          primaryColor: Colors.black,
          primarySwatch: Colors.blue,
            elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 10,
              textStyle: const TextStyle(color: Colors.white),
            ),
            ),
            textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: const TextStyle(color: Colors.black),
            ),
            ),
            checkboxTheme: CheckboxThemeData(
              
           checkColor : WidgetStateProperty.all(Colors.black),
             fillColor: WidgetStateProperty.all(Colors.white),
            side: const BorderSide(color: Colors.black),
            ),
          ),
        home: const TaskViewScreen(),
      ),
    );
  }
}
