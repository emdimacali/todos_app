import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:todos_app/home/home.dart';

class TaskListTile extends StatelessWidget {
  final Task task;

  const TaskListTile({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: CheckboxListTile(
        value: task.isCompleted,
        controlAffinity: ListTileControlAffinity.leading,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.taskName),
            if (task.taskPriority == TaskPriority.high)
              const HighPriorityChip(),
            if (task.taskPriority == TaskPriority.normal)
              const NormalPriorityChip(),
            if (task.taskPriority == TaskPriority.low) const LowPriorityChip(),
          ],
        ),
        secondary: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            print('MORE BUTTON WAS PRESSED');
          },
        ),
        onChanged: (isTicked) {
          context.read<TaskBloc>().add(TaskTicked(task));
        },
      ),
    );
  }
}
