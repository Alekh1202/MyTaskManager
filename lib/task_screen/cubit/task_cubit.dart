import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:taskapp/models/task.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskLoaded> {
  final Box<String> taskBox;
  final String key = 'tasks';

  TaskCubit(this.taskBox) : super(TaskLoaded(null));

// This method is called to load tasks from the Hive box
  // It decodes the JSON string stored in the box and emits a TaskLoaded state
  // with the list of tasks.
  void loadTasks() {
    final tasksString = taskBox.get(key, defaultValue: '[]');
    final List<dynamic> jsonList = jsonDecode(tasksString!);
    final tasks = jsonList.map((e) => Task.fromJson(e)).toList();
    emit(TaskLoaded(tasks));
  }



// This method is called to add a new task.
  // It creates a new Task object with the provided title, assigns it an ID,
  // and adds it to the list of current tasks.
  void addTask(String tile) async {
    final tasks = _getCurrentTasks();
    final newTask = Task(title: tile, isDone: false, id: tasks.length + 1);
    tasks.add(newTask);
    await _saveTasks(tasks);
  }

// This method is called to update an existing task.
  // It checks if the task exists in the current tasks, updates it,
  // and saves the updated list back to the Hive box. 

  void updateTask(Task task) async {
    final tasks = _getCurrentTasks();
    if (tasks.isNotEmpty && tasks.any((t) => t.id == task.id)) {
      final index = tasks.indexWhere((t) => t.id == task.id);
      tasks[index] = task;
      await _saveTasks(tasks,indexUpdated: index);
    }
  }

// This method is called to delete a task.
  // It checks if the task exists in the current tasks, removes it,
  // and saves the updated list back to the Hive box.

  void deleteTask(Task task) async {
    final tasks = _getCurrentTasks();
    if (tasks.isNotEmpty && tasks.any((t) => t.id == task.id)) {
      tasks.removeWhere((t) => t.id == task.id);
      await _saveTasks(tasks);
    }
  }


  // This method retrieves the current tasks from the Hive box,
  // decodes the JSON string, and returns a list of Task objects.

  List<Task> _getCurrentTasks() {
    final tasksString = taskBox.get(key, defaultValue: '[]');
    final List jsonList = jsonDecode(tasksString!);
    return jsonList.map((e) => Task.fromJson(e)).toList();
  }

// This method saves the list of tasks to the Hive box
  // It encodes the list of Task objects to JSON and stores it in the box.
  Future<void> _saveTasks(List<Task> tasks, {int? indexUpdated}) async {
    final jsonList = tasks.map((e) => e.toJson()).toList();
    await taskBox.put(key, jsonEncode(jsonList));
    emit(TaskLoaded(tasks, lastUpdatedIndex: indexUpdated));
  }
}
