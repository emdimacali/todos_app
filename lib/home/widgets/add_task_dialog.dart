import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:todos_app/home/home.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late final TextEditingController taskNameController;
  String? taskPriority = TaskPriority.normal;

  @override
  void initState() {
    taskNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: taskNameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              value: taskPriority,
              items: const [
                DropdownMenuItem(
                    child: Text(TaskPriority.low), value: TaskPriority.low),
                DropdownMenuItem(
                    child: Text(TaskPriority.normal),
                    value: TaskPriority.normal),
                DropdownMenuItem(
                    child: Text(TaskPriority.high), value: TaskPriority.high),
              ],
              onChanged: (value) {
                setState(() {
                  taskPriority = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<TaskBloc>().add(
                          TaskAdded(taskNameController.text, taskPriority!));
                    },
                    child: const Text('Add')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
