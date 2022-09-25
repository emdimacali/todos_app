import 'package:tasks_api/tasks_api.dart';

abstract class TasksApi {
  const TasksApi();

  /// Provides a [Stream] of all tasks
  Stream<List<Task>> getTasks();

  /// Saves a [Task]
  ///
  /// If similar [id] already exists, replace it. Otherwise,
  /// it will be added.
  Future<void> saveTask(Task task);

  /// Deletes a [Task]
  ///
  /// If no [Task] with the [id] is found, throw a [TaskNotFoundException].
  Future<void> deleteTask(String id);
}

/// Error thrown when a [Task] with a given id does not exist
class TaskNotFoundException implements Exception {}
