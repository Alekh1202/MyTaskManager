import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/task_screen/components/task_card.dart';
import 'package:taskapp/task_screen/cubit/task_cubit.dart';

class TaskViewScreen extends StatelessWidget {
  const TaskViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<TaskCubit, TaskLoaded>(
        buildWhen:
            (previous, current) =>
                previous.tasks?.length != current.tasks?.length,
        builder: (context, state) {
          if (state.tasks != null && state.tasks!.isNotEmpty) {
            final tasks = state.tasks;
            return ListView.separated(
              padding: const EdgeInsets.only(top: 12),
              separatorBuilder: (context, index) => SizedBox(height: 2),
              itemCount: tasks!.length,
              itemBuilder: (context, index) => TaskCard(index: index),
            );
          } else if (state.tasks != null && state.tasks!.isEmpty) {
            return const Center(child: Text('No tasks available'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: ElevatedButton(
        
        onPressed: () => _showAddTaskDialog(context),
        child: Text(
          '+ New Task',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text.trim();
                context.read<TaskCubit>().addTask(title);

                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
