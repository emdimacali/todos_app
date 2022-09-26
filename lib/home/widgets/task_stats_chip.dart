import 'package:flutter/material.dart';

class TaskStatsChip extends StatelessWidget {
  final int pendingTasks;
  final int completedTasks;

  const TaskStatsChip({
    Key? key,
    required this.pendingTasks,
    required this.completedTasks,
  }) : super(key: key);

  int get totalTasks => pendingTasks + completedTasks;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Chip(
            label: Text(
                'PENDING: $pendingTasks | COMPLETED: $completedTasks | TOTAL: $totalTasks')),
      ],
    );
  }
}
