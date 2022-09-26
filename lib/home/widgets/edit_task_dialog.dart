import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:todos_app/home/home.dart';

class EditTaskDialog extends StatefulWidget {
  const EditTaskDialog({super.key});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late final TextEditingController taskNameController;
  late String taskPriority;

  @override
  void initState() {
    taskNameController = TextEditingController();
    taskPriority = TaskPriority.normal;

    // taskNameController = TextEditingController(
    //     text: context.read<TaskBloc>().state.taskBeingEdited!.taskName);
    // taskPriority = context.read<TaskBloc>().state.taskBeingEdited!.taskPriority;

    super.initState();
  }

  @override
  void dispose() {
    taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state.status == TaskStatus.success) {
          taskNameController.text =
              context.read<TaskBloc>().state.taskBeingEdited!.taskName;
          setState(() {
            taskPriority =
                context.read<TaskBloc>().state.taskBeingEdited!.taskPriority;
          });
        }
      },
      child: Dialog(
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
                    taskPriority = value ?? TaskPriority.normal;
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
                        // context.read<TaskBloc>().add(
                        //     TaskAdded(taskNameController.text, taskPriority!));
                      },
                      child: const Text('Delete')),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<TaskBloc>().add(TaskUpdated(
                              taskName: taskNameController.text,
                              taskPriority: taskPriority,
                            ));
                      },
                      child: const Text('Edit')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
