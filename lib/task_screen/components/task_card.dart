import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/models/task.dart';
import 'package:taskapp/task_screen/cubit/task_cubit.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.index});
  final int index;

  Color _getTextColor(bool isDone) {
    return isDone ? Colors.green : Colors.orange;
  }

  Color _getColor(bool isDone) {
    return isDone
        ? Colors.green.withValues(alpha: 0.2)
        : Colors.orange.withValues(alpha: 0.2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskLoaded>(
      // // This will rebuild the widget when the tasks change or when a specific task is updated
      // // lastUpdatedIndex is used to determine if the specific task at index has been updated
      // // This is useful to avoid unnecessary rebuilds of all tasks when only one task is updated
      buildWhen:
          (previous, current) =>
              current.lastUpdatedIndex == index ||
              previous.tasks?.length != current.tasks?.length,
      builder: (context, state) {
        final task = state.tasks!.elementAt(index);
        return ListTile(
          tileColor: _getColor(task.isDone),
          subtitle: Text(
            task.isDone ? 'Completed' : 'Pending',
            style: TextStyle(color: _getTextColor(task.isDone)),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              color: _getTextColor(task.isDone),
              decoration:
                  task.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
            ),
          ),
          leading: Checkbox(
            checkColor: Colors.black,

            value: task.isDone,

            onChanged: (val) {
              // This will toggle the task's completion status
              // and update the task in the state
              if (val == null) return; // Handle null case
              final updated = Task(
                title: task.title,
                isDone: !task.isDone,
                id: task.id,
              );
              context.read<TaskCubit>().updateTask(updated);
            },
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed:
                    () => _showTaskDialog(
                      context,
                      task: state.tasks!.elementAt(index),
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red.withValues(alpha: 0.7),
                onPressed:
                    () => _showTaskDialog(
                      context,
                      task: state.tasks!.elementAt(index),
                      isDelete: true,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  // This function shows a dialog to edit or delete a task
  // If isDelete is true, it shows a confirmation dialog for deletion
  // If isDelete is false or null, it shows a dialog to edit the task title
  // The dialog contains a TextField to edit the task title
  // and buttons to save or cancel the changes
  void _showTaskDialog(
    BuildContext context, {
    Task? task,
    bool isDelete = false,
  }) {
    final titleController = TextEditingController(text: task?.title ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isDelete ? 'Do you want to delete this task?' : 'Edit Task',
          ),
          content: TextField(
            controller: titleController,
            enabled: !isDelete,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          actions: [
            isDelete
                ? TextButton(
                  onPressed: () {
                    context.read<TaskCubit>().deleteTask(task!);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                )
                : TextButton(
                  onPressed: () {
                    // This will update the task with the new title
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Title cannot be empty')),
                      );
                      return;
                    }
                    
                    if (task != null) {
                      final updatedTask = Task(
                        title: titleController.text,
                        isDone: task.isDone,
                        id: task.id,
                      );
                      context.read<TaskCubit>().updateTask(updatedTask);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
