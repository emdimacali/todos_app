import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:todos_app/home/home.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state.tasks.isEmpty) {
          if (state.status == TaskStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status != TaskStatus.success) {
            return const SizedBox();
          } else {
            return const Center(
              child: Text(
                'Add a Task using the Floating Button',
              ),
            );
          }
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return TaskStatsChip(
                completedTasks: state.completedTasks,
                pendingTasks: state.pendingTasks,
              );
            }

            return TaskListTile(
              task: state.tasks[index - 1],
            );
          },
          itemCount: state.tasks.length + 1,
        );
      },
    );
  }
}
