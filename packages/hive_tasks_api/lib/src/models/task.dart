import 'package:hive/hive.dart';
import 'package:tasks_api/tasks_api.dart' as tasksApi;

part 'task.g.dart';

/// !Important: Do not change this typeId as this might cause problems
@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String taskName;

  @HiveField(2)
  final String taskPriority;

  @HiveField(3)
  final bool isCompleted;

  Task({
    required this.id,
    required this.taskName,
    required this.taskPriority,
    required this.isCompleted,
  });

  Task.fromTaskModel(tasksApi.Task task)
      : id = task.id,
        taskName = task.taskName,
        taskPriority = task.taskPriority,
        isCompleted = task.isCompleted;

  tasksApi.Task toTaskModel() {
    return tasksApi.Task(
      id: id,
      taskName: taskName,
      taskPriority: taskPriority,
      isCompleted: isCompleted,
    );
  }
}
