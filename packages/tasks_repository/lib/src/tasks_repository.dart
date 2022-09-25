import 'package:tasks_api/tasks_api.dart';

class TasksRepository {
  const TasksRepository({
    required TasksApi tasksApi,
  }) : _tasksApi = tasksApi;

  final TasksApi _tasksApi;

  /// Provides a [Stream] of all tasks.
  Stream<List<Task>> getTasks() => _tasksApi.getTasks();

  /// Saves a [todo].
  ///
  /// If a [todo] with the same id already exists, it will be replaced.
  Future<void> saveTask(Task task) => _tasksApi.saveTask(task);

  /// Deletes the todo with the given id.
  ///
  /// If no todo with the given id exists, a [TodoNotFoundException] error is
  /// thrown.
  Future<void> deleteTask(String id) => _tasksApi.deleteTask(id);
}
